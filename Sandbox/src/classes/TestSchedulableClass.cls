@isTest
private class TestSchedulableClass {
static testMethod void testScheApex()
{
Test.startTest();
//String jobId = System.schedule('testBasicScheduledApex',MoveinSpecialsClass,new MoveinSpecialsClass());
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
insert p;

Move_in_Special__c mm =new Move_in_Special__c();
mm.Name='Test Move';
mm.Property__c=p.Id;
mm.Account__c=a.Id;
insert mm;

Property__c p1 = new Property__c();
p1.Name='Test Namee';
p1.Active__c='Yes';
p1.Price__c=decimal.valueof('12.30');
p1.Account__c=a.Id;
p1.Square_Footage__c=decimal.valueof('23.30');
p1.Bed_Count__c=decimal.valueof('23.30');
p1.Bath_Count__c=decimal.valueof('23.30');
p1.Pet_Policy__c='Test pet';
p1.Lease_Terms__c=decimal.valueof('23.30');
p1.Address_Line_1__c='Address';
p1.City__c='Test City';
p1.State__c='Test State';
p1.Zip_Code__c='Zip';
p1.Default_Appointment_Length__c='Test app';
p1.Move_in_Special1__c=mm.Name;
insert p1;

MoveinSpecialsClass msc=new MoveinSpecialsClass();
msc.specialoffer();
}
}