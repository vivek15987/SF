@isTest(SeeAllData=true) 
public class UpdateFloorplanRentRangeTest{
     static testMethod void validateUpdateFloorplanRentRange () {
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
         unit.X1_Month_Lease__c = 4;
         unit.X2_Month_Lease__c = 200;
         unit.X3_Month_Lease__c = NULL;
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
         
         Unit__c unit1 = new Unit__c();        
         unit1.Account__c =  a.Id;
       	 unit1.Property__c = p.Id;
      	 unit1.Floor_Plan__c = fp.Id;
         unit1.Active__c = true; 
         unit1.Is_Model_Unit__c = false;
         unit1.Is_Waitlist__c = false;
         unit1.Effective_Rent__c = 500;
         unit1.Market_Rent__c = 500;
         unit1.X1_Month_Lease__c = NULL;
         unit1.X2_Month_Lease__c = NULL;
         unit1.X3_Month_Lease__c = NULL;
         unit1.X4_Month_Lease__c = NULL;
         unit1.X5_Month_Lease__c = NULL; 
         unit1.X6_Month_Lease__c = NULL;
         unit1.X7_Month_Lease__c = NULL;
         unit1.X8_Month_Lease__c = NULL;
         unit1.X9_Month_Lease__c = NULL;
         unit1.X10_Month_Lease__c = NULL;
         unit1.X11_Month_Lease__c = NULL;
         unit1.X12_Month_Lease__c = NULL;
         unit1.X24_Month_Lease__c = NULL; 
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
         unit2.X1_Month_Lease__c = NULL;
         unit2.X2_Month_Lease__c = NULL;
         unit2.X3_Month_Lease__c = NULL;
         unit2.X4_Month_Lease__c = NULL;
         unit2.X5_Month_Lease__c = NULL; 
         unit2.X6_Month_Lease__c = NULL;
         unit2.X7_Month_Lease__c = NULL;
         unit2.X8_Month_Lease__c = NULL;
         unit2.X9_Month_Lease__c = NULL;
         unit2.X10_Month_Lease__c = NULL;
         unit2.X11_Month_Lease__c = NULL;
         unit2.X12_Month_Lease__c = NULL;
         unit2.X24_Month_Lease__c = NULL; 
         insert unit2;
         
         

         
         Test.startTest();
  		 Test.stopTest(); 
         
       //  Floor_Plan__c floorplan = [ SELECT Id,Rent_Range__c from Floor_Plan__c WHERE Id =:unit.Floor_Plan__c Limit 1];
       //  System.assertEquals('$4.0  -  $1300.0',floorplan.Rent_Range__c);
         
     }
}