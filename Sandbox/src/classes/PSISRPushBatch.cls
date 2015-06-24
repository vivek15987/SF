global class PSISRPushBatch implements Database.Batchable<Service_Request1__c> ,Database.AllowsCallouts {

    public boolean IsServiceRequestScheduler = false;
    public PSISRPushController PSISRPush = new PSISRPushController();
    
    public PSISRPushBatch( Boolean IsScheduler ){
        this.IsServiceRequestScheduler = IsScheduler;
    }
    
    global Iterable<Service_Request1__c> start(Database.BatchableContext BC) {
        List<Service_Request1__c> ServiceRequests = new List<Service_Request1__c>();
        ServiceRequests = PSISRPush.PushGuestCards( IsServiceRequestScheduler ); 
        System.debug( 'ServiceRequests --- ' + ServiceRequests );
        return ServiceRequests;
    }
    
    global void execute(Database.BatchableContext BC, List<Service_Request1__c> Scope) {
        System.debug( 'Scope ----> ' + Scope );
        upsert Scope;
    }
    
    global void finish(Database.BatchableContext BC) {
    }

}