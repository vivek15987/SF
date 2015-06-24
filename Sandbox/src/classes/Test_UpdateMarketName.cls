@isTest
 private class Test_UpdateMarketName {
 static testMethod void UnitTestagentemail()
 { 
 Account a = new Account();
 a.Name='Test Account';
 a.Phone='2130456';
 a.Type='Test Tyep';
 insert a;  
 
 MSA__c mc=new MSA__c();
 mc.Name='Test ma';
 mc.County_Number__c=decimal.valueof('456');
 mc.MSA_No__c='msan';
 mc.State__c='sss';
 insert mc;
 
Zip_Code__c zp=new Zip_Code__c();
zp.Name='Testzip';
zp.State__c='Test State';
zp.MSA__c=mc.Id;
insert zp;
 
 Property__c p = new Property__c();
 p.Name='Test Namee';
 p.Zip_Code_Lookup__c=zp.Id;
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
 
 Account_MSA_Connection__c ms=new Account_MSA_Connection__c();
 ms.Name='Test AMC';
 ms.Account__c=a.Id;
 ms.MSA__c =mc.Id;  
 insert ms;
 
 Case c=new Case(); 
 c.Account_MSA_Junction__c=ms.Id;
 c.Status='Test';
 c.AccountId=a.Id;
 c.Property_of_Interest__c=p.Id;
 insert c;
 
 Test.startTest();
 Test.stopTest();
 }
 }