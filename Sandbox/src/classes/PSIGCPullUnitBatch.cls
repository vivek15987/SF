global class PSIGCPullUnitBatch implements Database.Batchable<Floor_Plan__c>, Database.AllowsCallouts{
	public List<Property__c> arrobjProperties = new List<Property__c>();
    public List<Floor_Plan__c> arrobjFloorPlans = new List<Floor_Plan__c>();
    
    global PSIGCPullUnitBatch() {}
    
    global Iterable<Floor_Plan__c> start(Database.BatchableContext BC) {
      	List<Integration__c> searchList = [ SELECT 
                                                Id, Account__c, Name, Grouping__c
                                            FROM
                                                Integration__c
                                            WHERE
                                                PSI_Integration_Active__c = true
                                				AND Get_PSI_Unit_Availability__c != null
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
                                        Id, Name, Account__c, Account__r.Name, PSI_Prop_ID__c, Last_Unit_Pull__c, Group_Membership__c, Group_Membership__r.Name,
                                        ( SELECT Id, Property__c, Account__c, PSI_Floor_Plan_ID__c FROM Floor_Plans__r WHERE PSI_Floor_Plan_ID__c != NULL )
                                     FROM 
                                        Property__c 
                                     WHERE
                                        PSI_Prop_ID__c != NULL
                                        AND ( ( Group_Membership__c IN : GroupingIds ) OR ( Account__c IN : AccountIds AND Group_Membership__c = NULL ) ) 
                                     ORDER BY
                                        Last_Unit_Pull__c ASC, Account__c
                                    ];
           
           for( Property__c property: arrobjProperties ) {
                for( Floor_Plan__c FloorPlan: property.Floor_Plans__r ) {
                    this.arrobjFloorPlans.add( FloorPlan );
                    
                }   
            }
       }
        
        return this.arrobjfloorplans;
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
        
        PSIGCPullUnitsController PSIPullUnit = new PSIGCPullUnitsController();
        PSIPullUnit.AccountIds = AccountIds;
        PSIPullUnit.PropertyIds = PropertyIds;
		PSIPullUnit.FloorPlanIds = FloorPlanIds;
        
        PSIPullUnit.PSIGCPullUnits();
        
        upsert PSIPullUnit.arrobjUnits;
        
        //upsert scope;     
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}