global class PSIPullFloorPlansBatch implements Database.Batchable<Floor_Plan__c> ,Database.AllowsCallouts {

    public boolean IsFloorPlansScheduler = false;
	public PSIPullFloorPlansController PSIPullFloorPlan = new PSIPullFloorPlansController();
    public PSIPullFloorPlansBatch( Boolean IsScheduler ){
        this.IsFloorPlansScheduler = IsScheduler;
    }

    global Iterable<Floor_Plan__c> start(Database.BatchableContext BC) {
        List<Floor_Plan__c> FloorPlans = new List<Floor_Plan__c>();
        
        FloorPlans = PSIPullFloorPlan.getFloorPlans( this.IsFloorPlansScheduler ); 
        return FloorPlans;
    }

    global void execute(Database.BatchableContext BC, List<Floor_Plan__c> Scope) {
        upsert Scope;
    }

    global void finish(Database.BatchableContext BC) {
     }

}