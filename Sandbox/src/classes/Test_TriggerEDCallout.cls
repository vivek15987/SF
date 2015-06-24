@isTest
private class Test_TriggerEDCallout {
    static testMethod void TesttgEDCallout()
    { 
        Emergency_Dispatch__c EDapp = new Emergency_Dispatch__c();
        EDapp.Customer_ID__c = 'cust00123';
        insert EDapp;
    }
}