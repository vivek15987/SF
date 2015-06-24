global class Nano2_YardiGCPullUnitBatch implements Database.Batchable<Property__c>, Database.AllowsCallouts{
	public List<Property__c> arrobjProperties = new List<Property__c>();
    
    global Nano2_YardiGCPullUnitBatch() {}
    
    global Iterable<Property__c> start(Database.BatchableContext BC) {
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
            
            arrobjProperties = [SELECT 
                                 	Id, Name, Account__c, Account__r.Name, Customer_Prop_ID__c, Last_Unit_Pull__c, Group_Membership__c, Group_Membership__r.Name
                                 FROM 
                                 	Property__c 
                                 WHERE
                                	Customer_Prop_ID__c != NULL
                                 	AND ( ( Group_Membership__c IN : GroupingIds ) OR ( Account__c IN : AccountIds AND Group_Membership__c = NULL ) ) 
                                	AND Multi_Family_Property__c = false
                                 ORDER BY
                                 	Last_Unit_Pull__c ASC, Account__c
                               	];
            
        }
        
        return this.arrobjProperties;
    }
    
    global void execute(Database.BatchableContext BC, List<Property__c> scope){
       	Set<ID> AccountIds 		= new Set<ID>();
        Set<ID> PropertyIds 	= new Set<ID>();
        
        for( Property__c Property: scope ) {
            AccountIds.add( Property.Account__c );
            PropertyIds.add( Property.Id );
        }
        
        YardiGCPullUnitController YGCPullUnit = new YardiGCPullUnitController();
        YGCPullUnit.AccountIds = AccountIds;
        YGCPullUnit.PropertyIds = PropertyIds;
		
        YGCPullUnit.YardiGCPullUnit();
        
        upsert YGCPullUnit.arrobjUnits;
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}