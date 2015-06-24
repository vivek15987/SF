global class CreateorEdit_HttpCallout implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    //res.setBody('GREAT SCOTT');
    res.setBody('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soap:Body><CreateOrEditServiceRequestsResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests"><CreateOrEditServiceRequestsResult><ServiceRequests xmlns=""><ServiceRequest><ServiceRequestId>10825</ServiceRequestId><Origin>Em</Origin><PropertyCode>anyhome1</PropertyCode><ServiceRequestBriefDescription>sparkings</ServiceRequestBriefDescription><ServiceRequestFullDescription>sparking</ServiceRequestFullDescription><Priority>High</Priority><Category>Plumbing</Category><HasPermissionToEnter>true</HasPermissionToEnter><TenantCaused>false</TenantCaused><RequestorName>justin</RequestorName><ServiceRequestDate>2014-12-04</ServiceRequestDate><CreatedBy>Anyone Home-SR</CreatedBy><UpdateDate>2014-12-04T04:53:57</UpdateDate><UpdatedBy>Anyone Home-SR</UpdatedBy><CurrentStatus>Scheduled</CurrentStatus><StatusHistory><Status Type="Scheduled" TimeStamp="2014-12-04T04:53:57" /></StatusHistory><Resolution>Good</Resolution></ServiceRequest></ServiceRequests></CreateOrEditServiceRequestsResult></CreateOrEditServiceRequestsResponse></soap:Body></soap:Envelope>');
    return res;
  }
}