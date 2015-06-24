@isTest(SeeAllData=true) 
public class UpdateRentRangeTest{
    static testMethod void validateUpdateRentRange () {
        
        Account a=new Account();
        a.Name ='Test';
        a.Phone='2130456';
        a.Type='Test Tyep';
        insert a;
        
        Property__c p = new Property__c();
        p.Account__c = a.Id;
        insert p;
        
        Floor_Plan__c fp = new Floor_Plan__c();
        fp.Account__c = a.Id;
        fp.Property__c = p.Id;
        insert fp;           
        
        Unit__c unit = new Unit__c();        
        unit.Account__c =  a.Id;
        unit.Property__c = p.Id;
        unit.Floor_Plan__c = fp.Id;
        unit.X1_Month_Lease__c = 4;
        unit.X2_Month_Lease__c = 200;
        unit.X3_Month_Lease__c = 0;
        unit.X4_Month_Lease__c = 400;
        unit.X5_Month_Lease__c = 500;
        unit.X6_Month_Lease__c = 600;
        unit.X7_Month_Lease__c = 700;
        unit.X8_Month_Lease__c = 800;
        unit.X9_Month_Lease__c = 900;
        unit.X10_Month_Lease__c = 1000;
        unit.X11_Month_Lease__c = 1100;
        unit.X12_Month_Lease__c = 1200;
        unit.X13_Month_Lease__c = 300;
        unit.X14_Month_Lease__c = 200;
        unit.X15_Month_Lease__c = 300;
        unit.X18_Month_Lease__c = 200;
        unit.X24_Month_Lease__c = 1300;   
        
        system.assertEquals(0,  unit.X3_Month_Lease__c ); 
        system.assertEquals(1300, unit.X24_Month_Lease__c);
        insert unit;
        
        Unit__c unit1 = new Unit__c();        
        unit1 .Account__c =  a.Id;
        unit1 .Property__c = p.Id;
        unit1.Floor_Plan__c = fp.Id;
        unit1.X1_Month_Lease__c = 4;
        unit1.X2_Month_Lease__c = 200;
        unit1.X3_Month_Lease__c = 0;
        unit1.X4_Month_Lease__c = 400;
        unit1.X5_Month_Lease__c = 500;
        unit1.X6_Month_Lease__c = 600;
        unit1.X7_Month_Lease__c = 100;
        unit1.X8_Month_Lease__c = 800;
        unit1.X9_Month_Lease__c = 200;
        unit1.X10_Month_Lease__c = 1000;
        unit1.X11_Month_Lease__c = 1100;
        unit1.X12_Month_Lease__c = 1000;
        unit1.X13_Month_Lease__c = 300;
        unit1.X14_Month_Lease__c = 200;
        unit1.X15_Month_Lease__c = 300;
        unit1.X18_Month_Lease__c = 200;
        unit1.X24_Month_Lease__c = 1100;
        
        system.assertEquals(0,  unit1.X3_Month_Lease__c ); 
        system.assertEquals(1100, unit1.X24_Month_Lease__c);
        insert unit1;         
        
        Test.startTest();        
        Test.stopTest();         
    }
}