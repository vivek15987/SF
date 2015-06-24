@isTest(SeeAllData=true) 
public class UpdatePropertyPriceRangeTest {
    static testMethod void validateUpdatePropertyPriceRange () {
        Test.startTest();
        Account a=new Account();
        a.Name ='Test Property ';
        a.Phone='555544443333';
        a.Type='Test Type';
        insert a;
        
        Property__c p = new Property__c();
        p.Account__c = a.Id;
        p.Multi_Family_Property__c = true;
        insert p;
        
        Floor_Plan__c fp = new Floor_Plan__c();
        fp.Account__c = a.Id;
        fp.Property__c = p.Id; 
        insert fp;           
        
        Unit__c unit = new Unit__c();        
        unit.Account__c =  a.Id;
        unit.Property__c = p.Id;
        unit.Floor_Plan__c = fp.Id;
        unit.Active__c = true; 
        unit.X1_Month_Lease__c = 4;
        unit.X2_Month_Lease__c = 200;
        unit.X3_Month_Lease__c = 100;
        unit.X4_Month_Lease__c = 400;
        unit.X5_Month_Lease__c = 500;
        unit.X6_Month_Lease__c = 600;
        unit.X7_Month_Lease__c = 700;
        unit.X8_Month_Lease__c = 800;
        unit.X9_Month_Lease__c = 900;
        unit.X10_Month_Lease__c = 1000;
        unit.X11_Month_Lease__c = 1100;
        unit.X12_Month_Lease__c = 1200;
        unit.X24_Month_Lease__c = 1300; 
        
        insert unit;
        
       Property__c property = [ SELECT Id, Price__c, Multi_Family_Property__c from Property__c WHERE Id =:p.Id Limit 1];
       
       if(property.Multi_Family_Property__c == true) {
           System.assertEquals( 652,property.Price__c);
       }
       
       Test.stopTest(); 
       
       
   }
}