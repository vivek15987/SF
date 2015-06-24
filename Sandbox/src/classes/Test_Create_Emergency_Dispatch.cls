@isTest
private class Test_Create_Emergency_Dispatch {
static testMethod void TestingCreate_Emergency_Dispatch()
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
 
 Grouping__c g= new Grouping__c();
 g.Name = 'Group1';
 g.Account__c = a.Id;
 insert g;
     
 Property__c p = new Property__c();
 p.Account__c = a.Id;
 p.Group_Membership__c = g.Id;
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
 
 Service_Request_Type__c sr=new Service_Request_Type__c();
 sr.Name='service request';
 sr.Repair_Category__c = 'Electrical';
 sr.Request_Classification__c = 'Emergency';
 sr.Account__c=a.Id;
 sr.Grouping__c = g.Id;
 insert sr;
  
 Work_Order_Dispatch__c mw=new Work_Order_Dispatch__c();
 mw.Name='Test Work';
 mw.Account__c=a.Id;
 mw.Request_Category1__c='Electrical';
 mw.Emergency_Classification__c='Emergency';
 mw.MSA__c=mc.Id; 
 mw.Set_As_AH_Emer_Woogie__c=true;
 mw.Monday_Open__c=decimal.valueof('1.0'); 
 mw.Monday_Closed__c =decimal.valueof('17.0'); 
 insert mw;  
 
 Service_Request1__c ts = new Service_Request1__c(); 
 ts.Account_Name__c =a.Id;
 ts.Property_of_Interest__c=p.Id;
 ts.Service_Request_Type__c=sr.Id;
 ts.Work_Order_Dispatch__c=mw.Id; 
 //ts.Created_Date_and_Time__c=date.parse('11/23/2013');
 ts.Status__c='Initiate Emergency Dispatch';
 ts.Emergency_Dispatch_Status__c='Not Accepted'; 
 ts.Force_Emergency__c = false;
 insert ts;
 
 Emergency_Dispatch__c e=new Emergency_Dispatch__c ();
 e.Service_Request__c=ts.Id;
 e.Work_Order_Dispatch__c=ts.Work_Order_Dispatch__c;
 insert e;
 }
 }