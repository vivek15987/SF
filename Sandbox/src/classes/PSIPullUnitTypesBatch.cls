global class PSIPullUnitTypesBatch implements Database.Batchable<Property__c> ,Database.AllowsCallouts {
	public List<Property__c> arrobjProperties = new List<Property__c>();
    
    public PSIPullUnitTypesBatch() {} 

    global Iterable<Property__c> start(Database.BatchableContext BC) {
        List<Integration__c> searchList = [ SELECT 
                                            Account__c, PSI_API_URL__c, PSI_Password__c, PSI_Username__c, Grouping__c
                                           FROM
                                            Integration__c
                                           WHERE
                                            PSI_Integration_Active__c = true
                                            AND Get_PSI_UnitTypes__c != NULL
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
            
            this.arrobjProperties = [SELECT 
                                 	Id, Account__c, PSI_Prop_ID__c, Last_Yardi_FloorPlan_Pull__c, Group_Membership__c
                                 FROM 
                                 	Property__c 
                                 WHERE
                                 	PSI_Prop_ID__c != NULL
                                 	AND ( ( Group_Membership__c IN : GroupingIds ) OR ( Account__c IN : AccountIds AND Group_Membership__c = NULL ) ) 
                                 ORDER BY
                                 	Last_Yardi_FloorPlan_Pull__c ASC, Account__c
                                ];
        }
        
        return this.arrobjProperties;
    }

    global void execute(Database.BatchableContext BC, List<Property__c> Scope) {
        Set<ID> AccountIds 		= new Set<ID>();
        Set<ID> PropertyIds 	= new Set<ID>();
        for( Property__c property : scope ) {
            AccountIds.add( property.Account__c );
            PropertyIds.add( property.Id );
        }

		PSIPullUnitTypesController PSIPullUnitType = new PSIPullUnitTypesController();
        PSIPullUnitType.AccountIds = AccountIds;
        PSIPullUnitType.PropertyIds = PropertyIds;
        
        PSIPullUnitType.getUnitTypes();
		//Do 
        upsert PSIPullUnitType.arrobjFloorPlans;
        //upsert Scope;
    }

    global void finish(Database.BatchableContext BC) {
     }

}