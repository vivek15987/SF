@IsTest
private class Test_UpdateProperty_Price_Active_byUnit{
static testMethod void TestUpdatePricebyUnit()
{
Account a=new Account();
a.Name='Test';
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
p.Multi_Family_Property__c=false;
insert p;

Unit__c u=new Unit__c();
u.Account__c=a.Id;
u.Property__c=p.Id;
u.Active__c=True;
u.Market_Rent__c=22.0;
insert u;

Test.StartTest();
Test.StopTest();
}
}