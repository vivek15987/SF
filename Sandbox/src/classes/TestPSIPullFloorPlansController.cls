@isTest
public class TestPSIPullFloorPlansController {

    static testMethod void testPSIPullFloorPlans() {
        
        Account a = new Account();
        a.Name	= 'Test';
        insert a;

        Integration__c i 			= new Integration__c();	
        i.Account__c 				= a.Id;
        i.PSI_API_URL__c 			= 'https://laramar.propertysolutions.com/api';
        i.PSI_Password__c 			= 'Anyonehome!';
        i.PSI_Username__c			= 'joel@anyonehome.com';
        i.Get_PSI_Floorplans__c		= 'Daily';
        i.PSI_Integration_Active__c = true;
        insert i;

        Property__c p 			= new Property__c();
        p.Account__c 			= a.Id;
        p.PSI_Prop_ID__c 		= '104143';
        insert p; 
        
        Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;

        Test.startTest();
        PSIPullFloorPlansController PSIPullFloorPlan = new PSIPullFloorPlansController();
        PSIPullFloorPlan.responseJsonString			 = '{ "response":{ "requestId": "15", "result":{ "FloorPlans":{ "FloorPlan":[ { "Identification":{ "@attributes":{ "IDRank":"primary", "IDScopeType":"sender", "IDType":"Floorplan ID" }, "IDValue":456789 }, "Name":"Floorplan 1", "UnitsAvailable":10, "Room":[ { "@attributes":{ "RoomType":"Bedroom" }, "Count":2 }, { "@attributes":{ "RoomType":"Bathroom" }, "Count":1 } ], "SquareFeet":{ "@attributes":{ "Max":900, "Min":900 } }, "MarketRent":{ "@attributes":{ "Max":850, "Min":850 } }, "Deposit":{ "@attributes":{ "DepositType":"security deposit" }, "Amount":{ "@attributes":{ "AmountType":"MonthMultiple" }, "ValueRange":{ "@attributes":{ "Min":250, "Max":250 } } } }, "Amenity":[ { "@attributes":{ "AmenityType":"AdditionalStorage" } }, { "@attributes":{ "AmenityType":"AirConditioner" } } ], "File":[ { "FileType":"Floorplan", "@attributes":{ "FileID":345678, "Active":"true" }, "Description":"2D Floor Plan", "Name":"Floorplan1.jpg", "Caption":"Floorplan1.jpg", "Format":"Jpg", "Width":"480", "Height":"640", "Src":"--MediaPath--" } ] } ] } } } }';
        List<Floor_Plan__c>	FloorPlans				 = PSIPullFloorPlan.getFloorPlans( true );
        PSIPullFloorPlansScheduler	TestScheduler	 = new PSIPullFloorPlansScheduler();
        System.schedule( 'PSIPullFloorPlansScheduler', '00 01 12 14 1 ?', new PSIPullFloorPlansScheduler( 5, True ) );
        PSIPullFloorPlansBatch Batch = new PSIPullFloorPlansBatch( true );
        Batch.PSIPullFloorPlan = PSIPullFloorPlan;
        Database.executeBatch( Batch, 3 );
        
        Test.stopTest();

    }
    
}