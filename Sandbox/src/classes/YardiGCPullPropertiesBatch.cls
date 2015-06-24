global class YardiGCPullPropertiesBatch implements Database.Batchable<Property__c>, Database.AllowsCallouts{
	public List<Property__c> arrobjProperties = new List<Property__c>();
    Boolean isYardiGCPullPropertiesScheduler = true;
    public YardiGCPullPropertiesController YGCPullProperties = new YardiGCPullPropertiesController();
    
    global YardiGCPullPropertiesBatch( Boolean isYardiGCPullPropertiesScheduler ) {
        this.isYardiGCPullPropertiesScheduler = isYardiGCPullPropertiesScheduler;
    }
    
    global Iterable<Property__c> start(Database.BatchableContext BC) {
        
        YGCPullProperties.YardiGCPullPropertyConfigurations(this.isYardiGCPullPropertiesScheduler);
        this.arrobjProperties = YGCPullProperties.arrobjProperties;
        
        return this.arrobjProperties;
    }
    
    global void execute(Database.BatchableContext BC, List<Property__c> scope){
       	upsert scope;     
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}