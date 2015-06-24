@isTest
private class Test_UpdateMarketName2 {
    static testMethod void UnitTestagentemail2()
    { 
        Account a = new Account();
        a.Name='Test Account';
        a.Phone='2130456';
        a.Type='Test Tyep';
        insert a;
        
        Contact con=new Contact();
        con.AccountId=a.Id;
        con.FirstName='Test'; 
        con.LastName='Test';
        insert con;
        
        Grouping__c g = new Grouping__c();
        g.Name='Test Name';
        g.Account__c=a.Id;
        insert g;
        
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
        ms.Grouping__c=g.Id;
        insert ms;
        
        Source__c s = new Source__c();
        s.Account__c=a.Id;
        s.Grouping__c=g.Id;
        insert s;
        
        Source__c ss = new Source__c();
        ss.Account__c=a.Id;
        ss.Grouping__c=g.Id;
        ss.Property__c=p.Id;
        insert ss;
        
        Case c_sour=new Case(); 
        c_sour.Account_MSA_Junction__c=ms.Id;
        c_sour.Status='Test';
        c_sour.AccountId=a.Id;
        c_sour.Ad_Source2__c=ss.Id;
        c_sour.Property_of_Interest__c=p.Id; 
        insert c_sour;
        
        Case c=new Case(); 
        c.Account_MSA_Junction__c=ms.Id;
        c.Status='Test';
        c.AccountId=a.Id;
        c.Property_of_Interest__c=p.Id; 
        insert c;
        
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
        p1.Group_Membership__c=g.Id;
        insert p1; 
        
        Account_MSA_Connection__c ms1=new Account_MSA_Connection__c();
        ms1.Name='Test AMC';
        ms1.Account__c=a.Id;
        ms1.MSA__c =mc.Id;  
        ms1.Grouping__c=g.Id;
        insert ms1; 
        
        Case c1=new Case(); 
        c1.Account_MSA_Junction__c=ms1.Id;
        c1.Status='Test';
        c1.AccountId=a.Id;
        c1.Property_of_Interest__c=p1.Id; 
        insert c1;
        
        Property__c p2 = new Property__c();
        p2.Name='Test Namee';
        p2.Zip_Code_Lookup__c=zp.Id;
        p2.Active__c='Yes';
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
        insert p2;
        
        Account_MSA_Connection__c ms2=new Account_MSA_Connection__c();
        ms2.Name='Test AMC';
        ms2.Account__c=a.Id;
        ms2.MSA__c =mc.Id;  
        ms2.Grouping__c=g.Id;
        insert ms2;  
        
        Case c2=new Case(); 
        c2.Account_MSA_Junction__c=ms2.Id;
        c2.Status='Test';
        c2.AccountId=a.Id;
        c2.Property_of_Interest__c=p2.Id;
        c2.Ad_Source2__c=s.Id;
        insert c2;
        
        Property_Agent__c pa=new Property_Agent__c(); 
        pa.Property__c=c2.Property_of_Interest__c;
        pa.Contact__c=con.Id;
        pa.Roles__c=null;
        insert pa;
        
        Property_Agent__c pa1=new Property_Agent__c(); 
        pa1.Property__c=c1.Property_of_Interest__c;
        pa1.Contact__c=con.Id;
        pa1.Roles__c='Primary Agent';
        insert pa1;
        
        Test.startTest();
        Test.stopTest();
    }
}