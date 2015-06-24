@isTest
public class TestPSIPullUnitTypesController {

    static testMethod void testPSIPullUnitTypes() {
        
        Account a = new Account();
        a.Name	= 'Test';
        insert a;

        Integration__c i 			= new Integration__c();	
        i.Account__c 				= a.Id;
        i.PSI_API_URL__c 			= 'https://laramar.propertysolutions.com/api';
        i.PSI_Password__c 			= 'Anyonehome!';
        i.PSI_Username__c			= 'joel@anyonehome.com';
        i.Get_PSI_UnitTypes__c		= 'Daily';
        i.PSI_Integration_Active__c = true;
        insert i;

        Property__c p 			= new Property__c();
        p.Account__c 			= a.Id;
        p.PSI_Prop_ID__c 		= '104143';
        insert p; 	
        
         Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;

        Test.startTest();
        PSIPullUnitTypesController PSIPullUnitType = new PSIPullUnitTypesController();
        PSIPullUnitType.responseJsonString			 = '{"response":{"requestId":"15","result":{"property":{"type":"Apartment","propertyId":104143,"marketingName":"Ponderosa Villas","generalId":"7376","yearBuilt":"1986","shortDescription":"Ponderosa Villas is located in the renowned Cherry Creek School district and only minutes from Downtown, Denver Tech and DIA.","longDescription":"Ponderosa Villas is located in the heart of it all! Bel Rea Institute, The Denver Tech Center, Downtown, and DIA are all within minutes of the community. Enjoy close comforts such as Costco, Safeway, Starbucks, Canterbury Park, and Red Robin all within walking distance! Your new one or two bedroom apartment home will have every feature you need and more, including wood burning fireplaces, newly renovated interiors, vaulted ceilings, private patios and balconies, and in-home washer and dryer units. The community features an expansive fitness center, ample parking, mature landscaping, enclosed pet park, two relaxing pools, and covered parking. Add to all this a professional management company and you\'ve found the perfect place to call home!"},"unitTypes":{"unitType":[{"identificationType":{"@attributes":{"idType":"unitTypeId"},"idValue":251533},"name":"non_resi","unitBedRooms":0,"unitBathrooms":0,"minSquareFeet":0,"maxSquareFeet":0},{"identificationType":{"@attributes":{"idType":"unitTypeId"},"idValue":251534},"name":"One bed one bath","unitBedRooms":0,"unitBathrooms":0,"minSquareFeet":720,"maxSquareFeet":720},{"identificationType":{"@attributes":{"idType":"unitTypeId"},"idValue":251535},"name":"Two bed one bath","unitBedRooms":0,"unitBathrooms":0,"minSquareFeet":980,"maxSquareFeet":980},{"identificationType":{"@attributes":{"idType":"unitTypeId"},"idValue":251536},"name":"two bed 1.5 bath","unitBedRooms":0,"unitBathrooms":0,"minSquareFeet":980,"maxSquareFeet":980},{"identificationType":{"@attributes":{"idType":"unitTypeId"},"idValue":251537},"name":"Two bed two bath","unitBedRooms":0,"unitBathrooms":0,"minSquareFeet":980,"maxSquareFeet":980}]}}}}';
        PSIPullUnitType.getUnitTypes();
       
        PSIPullUnitTypesScheduler	TestScheduler	 = new PSIPullUnitTypesScheduler();
        System.schedule( 'PSIPullUnitTypesScheduler', '00 01 12 14 1 ?', new PSIPullUnitTypesScheduler( 5 ) );
        PSIPullUnitTypesBatch Batch = new PSIPullUnitTypesBatch();
        Database.executeBatch( Batch, 10 );
        
        Test.stopTest();

    }
    
}