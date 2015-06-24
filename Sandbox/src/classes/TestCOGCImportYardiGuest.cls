@isTest
global class TestCOGCImportYardiGuest implements HttpCalloutMock{
	global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <ImportYardiGuest_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard"> <ImportYardiGuest_LoginResult> <Messages xmlns=""> <Message messageType="FYI">Xml Imported: 12/4/2014 5:18:24 AM</Message> <Message messageType="FYI">Updated Prospect CustomerID: p0073520</Message> </Messages> </ImportYardiGuest_LoginResult> </ImportYardiGuest_LoginResponse> </soap:Body> </soap:Envelope>');
    return res;
  }
}