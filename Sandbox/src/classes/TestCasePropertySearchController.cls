@isTest
public class TestCasePropertySearchController {
static testMethod void TestCasePropertySearchController()
    {
        Test.startTest();
       	Account a = new Account();
        a.name = 'Test Account';
        a.Use_Days_on_Market_as_Priority__c = true;
        insert a;
          
        Zip_Code__c z = new Zip_Code__c();
        z.State__c = 'AK';
        z.Latitude__Latitude__s = 25.79;
        z.Latitude__Longitude__s = 25.79;
        z.Longitude__Longitude__s  = -80.13;
        z.Longitude__Latitude__s = -80.13;
        insert z; 
       
        
        /*
         * Id, Active__c, Address_Line_1__c, Address_Line_2__c, Name, Zip_Code__c, City__c, Rent_Range__c, Square_Feet_Range__c, Pet_Policy__c, ' +
            ' Bed_Count__c, Bath_Count__c, Price__c, Move_in_Special1__c, Do_Not_Show__c, State__c, Street_Number__c, Priority_Property__c
         * 
         * 
         */
        Date newdate =  Date.newInstance(2013, 10, 02); 
        Property__c p = new Property__c();
        p.Account__c = a.Id;
        p.Zip_Code_Lookup__c = z.id; 
        p.Street_Number__c = '430';
        p.Address_Line_1__c = '401';
        p.City__c = 'Miami';
        p.State__c = 'IN';
        p.Pet_Policy__c = 'Yes';
        p.Move_in_Special1__c = '35% off';
        p.Smoking__c = 'Yes';
        p.Priority_Property__c = true; 
        p.Date_Available__c = newdate;
        insert p;
        
        Property__c p1 = new Property__c();
        p1.Account__c = a.Id;
        p1.Zip_Code_Lookup__c = z.id; 
        p1.Street_Number__c = '770';
        p1.Address_Line_1__c = '401';
        p1.City__c = 'Florida';
        p1.State__c = 'IN'; 
        p1.Pet_Policy__c = 'Yes';
        p1.Move_in_Special1__c = '35% off';
        p1.Smoking__c = 'Yes';
        p1.Priority_Property__c = true;
        p1.Date_Available__c = newdate;
        insert p1;
        
        
        Property__c p2 = new Property__c();
        p2.Account__c = a.Id;
        p2.Zip_Code_Lookup__c = z.id; 
        p2.Street_Number__c = '997';
        p2.Address_Line_1__c = 'anyonehome1';
        p2.City__c = 'New York';
        p2.State__c = 'AZ';
        p2.Pet_Policy__c = 'Yes';
        p2.Move_in_Special1__c = '35% off';
        p2.Smoking__c = 'Yes';
        p2.Priority_Property__c = true;
        p2.Date_Available__c = newdate;
        insert p2;
          
        Integer startCount = 0,  totalCount = 10;
        String  address = 'anyonehome1, 401,';
        String cities = 'Miami, New York, SB';
        String states= 'IN, AZ',  zipCodes = '',  selectedbeds = '0-1-2-3-4-5-', selectedbaths = '0-1-2-3-5-',  additionalFilters = ' AND Pet_Policy__c = \'Yes\'  AND Move_in_Special1__c != NULL  AND Smoking__c = \'Yes\' ';
 
		CasePropertySearchCOntroller controller = new CasePropertySearchController();
        controller.myMethod(); 
        
        ApexPages.CurrentPage().getparameters().put('pid', p.id);        
        ApexPages.StandardController sc = new ApexPages.StandardController( p );
      	CasePropertySearchCOntroller controller1 = new CasePropertySearchCOntroller(sc); 
        CasePropertySearchCOntroller.GetLocationFiltersData(a.Id);
        CasePropertySearchCOntroller.GetPropertiesCount(a.Id, address, cities, states, zipCodes, selectedbeds, selectedbaths, additionalFilters);
        CasePropertySearchCOntroller.searchProperties( a.Id, a.Use_Days_on_Market_as_Priority__c, startCount, totalCount, address, cities, states, zipCodes, selectedbeds, selectedbaths, additionalFilters);
        Test.stopTest();
    }
}