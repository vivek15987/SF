@isTest(SeeAllData=true)
class test_Updatemove1{
static testMethod void Updatemove(){ 

Account a = new Account();
a.Name='Test Account';
a.Phone='2130456';
a.Type='Test Tyep';
insert a;

 /*MSA__c msa=new MSA__c();
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
p.Zip_Code_Lookup__c=zp.Id;
p.Zip_Code__c='Zip';
p.Date_Available__c=Date.Parse('9/5/2013');
p.Default_Appointment_Length__c='Test app';
insert p;

Move_in_Special__c mc =new Move_in_Special__c();
mc.Name='Test Move';
mc.Property__c=p.Id;
mc.Account__c=a.Id;
mc.Special_Trigger__c = 'Account';
mc.Days_Vacant_Start__c=Decimal.valueof('1');
mc.Days_Vacant_End__c=Decimal.Valueof('30');
mc.Special_Start_Date__c =Date.Parse('8/6/2013');
mc.Special_Expiration__c=Date.Parse('12/30/2013');
mc.Move_in_Special_Description__c='1 Month Free Rent on 12 Month Lease';
insert mc;

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
p1.Zip_Code_Lookup__c=zp.Id;
p1.Zip_Code__c='Zip';
p1.Date_Available__c=Date.Parse('9/5/2013');
p1.Default_Appointment_Length__c='Test app';
p1.Move_in_Special1__c=mc.Move_in_Special_Description__c;
insert p1;*/

Apexpages.StandardController stdController = new Apexpages.StandardController(a);
Updatemove1 schcls =new Updatemove1(stdController); 
schcls.specialoffer();
}
}