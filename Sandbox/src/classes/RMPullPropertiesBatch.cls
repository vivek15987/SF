global class RMPullPropertiesBatch implements Database.Batchable<Property__c>, Database.AllowsCallouts{
  public List<Property__c> arrobjProperties = new List<Property__c>();
    Boolean isRMPullPropertiesScheduler = true;
    public RMPullPropertiesController RMPullProperties = new RMPullPropertiesController();
    
    global RMPullPropertiesBatch( Boolean isRMPullPropertiesScheduler ) {
        this.isRMPullPropertiesScheduler = isRMPullPropertiesScheduler;
    }
    
    global Iterable<Property__c> start(Database.BatchableContext BC) {
        
        RMPullProperties.RMPullProperties(this.isRMPullPropertiesScheduler);
        this.arrobjProperties = RMPullProperties.arrobjProperties;
        
        return this.arrobjProperties;
    }
    
    global void execute(Database.BatchableContext BC, List<Property__c> scope){
         upsert scope;     
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}