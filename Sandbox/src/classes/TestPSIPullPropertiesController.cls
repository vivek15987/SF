@isTest
public class TestPSIPullPropertiesController {

    static testMethod void testPSIPullPropertiesController() {
        
        Account a = new Account();
        a.Name  = 'Test';
        insert a;

        Integration__c i       = new Integration__c();  
        i.Account__c         = a.Id;
        i.PSI_API_URL__c       = 'https://laramar.propertysolutions.com/api';
        i.PSI_Password__c       = 'Anyonehome!';
        i.PSI_Username__c      = 'joel@anyonehome.com';
        i.Get_PSI_Properties__c    = 'Daily';
        i.PSI_Integration_Active__c = true;
        insert i;

        Property__c p       = new Property__c();
        p.Account__c       = a.Id;
        p.PSI_Prop_ID__c   = '104143';
        insert p;
        
         Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;

        Test.startTest();
        Test.setMock( HttpCalloutMock.class, new HttpPSIPullPropertiesResponse() );
        PSIPullPropertiesController PSIPullProperties     = new PSIPullPropertiesController();
        PSIPullProperties.responseJsonString         = '{ "response": { "requestId": "15", "result": { "PhysicalProperty": { "Property": [ { "PropertyID": 21458, "ParentPropertyID": "21000", "MarketingName": "Park Avenue I", "Type": "Apartment", "General_ID": "PA-I", "YearBuilt": "2008", "ShortDescription": "Short Description of Park Avenue I.", "LongDescription": "Long Description of Park Avenue I.", "webSite": "http://test.prospectportal.com", "Address": { "-AddressType": "property", "Address": "500 S, 100 W", "City": "Provo", "State": "UT", "PostalCode": "84601", "Country": "US" }, "Phone": { "-PhoneType": "other", "PhoneNumber": "8523516985" }, "IsDisabled": "1", "IsFeaturedProperty": "0" }, { "PropertyID": "22965", "MarketingName": "Park Avenue II", "Type": "Apartment", "General_ID": "PA-II", "YearBuilt": "2009", "ShortDescription": "Short Description of Park Avenue II.", "LongDescription": "Long Description of Park Avenue II.", "webSite": "http://testweb.prospectportal.com", "Address": { "-AddressType": "property", "Address": "200 S, 300 W", "City": "Provo", "State": "UT", "PostalCode": "84601", "Country": "US" }, "Phone": { "-PhoneType": "other", "PhoneNumber": "8525648985" }, "IsDisabled": "0", "IsFeaturedProperty": "1" } ] } } } }';
        List<Property__c>  Properties             = PSIPullProperties.getProperties( true );
        PSIPullPropertiesScheduler  TestScheduler       = new PSIPullPropertiesScheduler();
        System.schedule( 'PSIPullPropertiesScheduler', '00 01 12 14 1 ?', new PSIPullPropertiesScheduler( 5, True ) );
        
        PSIPullPropertiesBatch Batch = new PSIPullPropertiesBatch( true );
        Batch.PSIGetProperties = PSIPullProperties;
        Database.executeBatch( Batch, 3 );
        Test.stopTest();

    }
}