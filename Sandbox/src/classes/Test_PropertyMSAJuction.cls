@isTest
private class Test_PropertyMSAJuction {
    static testMethod void UnitTestMSAJuction()
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
        
        Grouping__c g=new Grouping__c();
        g.Name='Test Grouping';
        insert g;   
        
        Grouping__c g1=new Grouping__c();
        g1.Name='CAH-FS(TEMP)';
        insert g1; 
        
        Account_MSA_Connection__c ms=new Account_MSA_Connection__c();
        ms.Name='Test AMC';
        ms.Account__c=a.Id;
        ms.MSA__c =mc.Id;  
        ms.Grouping__c=g.Id;
        insert ms;
        
        Account_MSA_Connection__c ms1=new Account_MSA_Connection__c();
        ms1.Name='CAH-FS(TEMP)-NO-MSA';
        ms1.Account__c=a.Id;
        ms1.MSA__c =mc.Id;  
        ms1.Grouping__c=g1.Id;
        insert ms1; 
        
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
        insert p;
        
        
        Property__c p1 = new Property__c();
        p1.Name='Test Namee';
        p1.Zip_Code_Lookup__c=zp.Id;
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
        //p.Group_Membership__c=g.Id;
        insert p1;
        
        Property__c p2 = new Property__c();
        p2.Name='Test Namee';
        p2.Active__c='No';
        p2.Zip_Code_Lookup__c=zp.Id; 
        p2.Price__c=decimal.valueof('12.30');
        p2.Account__c=a.Id;
        p2.Square_Footage__c=decimal.valueof('23.30');
        p2.Bed_Count__c=decimal.valueof('23.30');
        p2.Bath_Count__c=decimal.valueof('23.30');
        p2.Pet_Policy__c='Test pet';
        p2.Lease_Terms__c=decimal.valueof('23.30');
        p2.Address_Line_1__c='Address';
        p2.City__c='Test City';
        p2.State__c='Test State';
        p2.Zip_Code__c='Zip';
        p2.Default_Appointment_Length__c='Test app';
        p2.Group_Membership__c=g1.Id;
        insert p2;
        
        Test.startTest();
        Test.stopTest();
    }
}