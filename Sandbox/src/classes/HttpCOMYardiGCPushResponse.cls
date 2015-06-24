@isTest
global class HttpCOMYardiGCPushResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response.
        // Set response values, and 
        // return response.
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setBody('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <ImportYardiGuest_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20"> <ImportYardiGuest_LoginResult> <Messages xmlns=""> <Message messageType="FYI">Xml Imported: 12/4/2014 4:37:11 AM</Message> <Message messageType="FYI">Updated CustomerID: p0072899</Message> </Messages> </ImportYardiGuest_LoginResult> </ImportYardiGuest_LoginResponse> </soap:Body> </soap:Envelope>');
        res.setStatusCode(200);
        return res;
    }
}