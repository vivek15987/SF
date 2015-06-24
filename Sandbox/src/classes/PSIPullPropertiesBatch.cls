global class PSIPullPropertiesBatch implements Database.Batchable<Property__c> ,Database.AllowsCallouts {

    public boolean IsPropertiesScheduler = false;
    public PSIPullPropertiesController PSIGetProperties = new PSIPullPropertiesController();
    
    public PSIPullPropertiesBatch( Boolean IsScheduler ){
        this.IsPropertiesScheduler = IsScheduler;
    }

    global Iterable<Property__c> start(Database.BatchableContext BC) {
        List<Property__c> Properties = new List<Property__c>();
        
        Properties = PSIGetProperties.getProperties( IsPropertiesScheduler ); 
        return Properties;
    }

    global void execute(Database.BatchableContext BC, List<Property__c> Scope) {
        upsert Scope;
    }

    global void finish(Database.BatchableContext BC) {
     }

}