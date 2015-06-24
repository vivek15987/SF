@istest
class testYardiSRSchedule {

   static testmethod void test() {
   
    /*
       
       Account a = new Account();
        a.Name = 'New Account';
        insert a;        
            
        MSA__c msa = new MSA__c();
        msa.State__c = 'AK';
        msa.MSA_No__c = '99002';
        msa.Name = 'AK NONMETROPOLITAN AREA';
        msa.County_Number__c = 16;
        insert msa;
      
        Property__c p1 = new Property__c();
        p1.Name = 'New Property';
        p1.Account__c = a.id;
        p1.Customer_Prop_ID__c = 'anyhome1';
       insert p1;
       
       Source__c sc = new Source__c();
       sc.Account__c = a.id;
       sc.Property__c = p1.Id;       
       sc.Customer_Service_Source__c = true;
       sc.Source_Type__c = 'Rent.com';
       insert sc;
       
       Integration__c ia = new Integration__c();
       ia.Account__c = a.id;
       ia.Name = 'Yardi Integration';
       ia.Yardi_SR_Integration_Active__c = true;
       ia.Yardi_SR_API_URL__c = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfservicerequests.asmx?WSDL' ;
       ia.Yardi_SR_Database_Name__c =  'afqoml_70dev ';
       ia.Yardi_SR_ID__c = 'anyonehome-svrq';       
       ia.Yardi_SR_Password__c = '58849';
       ia.Yardi_SR_Platform_Type__c ='SQL Server';
       ia.Yardi_SR_Server_Name__c = 'sdb17\\SQL2k8_R2';
       ia.Yardi_SR_Version_Number__c = 'Anyone Home-SR';
       insert ia;
       
       
       String InterfaceEntity = ia.Yardi_SR_Version_Number__c;
       String InterfaceLicence = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQSLpy4Ro7huvEUpSSXkyhBQSByBBAui++BOHOZi6y+7e0F9P63osdEw/UekwyjUarQzRrAYpzgD93l226Ci2qWPYxqWlf8Qg8R7dNnAB/1TIx8roGlhRsUiWXrzuN7AzjGVzOXG+8LI5qLpTELb9+di/M+dOnakGuZKEhM+gOQFN60j10uPBMjeww1D/7OHNGO2JEGPqL94OLZ7yZCRKkAWQUsLlkfYECwJ0MVBzerAxP0wsQ4TEylz4A+KuXKfq7c0RfWzotMc83h0sYpHeSTC1c6vRL8xuxUZPU';
       String SRXML = '<ServiceRequest><ServiceRequestId /><Origin>Email</Origin><PropertyCode>anyhome1</PropertyCode><UnitCode /><TenantCode /><VendorCode /><ServiceRequestBriefDescription>sparkings</ServiceRequestBriefDescription><ServiceRequestFullDescription>sparking</ServiceRequestFullDescription><Priority>High</Priority><Category>Plumbing</Category><SubCategory /><HasPermissionToEnter>True</HasPermissionToEnter><AccessNotes /><ProblemDescriptionNotes /><TechnicianNotes /><TenantCaused /><RequestorName>justin</RequestorName><RequestorPhoneNumber /><RequestorEmail /><AuthorizedBy /><CurrentStatus>Scheduled</CurrentStatus><Resolution>Good</Resolution></ServiceRequest>';
       String PropertyConfigurationsResponseXML;
       
       Test.startTest();
       Test.setMock(HttpCalloutMock.class, new CalloutMock());
       YardiSRWsdltoApexController.ItfServiceRequestsSoap yardiWsdltoApex1 = new YardiSRWsdltoApexController.ItfServiceRequestsSoap();  
       PropertyConfigurationsResponseXML  = yardiWsdltoApex1.GetPropertyConfigurations(ia.Yardi_SR_ID__c,ia.Yardi_SR_Password__c,ia.Yardi_SR_Server_Name__c,ia.Yardi_SR_Database_Name__c,ia.Yardi_SR_Server_Name__c,InterfaceEntity,InterfaceLicence,ia.Yardi_SR_API_URL__c);
       Test.setMock(HttpCalloutMock.class, new CreateorEdit_HttpCallout());
       YardiSRWsdltoApexController.ItfServiceRequestsSoap yardiWsdltoApex = new YardiSRWsdltoApexController.ItfServiceRequestsSoap();  
       YardiSRWsdltoApexController.CreateOrEditServiceRequests_ServiceRequestXml_element requstXML = new YardiSRWsdltoApexController.CreateOrEditServiceRequests_ServiceRequestXml_element();
       requstXML.anyElement = SRXML;
       String serviceResponceXML = yardiWsdltoApex.CreateOrEditServiceRequests_Http(ia.Yardi_SR_ID__c,ia.Yardi_SR_Password__c,ia.Yardi_SR_Server_Name__c,ia.Yardi_SR_Database_Name__c,ia.Yardi_SR_Server_Name__c,'anyonehome00',InterfaceEntity,InterfaceLicence,requstXML,ia.Yardi_SR_API_URL__c);
       
       Test.stopTest(); 
       
       String jobId = System.schedule('testYardiSRScheduler','0 1 * * * ? ',new YardiSRScheduler(2));
       
       YardiSRBatch objBatch = new YardiSRBatch();
       Database.executeBatch(objBatch, 2);*/
   }
}