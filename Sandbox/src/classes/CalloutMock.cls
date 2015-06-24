@isTest
global class CalloutMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    //res.setBody('GREAT SCOTT');
    res.setBody('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><GetPropertyConfigurationsResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard"><GetPropertyConfigurationsResult><Properties xmlns=""><Property><Code>anyhome1</Code><MarketingName>Anyone Home 1 Test Prop</MarketingName><AddressLine1>430 South Fairview Avenue</AddressLine1><AddressLine2/><AddressLine3/><City>Goleta</City><State>CA</State><PostalCode>93117</PostalCode></Property></Properties></GetPropertyConfigurationsResult></GetPropertyConfigurationsResponse></soap:Body></soap:Envelope>');
    return res;
  }
}