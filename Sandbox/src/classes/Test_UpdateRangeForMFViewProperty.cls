@isTest(SeeAllData=true) 
public class Test_UpdateRangeForMFViewProperty {
    static testMethod void validateUpdateRangeForMFViewProperty () {
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
        fp.Active__c = true; 
        fp.Effective_Rent__c = NULL;
        fp.Market_Rent__c = 500;
        insert fp;           
        
        Unit__c unit = new Unit__c();        
        unit.Account__c =  a.Id;
        unit.Property__c = p.Id;
        unit.Floor_Plan__c = fp.Id;
        unit.Active__c = true; 
        unit.Is_Model_Unit__c = false;
        unit.Is_Waitlist__c = false;
        unit.Effective_Rent__c = NULL;
        unit.Market_Rent__c = 500;
        unit.Square_Feet__c = '450';
        unit.Maximum_Rent__c = 600;
        unit.Minimum_Rent__c = 200;
        unit.Bedrooms__c = 4;
        unit.Bathrooms__c = 3; 
        insert unit;
        
        Unit__c unit1 = new Unit__c();        
        unit1.Account__c =  a.Id;
        unit1.Property__c = p.Id;
        unit1.Floor_Plan__c = fp.Id;
        unit1.Active__c = true; 
        unit1.Is_Model_Unit__c = false;
        unit1.Is_Waitlist__c = false;
        unit1.Effective_Rent__c = 500;
        unit1.Market_Rent__c = 500;
        unit1.Square_Feet__c = '600';
        unit1.Maximum_Rent__c = 600;
        unit1.Minimum_Rent__c = 200;
        unit1.Bedrooms__c = 4;
        unit1.Bathrooms__c = 3; 
        insert unit1;
        
        Unit__c unit2 = new Unit__c();        
        unit2.Account__c =  a.Id;
        unit2.Property__c = p.Id;
        unit2.Floor_Plan__c = fp.Id;
        unit2.Active__c = true; 
        unit2.Is_Model_Unit__c = false;
        unit2.Is_Waitlist__c = false;
        unit2.Effective_Rent__c = NULL;
        unit2.Market_Rent__c = 500;
        unit2.Square_Feet__c = '2000';
        unit2.Maximum_Rent__c = 600;
        unit2.Minimum_Rent__c = 200;
        unit2.Bedrooms__c = 4;
        unit2.Bathrooms__c = 3; 
        insert unit2;
        
        
        
        
        Test.startTest();
        Test.stopTest(); 
        
        //  Floor_Plan__c floorplan = [ SELECT Id,Rent_Range__c from Floor_Plan__c WHERE Id =:unit.Floor_Plan__c Limit 1];
        //  System.assertEquals('$4.0  -  $1300.0',floorplan.Rent_Range__c);
        
    }
}