@IsTest
private class Test_Modified_CaseField_Trigger
{
    static testMethod void testtriggerClass()
    {
        Account a = new Account();
        a.Name='Test Account';
        a.Phone='2130456';
        a.Type='Test Tyep';
        insert a;
        
        Property__c p = new Property__c();
        p.Name='Test Namee';
        p.Active__c='Yes';
        p.Price__c=decimal.valueof('12.30');
        p.Account__c=a.Id;
        p.Square_Footage__c=decimal.valueof('23.30');
        p.Bed_Count__c=decimal.valueof('23.30');
        p.Bath_Count__c=decimal.valueof('23.30');
        p.Pet_Policy__c='Test pet';
        p.Lease_Terms__c=decimal.valueof('23.30');
        p.Address_Line_1__c='Address';
        p.City__c='Test City';
        p.State__c='Test State';
        p.Zip_Code__c='Zip';
        p.Default_Appointment_Length__c='Test app';
        p.Multi_Family_Property__c=true;
        insert p;
        
        Contact c=new Contact();
        c.Accountid=a.Id;
        c.Firstname='Test';
        c.Lastname='LastName';
        insert c;
        
        
        Case ca=new Case();
        ca.Accountid=a.Id;
        ca.Status='Inquiry';
        ca.ContactId=c.id;
        ca.SuppliedPhone='2221003';
        insert ca;
        c.Status__c='Inquiry';
        update c;
        
        Test.StartTest();
        Test.Stoptest();
    }
}