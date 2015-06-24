global class YardiPullSRTypesBatch implements Database.Batchable<Service_Request_Type__c>, Database.AllowsCallouts, Database.Stateful {
    
    public YardiPullSRTypesBatch() {}
    
    global Iterable<Service_Request_Type__c> start(Database.BatchableContext BC) {
        
        return new List<Service_Request_Type__c>();
    }
    
    global void execute(Database.BatchableContext BC, List<Service_Request_Type__c> arrobjServiceRequestTypes ){
    }
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
}