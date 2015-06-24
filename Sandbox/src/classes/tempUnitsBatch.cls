global class tempUnitsBatch implements Database.Batchable<Floor_Plan__c>, Database.AllowsCallouts{
	public List<Property__c> arrobjProperties = new List<Property__c>();
    public List<Floor_Plan__c> arrobjFloorPlans = new List<Floor_Plan__c>();
    Boolean isGCPullUnitScheduler = true;
    //public YardiGCPullUnitController YGCPullUnit = new YardiGCPullUnitController();
    
    global tempUnitsBatch() {}
    
    global Iterable<Floor_Plan__c> start(Database.BatchableContext BC) {
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
                                 	Id, Name, Account__c, Account__r.Name, Customer_Prop_ID__c, Last_Unit_Pull__c, Group_Membership__c, Group_Membership__r.Name,
                                	( SELECT Id, Floorplan_ID__c, Property__c, Account__c FROM Floor_Plans__r WHERE Floorplan_ID__c != NULL )
                                 FROM 
                                 	Property__c 
                                 WHERE
                                	Id IN ( SELECT Property__c FROM Floor_Plan__c WHERE Floorplan_ID__c != NULL )
                                 	AND Customer_Prop_ID__c != NULL
                                 	AND ( ( Group_Membership__c IN : GroupingIds ) OR ( Account__c IN : AccountIds AND Group_Membership__c = NULL ) ) 
                                 ORDER BY
                                 	Last_Unit_Pull__c ASC, Account__c
                               	];
            System.debug( arrobjProperties.size() );
            for( Property__c property: arrobjProperties ) {
                for( Floor_Plan__c FloorPlan: property.Floor_Plans__r ) {
                    this.arrobjFloorPlans.add( FloorPlan );
                    
                }   
            }
        }
        System.debug( arrobjFloorPlans.size() );
        return this.arrobjFloorPlans;
    }
    
    global void execute(Database.BatchableContext BC, List<Floor_Plan__c> scope){
        Set<ID> AccountIds 		= new Set<ID>();
        Set<ID> PropertyIds 	= new Set<ID>();
        Set<ID> FloorPlanIds  	= new Set<ID>();
        
        for( Floor_Plan__c FloorPlan : scope ) {
            AccountIds.add( FloorPlan.Account__c );
            PropertyIds.add( FloorPlan.Property__c );
            FloorPlanIds.add( FloorPlan.Id );
        }
        
        tempUnitsController YGCPullUnit = new tempUnitsController();
        YGCPullUnit.AccountIds = AccountIds;
        YGCPullUnit.PropertyIds = PropertyIds;
		YGCPullUnit.FloorPlanIds = FloorPlanIds;
        
        YGCPullUnit.YardiGCPullUnit(this.isGCPullUnitScheduler);
        
        upsert YGCPullUnit.arrobjUnits;
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}