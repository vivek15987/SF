global class RMPullFloorPlansBatch implements Database.Batchable<Property__c>, Database.AllowsCallouts{
	public List<Property__c> arrobjProperties = new List<Property__c>();
    
    global RMPullFloorPlansBatch() {}
    
    global Iterable<Property__c> start(Database.BatchableContext BC) {
        List<Integration__c> Integrations = [
                                                SELECT
                                                    Id, Name, Account__c, Grouping__c
                                                FROM
                                                    Integration__c
                                                WHERE
            										ResMan_Integration_Active__c = true
                                                    AND Get_ResMan_FloorPlans__c != NULL 
                                                    AND ResMan_Account_Id__c != NULL
                                            ];
        
        if( !Integrations.isEmpty() ) {
            Set<String> AccountIds = new Set<String>();
            Set<String> GroupingIds = new Set<String>();
            
            for( Integration__c I: Integrations ) {
                if( null != I.Grouping__c && !GroupingIds.contains( I.Grouping__c ) ) {
                    GroupingIds.add( I.Grouping__c );
                } else if( !AccountIds.contains( I.Account__c ) ) {
                    AccountIds.add( I.Account__c );
                } 
            }
            
            this.arrobjProperties = [ SELECT 
                                     	Id, Name, Account__c
                                     FROM 
                                     	Property__c 
                                     WHERE
                                     	ResMan_Property_Id__c != NULL AND ( ( Group_Membership__c IN : GroupingIds ) OR ( Account__c IN : AccountIds AND Group_Membership__c = NULL ) ) 
                                     ORDER BY
                                     	Account__c
                                    ];
        }
        
        return this.arrobjProperties;
    }
    
    global void execute(Database.BatchableContext BC, List<Property__c> scope){
        Set<ID> AccountIds 		= new Set<ID>();
        Set<ID> PropertyIds 	= new Set<ID>();
        for( Property__c property : scope ) {
            AccountIds.add( property.Account__c );
            PropertyIds.add( property.Id );
        }
        
        RMPullFloorPlansController RMPullFloorPlans = new RMPullFloorPlansController();
        RMPullFloorPlans.AccountIds = AccountIds;
        RMPullFloorPlans.PropertyIds = PropertyIds;
        
        RMPullFloorPlans.RMPullFloorPlans();
        
        upsert RMPullFloorPlans.arrobjFloorPlans;
       	//upsert scope;     
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}