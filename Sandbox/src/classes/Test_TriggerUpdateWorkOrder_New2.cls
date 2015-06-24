@isTest
private class Test_TriggerUpdateWorkOrder_New2 {
    static testMethod void UnitWorkOrdernew2()
     {     
         Account a = new Account();
         a.Name='Test Account';
         a.Phone='2130456';
         a.Type='Test Tyep';
         a.Use_AH_Emer_Woogie__c=false;
         insert a;
         
         Account aEmer = new Account();
         aEmer.Name='Test Account';
         aEmer.Phone='2130456';
         aEmer.Type='Test Tyep';
         aEmer.Use_AH_Emer_Woogie__c=true;
         insert aEmer; 
         
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
         
         Grouping__c g=new Grouping__c();
         g.Name='Test Grouping';
         g.Account__c=a.Id;
         g.Use_Default_Work_Order_Dispatch__c=false;
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
         p.Multi_Family_Property__c=true;
         insert p;
         
         Service_Request_Type__c sct=new Service_Request_Type__c();
         sct.Name='Test';
         sct.Account__c=a.Id;
         sct.CS_Request_Type__c=True;
         sct.Grouping__c=g.id;
         insert sct; 
         
         Work_Order_Dispatch__c woFC=new Work_Order_Dispatch__c();
         woFC.Name='Test Work';
         woFC.Account__c=a.Id;
         woFC.Request_Category1__c='Emergency Customer Service Request';
         woFC.Emergency_Classification__c='Emergency';
         woFC.MSA__c=mc.Id;          
         insert woFC; 
         woFC.Request_Category1__c='Customer Service Request';
         update woFC; 
         
         Service_Request1__c srfc = new Service_Request1__c(); 
         srfc.Account_Name__c =a.Id;
         srfc.Property_of_Interest__c=p.Id;
         srfc.Service_Request_Type__c=sct.Id;  
         srfc.Force_Emergency__c=True;  
         srfc.Work_Order_Dispatch__c=woFC.Id;  
         insert srfc;    
         srfc.Force_Emergency__c=false; 
         update srfc;  
         
         //---Set as Emer Woogie
         Grouping__c gEmer=new Grouping__c();
         gEmer.Name='Test Grouping';
         gEmer.Account__c=aEmer.Id;
         gEmer.Use_Default_Work_Order_Dispatch__c=True;
         insert gEmer;   
         
         Property__c pEmer = new Property__c();
         pEmer.Name='Test Namee';
         pEmer.Zip_Code_Lookup__c=zp.Id;
         pEmer.Active__c='Yes';
         pEmer.Price__c=decimal.valueof('12.30');
         pEmer.Account__c=aEmer.Id;
         pEmer.Square_Footage__c=decimal.valueof('23.30');
         pEmer.Bed_Count__c=decimal.valueof('23.30');
         pEmer.Bath_Count__c=decimal.valueof('23.30');
         pEmer.Pet_Policy__c='Test pet';
         pEmer.Lease_Terms__c=decimal.valueof('23.30');
         pEmer.Address_Line_1__c='Address';
         pEmer.City__c='Test City';
         pEmer.State__c='Test State';
         pEmer.Zip_Code__c='Zip';
         pEmer.Default_Appointment_Length__c='Test app';
         pEmer.Group_Membership__c=gEmer.Id;
         pEmer.Multi_Family_Property__c=true;
         insert pEmer; 
         
         Service_Request_Type__c sr=new Service_Request_Type__c();
         sr.Name='service request';
         sr.Repair_Category__c = 'Electrical';
         sr.Request_Classification__c = 'Emergency';        
         sr.Account__c=aEmer.Id;
         sr.Grouping__c = gEmer.Id;
         insert sr;
         
         Service_Request_Type__c srStan=new Service_Request_Type__c();
         srStan.Name='service request';
         srStan.Repair_Category__c = 'Electrical';
         srStan.Request_Classification__c = 'Standard';        
         srStan.Account__c=aEmer.Id;
         srStan.Grouping__c = gEmer.Id;
         insert srStan;
         
         Work_Order_Dispatch__c woTure=new Work_Order_Dispatch__c();
         woTure.Name='Test Work';
         woTure.Account__c=aEmer.Id;
         woTure.Request_Category1__c='Electrical';
         woTure.Emergency_Classification__c='Emergency';
         woTure.MSA__c=mc.Id; 
         woTure.Grouping__c=gEmer.Id;
         woTure.Set_As_AH_Emer_Woogie__c=true;        
         woTure.Monday_Open__c=decimal.valueof('1.0'); 
         woTure.Monday_Closed__c =decimal.valueof('2.0');       
         woTure.Tuesday_Open__c=decimal.valueof('1.0'); 
         woTure.Tuesday_Closed__c =decimal.valueof('2.0'); 
         woTure.Wednesday_Open__c=decimal.valueof('1.0'); 
         woTure.Wednesday_Closed__c =decimal.valueof('2.0'); 
         woTure.Thursday_Open__c=decimal.valueof('1.0'); 
         woTure.Thursday_Closed__c =decimal.valueof('2.0');
         woTure.Friday_Open__c=decimal.valueof('1.0'); 
         woTure.Friday_Closed__c =decimal.valueof('2.0'); 
         woTure.Saturday_Open__c=decimal.valueof('1.0'); 
         woTure.Saturday_Closed__c =decimal.valueof('2.0');
         woTure.Sunday_Open__c=decimal.valueof('1.0'); 
         woTure.Sunday_Closed__c =decimal.valueof('2.0');         
         insert woTure;
         
         Work_Order_Dispatch__c woMin=new Work_Order_Dispatch__c();
         woMin.Name='Test Work';
         woMin.Account__c=aEmer.Id;
         woMin.Request_Category1__c='Electrical';
         woMin.Emergency_Classification__c='Emergency';
         woMin.MSA__c=mc.Id;  
         woMin.Grouping__c=gEmer.Id;      
         woMin.Set_As_AH_Emer_Woogie__c=true;  
         woMin.Is_During_Hours_Emergency__c=True;              
         woMin.Monday_Open__c=decimal.valueof('0.0'); 
         woMin.Monday_Closed__c =decimal.valueof('15.0');        
         woMin.Tuesday_Open__c=decimal.valueof('0.0'); 
         woMin.Tuesday_Closed__c =decimal.valueof('15.0'); 
         woMin.Wednesday_Open__c=decimal.valueof('0.0'); 
         woMin.Wednesday_Closed__c =decimal.valueof('15.0'); 
         woMin.Thursday_Open__c=decimal.valueof('0.0'); 
         woMin.Thursday_Closed__c =decimal.valueof('15.0');
         woMin.Friday_Open__c=decimal.valueof('0.0'); 
         woMin.Friday_Closed__c =decimal.valueof('15.0'); 
         woMin.Saturday_Open__c=decimal.valueof('0.0'); 
         woMin.Saturday_Closed__c =decimal.valueof('15.0');
         woMin.Sunday_Open__c=decimal.valueof('0.0'); 
         woMin.Sunday_Closed__c =decimal.valueof('15.0');         
         insert woMin;                         
        
         //-----MOnday----------------------------------------------------
         Service_Request1__c svcMon_minWk = new Service_Request1__c(); 
         svcMon_minWk.Account_Name__c =aEmer.Id;
         svcMon_minWk.Property_of_Interest__c=pEmer.Id;
         svcMon_minWk.Service_Request_Type__c=sr.Id;
         Datetime svcMon_minWkDate = datetime.newInstance(2013, 12, 16, 12, 30, 2); 
         svcMon_minWk.Created_Date_and_Time__c=svcMon_minWkDate;
         svcMon_minWk.Work_Order_Dispatch__c=woMin.Id; 
         svcMon_minWk.Force_Emergency__c=false;
         insert svcMon_minWk;  
         //-----Tuesday----------------------------------------------------
         Datetime svcTue_woTureDate = datetime.newInstance(2013, 12, 17, 12, 30, 2);
         svcMon_minWk.Created_Date_and_Time__c=svcTue_woTureDate;
         update svcMon_minWk;
         //-----Wednesday----------------------------------------------------
         Datetime svcWed_woTureDate = datetime.newInstance(2013, 12, 18, 12, 30, 2);
         svcMon_minWk.Created_Date_and_Time__c=svcWed_woTureDate;
         update svcMon_minWk;
         //-----Thrusday----------------------------------------------------
         Datetime svcThru_woTureDate = datetime.newInstance(2013, 12, 19, 12, 30, 2);
         svcMon_minWk.Created_Date_and_Time__c=svcThru_woTureDate;
         update svcMon_minWk;
         //-----Friday----------------------------------------------------
         Datetime svcFri_woTureDate = datetime.newInstance(2013, 12, 20, 12, 30, 2);
         svcMon_minWk.Created_Date_and_Time__c=svcFri_woTureDate;
         update svcMon_minWk;
         //-----Saturday----------------------------------------------------  
         Datetime svcSat_woTureDate = datetime.newInstance(2013, 12, 21, 12, 30, 2);
         svcMon_minWk.Created_Date_and_Time__c=svcSat_woTureDate;
         update svcMon_minWk;
         //-----Sunday----------------------------------------------------   
         Datetime svcSun_woTureDate = datetime.newInstance(2013, 12, 22, 12, 30, 2);
         svcMon_minWk.Created_Date_and_Time__c=svcSun_woTureDate;
         update svcMon_minWk; 
         /*sr.Request_Classification__c = 'Standard';   
         update sr; */                   
         //-------------End---------------------------------- 
         
         Work_Order_Dispatch__c woMin1=new Work_Order_Dispatch__c();
         woMin1.Name='Test Work';
         woMin1.Account__c=aEmer.Id;
         woMin1.Request_Category1__c='Electrical';
         woMin1.Emergency_Classification__c='Emergency';
         woMin1.MSA__c=mc.Id;  
         woMin1.Grouping__c=gEmer.Id;      
         woMin1.Set_As_AH_Emer_Woogie__c=true;  
         woMin1.Is_During_Hours_Emergency__c=True;  
         woMin1.Is_Standard_WOD__c=true;            
         insert woMin1;  
                 
         Service_Request1__c svcMon_minWk1 = new Service_Request1__c(); 
         svcMon_minWk1.Account_Name__c =aEmer.Id;
         svcMon_minWk1.Property_of_Interest__c=pEmer.Id;
         svcMon_minWk1.Service_Request_Type__c=srStan.Id; 
         svcMon_minWk1.Created_Date_and_Time__c=datetime.newInstance(2013, 12, 16, 12, 30, 2); 
         svcMon_minWk1.Work_Order_Dispatch__c=woMin1.Id; 
         svcMon_minWk1.Force_Emergency__c=false;
         insert svcMon_minWk1;  
         
         Grouping__c gEmer1=new Grouping__c();
         gEmer1.Name='Test Grouping';
         gEmer1.Account__c=aEmer.Id;
         gEmer1.Use_Default_Work_Order_Dispatch__c=false;
         insert gEmer1;   
         
         Property__c pEmer1 = new Property__c();
         pEmer1.Name='Test Namee';
         pEmer1.Zip_Code_Lookup__c=zp.Id;
         pEmer1.Active__c='Yes';
         pEmer1.Price__c=decimal.valueof('12.30');
         pEmer1.Account__c=aEmer.Id;
         pEmer1.Square_Footage__c=decimal.valueof('23.30');
         pEmer1.Bed_Count__c=decimal.valueof('23.30');
         pEmer1.Bath_Count__c=decimal.valueof('23.30');
         pEmer1.Pet_Policy__c='Test pet';
         pEmer1.Lease_Terms__c=decimal.valueof('23.30');
         pEmer1.Address_Line_1__c='Address';
         pEmer1.City__c='Test City';
         pEmer1.State__c='Test State';
         pEmer1.Zip_Code__c='Zip';
         pEmer1.Default_Appointment_Length__c='Test app';
         pEmer1.Group_Membership__c=gEmer1.Id;
         insert pEmer1; 
         
         Service_Request_Type__c srStan1=new Service_Request_Type__c();
         srStan1.Name='service request';
         srStan1.Repair_Category__c = 'Electrical';
         srStan1.Request_Classification__c = 'Standard';        
         srStan1.Account__c=aEmer.Id;
         srStan1.Grouping__c = gEmer1.Id;
         insert srStan1;
         
         Work_Order_Dispatch__c woMin2=new Work_Order_Dispatch__c();
         woMin2.Name='Test Work';
         woMin2.Account__c=aEmer.Id;
         woMin2.Request_Category1__c='Electrical';
         woMin2.Emergency_Classification__c='All Requests';
         woMin2.MSA__c=mc.Id;  
         woMin2.Grouping__c=gEmer1.Id;      
         woMin2.Set_As_AH_Emer_Woogie__c=false;  
         woMin2.Is_During_Hours_Emergency__c=True;  
         woMin2.Is_Standard_WOD__c=false;            
         insert woMin2; 
         
         Work_Order_Dispatch__c woMin3=new Work_Order_Dispatch__c();
         woMin3.Name='Test Work';
         woMin3.Account__c=aEmer.Id;
         woMin3.Request_Category1__c='Electrical';
         woMin3.Emergency_Classification__c='Standard';
         woMin3.MSA__c=mc.Id;  
         woMin3.Grouping__c=gEmer1.Id;      
         woMin3.Set_As_AH_Emer_Woogie__c=false;  
         woMin3.Is_During_Hours_Emergency__c=True;  
         woMin3.Is_Standard_WOD__c=false;            
         insert woMin3; 
         
         Service_Request1__c svcMon_minWk2 = new Service_Request1__c(); 
         svcMon_minWk2.Account_Name__c =aEmer.Id;
         svcMon_minWk2.Property_of_Interest__c=pEmer1.Id;         
         svcMon_minWk2.Service_Request_Type__c=srStan1.Id; 
         svcMon_minWk2.Work_Order_Dispatch__c=woMin2.Id;  
         svcMon_minWk2.Force_Emergency__c=false;
         insert svcMon_minWk2;  
         /*svcMon_minWk2.Work_Order_Dispatch__c=woMin3.Id; 
         update svcMon_minWk2;     */ 
     }
 
 }