trigger PropertyTriggersBeforeDMLOperations on Property__c ( before insert, before update ) {
/*
    List<Property__c> AllPropertiesNewValues = trigger.new;
    List<Property__c> AllPropertiesOldValues = trigger.old;
    List<Property__c> NeedToUpdateProperties = new List<Property__c>();
    
    PropertyTriggerHelperController helperController = new PropertyTriggerHelperController();
    NeedToUpdateProperties = helperController.PopulateStreetNumber( AllPropertiesNewValues, AllPropertiesOldValues );
    */
}