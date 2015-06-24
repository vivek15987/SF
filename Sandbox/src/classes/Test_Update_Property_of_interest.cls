@isTest
 private class Test_Update_Property_of_interest {
 static testMethod void UnitProperty_of_interest()
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
         
         Work_Order_Dispatch__c w= new Work_Order_Dispatch__c();
        w.Name ='Test';
        w.Account__c=a.Id;
        w.MSA__c=mc.Id;
        insert w;
         
         Grouping__c g=new Grouping__c();
         g.Name='Test Grouping';
         g.Account__c=a.Id;
         g.Use_Default_Work_Order_Dispatch__c=True;
         insert g; 
         
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
         p.Group_Membership__c=g.Id;
         p.Multi_Family_Property__c=false;
         insert p;  
          
         Service_Request_Type__c sr=new Service_Request_Type__c();
         sr.Name='service request';
         sr.Repair_Category__c = 'Electrical';
         sr.Account__c=a.Id;
         sr.Grouping__c = g.Id;
         sr.Request_Classification__c = 'Emergency';
         insert sr;
         
         Source__c s=new Source__c();
         s.Account__c=a.Id;
         s.Property__c=p.Id;
         insert s;
         
         Unit__c u=new Unit__c();
         u.Account__c=a.Id;
         u.Property__c=p.Id;
         insert u;
         
         Service_Request1__c svc= new Service_Request1__c(); 
         svc.Account_Name__c =a.Id;
         svc.Property_of_Interest__c=p.Id;         
         svc.Source__c=s.Id;
         svc.Work_Order_Dispatch__c=w.Id;
         svc.Service_Request_Type__c=sr.Id;
         svc.Unit_Needing_Service__c=u.Id;
         insert svc;  
 }
 }