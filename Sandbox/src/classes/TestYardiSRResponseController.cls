@isTest
public class TestYardiSRResponseController {
    
    
    static testMethod void testyardisrresponse() {
        
        Account a = new Account();
        a.Name	= 'Test';
        insert a;
        
        Integration__c i = new Integration__c();	
        i.Account__c = a.Id;
        i.Yardi_SR_ID__c = 'anyonehome-svrq';
        i.Yardi_SR_Password__c = '58849';
        i.Yardi_SR_Server_Name__c = 'sdb17\\SQL2k8_R2';
        i.Yardi_SR_Database_Name__c = 'afqoml_70dev';
        i.Yardi_SR_Platform_Type__c = 'SQL Server';
        i.Yardi_SR_Version_Number__c = 'Anyone Home-SR';
        insert i;
        
        String InterfaceLicence = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQSLpy4Ro7huvEUpSSXkyhBQSByBBAui++BOHOZi6y+7e0F9P63osdEw/UekwyjUarQzRrAYpzgD93l226Ci2qWPYxqWlf8Qg8R7dNnAB/1TIx8roGlhRsUiWXrzuN7AzjGVzOXG+8LI5qLpTELb9+di/M+dOnakGuZKEhM+gOQFN60j10uPBMjeww1D/7OHNGO2JEGPqL94OLZ7yZCRKkAWQUsLlkfYECwJ0MVBzerAxP0wsQ4TEylz4A+KuXKfq7c0RfWzotMc83h0sYpHeSTC1c6vRL8xuxUZPU';
        String endpoint_x = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfilsguestcard.asmx'; //Dev
        
        Test.startTest();
        YardiSRResponseController.ServiceRequest request = new YardiSRResponseController.ServiceRequest();
        
        YardiSRResponseController controller = new  YardiSRResponseController();
        XmlStreamReader streamreader = new XmlStreamReader('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soap:Body><CreateOrEditServiceRequestsResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests"><CreateOrEditServiceRequestsResult><ServiceRequests xmlns=""><ServiceRequest><ServiceRequestId>10825</ServiceRequestId><Origin>Em</Origin><PropertyCode>anyhome1</PropertyCode><ServiceRequestBriefDescription>sparkings</ServiceRequestBriefDescription><ServiceRequestFullDescription>sparking</ServiceRequestFullDescription><Priority>High</Priority><Category>Plumbing</Category><HasPermissionToEnter>true</HasPermissionToEnter><TenantCaused>false</TenantCaused><RequestorName>justin</RequestorName><ServiceRequestDate>2014-12-04</ServiceRequestDate><CreatedBy>Anyone Home-SR</CreatedBy><UpdateDate>2014-12-04T04:53:57</UpdateDate><UpdatedBy>Anyone Home-SR</UpdatedBy><CurrentStatus>Scheduled</CurrentStatus><StatusHistory><Status Type="Scheduled" TimeStamp="2014-12-04T04:53:57" /></StatusHistory><Resolution>Good</Resolution></ServiceRequest></ServiceRequests></CreateOrEditServiceRequestsResult></CreateOrEditServiceRequestsResponse></soap:Body></soap:Envelope>');
        controller.parseServicceRequest(streamreader);
        
        
        
        
        //final XMLInputFactory inputFactory = XMLInputFactory.newInstance();
        //StringReader reader = new StringReader('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soap:Body><CreateOrEditServiceRequestsResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests"><CreateOrEditServiceRequestsResult><ServiceRequests xmlns=""><ServiceRequest><ServiceRequestId>10825</ServiceRequestId><Origin>Em</Origin><PropertyCode>anyhome1</PropertyCode><ServiceRequestBriefDescription>sparkings</ServiceRequestBriefDescription><ServiceRequestFullDescription>sparking</ServiceRequestFullDescription><Priority>High</Priority><Category>Plumbing</Category><HasPermissionToEnter>true</HasPermissionToEnter><TenantCaused>false</TenantCaused><RequestorName>justin</RequestorName><ServiceRequestDate>2014-12-04</ServiceRequestDate><CreatedBy>Anyone Home-SR</CreatedBy><UpdateDate>2014-12-04T04:53:57</UpdateDate><UpdatedBy>Anyone Home-SR</UpdatedBy><CurrentStatus>Scheduled</CurrentStatus><StatusHistory><Status Type="Scheduled" TimeStamp="2014-12-04T04:53:57" /></StatusHistory><Resolution>Good</Resolution></ServiceRequest></ServiceRequests></CreateOrEditServiceRequestsResult></CreateOrEditServiceRequestsResponse></soap:Body></soap:Envelope>');
        //return inputFactory.createXMLStreamReader(reader);
        
        //YardiSRResponseController.parseServicceRequest(streamreader);
        Test.setMock(HttpCalloutMock.class, new HttpCallOutMockupPropConfiguration());
        YardiSRWsdltoApexController.ItfServiceRequestsSoap yardiWsdltoApex1 = new YardiSRWsdltoApexController.ItfServiceRequestsSoap();  
        String PropertyConfigurationsResponseXML  = yardiWsdltoApex1.GetPropertyConfigurations(i.Yardi_SR_ID__c,i.Yardi_SR_Password__c,i.Yardi_SR_Server_Name__c,i.Yardi_SR_Database_Name__c,i.Yardi_SR_Platform_Type__c,i.Yardi_SR_Version_Number__c,InterfaceLicence, endpoint_x);
        
        YardiSRResponseController response = new YardiSRResponseController();
        Set <String> PropertyCodes = response.getPropertyCodes(PropertyConfigurationsResponseXML);
        Test.stopTest();
    }
    
}