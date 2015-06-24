@isTest
private class TestCreateMoveinClass {
static testMethod void testScheApex()
{
Test.startTest();
Account a = new Account();
a.Name='Test Account';
a.Phone='2130456';
a.Type='Test Tyep';
insert a;

 MSA__c msa=new MSA__c();
 msa.Name='Test ma';
 msa.County_Number__c=decimal.valueof('456');
 msa.MSA_No__c='msan';
 msa.State__c='sss';
 insert msa; 

Zip_Code__c zp=new Zip_Code__c();
zp.Name='Testzip';
zp.State__c='Test State';
zp.MSA__c=msa.Id;
insert zp;

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

Move_in_Special__c mc =new Move_in_Special__c();
mc.Name='Test Move';
mc.Property__c=p.Id;
mc.Account__c=a.Id;
mc.Days_Vacant_Start__c=Decimal.valueof('1');
mc.Days_Vacant_End__c=Decimal.Valueof('30');
//mc.Special_Start_Date__c =Date.Parse('8/16/2013');
//mc.Special_Expiration__c=Date.Parse('8/9/2013');
insert mc;

Move_in_Special__c m1 =new Move_in_Special__c();
m1.Name='Test Move';
m1.Property__c=p.Id;
m1.Account__c=p.Account__c;
m1.Special_Trigger__c = 'Account';
m1.Days_Vacant_Start__c=Decimal.valueof('1');
m1.Days_Vacant_End__c=Decimal.Valueof('30');
//m1.Special_Start_Date__c =Date.Parse('8/16/2013');
//m1.Special_Expiration__c=Date.Parse('8/9/2013');
insert m1;

Property__c p1 = new Property__c();
p1.Name='Test Namee';
p1.Active__c='Yes';
p1.Price__c=decimal.valueof('12.30');
p1.Account__c=m1.Account__c;
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
//p1.Date_Available__c=Date.Parse('7/23/2013');
p1.Move_in_Special1__c=m1.Name;
insert p1;

/////////

Move_in_Special__c mm =new Move_in_Special__c();
mm.Name='Test Move';
mm.Property__c=p.Id;
mm.Account__c=p.Account__c;
mm.Special_Trigger__c = 'MSA';
mm.MSA_del__c=msa.Id;
mm.Days_Vacant_Start__c=Decimal.valueof('1');
mm.Days_Vacant_End__c=Decimal.Valueof('30');
//mm.Special_Start_Date__c =Date.Parse('8/16/2013');
//mm.Special_Expiration__c=Date.Parse('8/9/2013');
insert mm;


Property__c p2 = new Property__c();
p2.Name='Test Namee';
p2.Active__c='Yes';
p2.Price__c=decimal.valueof('12.30');
p2.Account__c=mm.Account__c;
p2.Square_Footage__c=decimal.valueof('23.30');
p2.Bed_Count__c=decimal.valueof('23.30');
p2.Bath_Count__c=decimal.valueof('23.30');
p2.Pet_Policy__c='Test pet';
p2.Lease_Terms__c=decimal.valueof('23.30');
p2.Address_Line_1__c='Address';
p2.City__c='Test City';
p2.State__c='Test State';
p2.Zip_Code__c='Zip';
p2.Zip_Code_Lookup__c=zp.Id;
p2.Default_Appointment_Length__c='Test app';
//p2.Date_Available__c=Date.Parse('7/22/2013');
p2.Move_in_Special1__c=mm.Name;
insert p2;

CreateMoveinClass msc=new CreateMoveinClass(); 
msc.specialoffer1();

}
}