global class RMPullUnitsBatch implements Database.Batchable<Floor_Plan__c>, Database.AllowsCallouts{
	public List<Property__c> arrobjProperties = new List<Property__c>();
    public List<Floor_Plan__c> arrobjFloorPlans = new List<Floor_Plan__c>();
    
    global RMPullUnitsBatch() {}
    
    global Iterable<Floor_Plan__c> start(Database.BatchableContext BC) {
        List<Integration__c> searchList = [ SELECT 
                                              	Id, Account__c, Name, Grouping__c 
                                              FROM 
                                              	Integration__c 
                                              WHERE 
                                              	ResMan_Integration_Active__c = true	
                                              	AND Get_ResMan_Unit_Availability__c != null];
        
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
                                        Id, Name, Account__c, Account__r.Name, ResMan_Property_Id__c, Last_Unit_Pull__c, Group_Membership__c, Group_Membership__r.Name,
                                        ( SELECT Id, Property__c, Account__c, ResMan_Floor_Plan_ID__c FROM Floor_Plans__r WHERE ResMan_Floor_Plan_ID__c != NULL )
                                     FROM 
                                     	Property__c 
                                     WHERE
                                        Id IN ( SELECT Property__c FROM Floor_Plan__c WHERE ResMan_Floor_Plan_ID__c != null )
                                        AND	
                                     	ResMan_Property_Id__c != NULL
                                        AND ( ( Group_Membership__c IN : GroupingIds ) OR ( Account__c IN : AccountIds AND Group_Membership__c = NULL ) ) 
                                     ORDER BY
                                     	Account__c];
            
            
            for( Property__c property: arrobjProperties ) {
                System.debug( '1' );
                for( Floor_Plan__c FloorPlan: property.Floor_Plans__r ) {
                    System.debug( 'Hi' );
                    this.arrobjFloorPlans.add( FloorPlan );
                }   
            }
        }
        
        return this.arrobjFloorPlans;
        
    }
    
    global void execute(Database.BatchableContext BC, List<Floor_Plan__c> scope ){
        Set<ID> AccountIds 		= new Set<ID>();
        Set<ID> PropertyIds 	= new Set<ID>();
        Set<ID> FloorPlanIds  	= new Set<ID>();
        
        for( Floor_Plan__c FloorPlan : scope ) {
            AccountIds.add( FloorPlan.Account__c );
            PropertyIds.add( FloorPlan.Property__c );
            FloorPlanIds.add( FloorPlan.Id );
        }
        
        RMPullUnitsController RMPullUnit = new RMPullUnitsController();
        RMPullUnit.AccountIds = AccountIds;
        RMPullUnit.PropertyIds = PropertyIds;
		RMPullUnit.FloorPlanIds = FloorPlanIds;
            
        RMPullUnit.RMPullUnits();
        
       	upsert RMPullUnit.arrobjUnits;   
        system.debug('upsertion');
        system.debug('Upsert - ' +RMPullUnit.arrobjUnits);
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}