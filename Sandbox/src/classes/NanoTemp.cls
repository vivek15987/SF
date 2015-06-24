global with sharing class NanoTemp implements Database.Batchable<Property__c>, Database.Stateful, Database.AllowsCallouts {
	global Map<Integer, Set<Id>> attachmentMap;
	global List<Set<Id>> attachmentList;
	global Integer batchlimit = 150;
	global Integer batchNumber = 4;
	global NanoTemp() {
		attachmentMap = new Map<Integer, Set<Id>>();
		attachmentList = new List<Set<Id>>();
		
	}
	
	global NanoTemp( Integer bLimit, Integer bNumber ) {
		batchNumber = bNumber;
		batchlimit = bLimit;
		attachmentMap = new Map<Integer, Set<Id>>();
		attachmentList = new List<Set<Id>>();
		
	}
	
	global Iterable<Property__c> start( Database.BatchableContext BC ) {
        List<Property__c> props = new List<Property__c>();
        
        List<Integration__c> searchList = [ SELECT 
                                           		Id, Account__c, Name, Grouping__c
                                           	FROM
                                           		Integration__c
                                           	WHERE
                                           		Yardi_Integration_Active__c = true 
                                           		AND Yardi_Availability_Pricing__c != null 
                                          ];
        
        Set<String> AccountIds = new Set<String>();
        Set<String> GroupingIds = new Set<String>();
        
        if( !searchList.isEmpty() ) {
            for( Integration__c I :searchList ) { 
                if( null != I.Grouping__c && !GroupingIds.contains( I.Grouping__c ) ) {
                    GroupingIds.add( I.Grouping__c );
                } else if( !AccountIds.contains( I.Account__c ) ) {
                    AccountIds.add( I.Account__c );
                }         
            }
            
            props = [SELECT 
                     Id, Name, Account__c, Account__r.Name, Customer_Prop_ID__c, Multi_Family_Property__c, Last_Yardi_FloorPlan_Pull__c, Group_Membership__c, Group_Membership__r.Name
                     FROM 
                     Property__c 
                     WHERE
                     Customer_Prop_ID__c != NULL
                     AND ( ( Group_Membership__c IN : GroupingIds ) OR ( Account__c IN : AccountIds AND Group_Membership__c = NULL ) ) 
                     ORDER BY
                     Last_Yardi_FloorPlan_Pull__c ASC, Account__c
                    ];
        }
        return props;
		
	}
	
	global void execute( Database.BatchableContext BC, List<Property__c> scope ) {
        List<Property__c> attachList = (List<Property__c>) scope;
		
		
		for(  Property__c attach : attachList ) {
			if( attachmentList.size() == 0 ) {
				Set<Id> attachIds = new Set<Id>();
				attachmentList.add( attachIds );
			}
			
			Set<Id> currentAttachIdSet = attachmentList[attachmentList.size() - 1];
			
			if( currentAttachIdSet.size() == batchlimit ) {
				Set<Id> attachIdsNew = new Set<Id>();
				attachIdsNew.add(attach.Id);
				attachmentList.add(attachIdsNew);
			
			} else {
				currentAttachIdSet.add(attach.Id);
			}
		}
	}
	
	global void finish( Database.BatchableContext BC ) {
        
        
		for( Integer i = 0; i < batchNumber; i++ ) {
            System.debug( attachmentList[i].size() );
            YardiGCPullFloorPlanBatch objBatch = new YardiGCPullFloorPlanBatch();
            objBatch.PropertyIds.addAll( attachmentList[i] );
            Database.executeBatch( objBatch, 50 );
		
		}
        
	}
}