@isTest
global class HttpPSIPullPropertiesResponse implements HttpCalloutMock {
    global HTTPResponse respond( HTTPRequest req ) {
        // Create a fake response.
        // Set response values, and 
        // return response.
        HttpResponse res = new HttpResponse();
        res.setStatus( 'OK' );
        res.setBody( '{ "response": { "requestId": "15", "result": { "PhysicalProperty": { "Property": [ { "PropertyID": 21458, "ParentPropertyID": "21000", "MarketingName": "Park Avenue I", "Type": "Apartment", "General_ID": "PA-I", "YearBuilt": "2008", "ShortDescription": "Short Description of Park Avenue I.", "LongDescription": "Long Description of Park Avenue I.", "webSite": "http://test.prospectportal.com", "Address": { "-AddressType": "property", "Address": "500 S, 100 W", "City": "Provo", "State": "UT", "PostalCode": "84601", "Country": "US" }, "Phone": { "-PhoneType": "other", "PhoneNumber": "8523516985" }, "IsDisabled": "1", "IsFeaturedProperty": "0" }, { "PropertyID": "22965", "MarketingName": "Park Avenue II", "Type": "Apartment", "General_ID": "PA-II", "YearBuilt": "2009", "ShortDescription": "Short Description of Park Avenue II.", "LongDescription": "Long Description of Park Avenue II.", "webSite": "http://testweb.prospectportal.com", "Address": { "-AddressType": "property", "Address": "200 S, 300 W", "City": "Provo", "State": "UT", "PostalCode": "84601", "Country": "US" }, "Phone": { "-PhoneType": "other", "PhoneNumber": "8525648985" }, "IsDisabled": "0", "IsFeaturedProperty": "1" } ] } } } }' );
        res.setStatusCode( 200 );
        return res;
    }
}