trigger PropertyTrigger on Property__c (after delete, after insert, after update, before delete, before insert, before update)
{
    //System.debug('Property__c.sObjectType - ' + Property__c.sObjectType);
    //TriggerFactory_Tushar.createHandler( Property__c.sObjectType );
}