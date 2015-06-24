@isTest
public class TestYardiSRController {

    static testMethod void testyardisrcontroller() {

        Test.startTest();

        Account A = new Account();
        A.Name = 'Test Account';
        insert A;
        
        Grouping__c gr = new Grouping__c();
        gr.Account__c = A.Id;
        gr.Name = 'Group';
        insert gr;
        
        Property__c p = new Property__c ();
        p.Name = 'TestProperty';
        p.Account__c = A.Id;
        p.Group_Membership__c = gr.Id;
        p.Address_Line_1__c = 'Add test';
        p.Address_Line_2__c = 'Add test2';
        p.Customer_Prop_ID__c = 'Test';
        insert p;
        
        Integration__c i = new Integration__c();	
        i.Account__c = a.Id;
        i.Grouping__c = gr.Id;
        i.Yardi_SR_ID__c = 'anyonehome-svrq';
        i.Yardi_SR_Password__c = '58849';
        i.Yardi_SR_Server_Name__c = 'sdb17\\SQL2k8_R2';
        i.Yardi_SR_Database_Name__c = 'afqoml_70dev';
        i.Yardi_SR_Platform_Type__c = 'SQL Server';
        i.Yardi_SR_Version_Number__c = 'Anyone Home-SR';
        i.Yardi_SR_Integration_Active__c = true;
        insert i;
        
        String InterfaceLicence = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQSLpy4Ro7huvEUpSSXkyhBQSByBBAui++BOHOZi6y+7e0F9P63osdEw/UekwyjUarQzRrAYpzgD93l226Ci2qWPYxqWlf8Qg8R7dNnAB/1TIx8roGlhRsUiWXrzuN7AzjGVzOXG+8LI5qLpTELb9+di/M+dOnakGuZKEhM+gOQFN60j10uPBMjeww1D/7OHNGO2JEGPqL94OLZ7yZCRKkAWQUsLlkfYECwJ0MVBzerAxP0wsQ4TEylz4A+KuXKfq7c0RfWzotMc83h0sYpHeSTC1c6vRL8xuxUZPU';
        String endpoint_x = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfilsguestcard.asmx'; //Dev
        
        Service_Request_Type__c srtype = new Service_Request_Type__c();
        srtype.Account__c = A.Id;
        srtype.Grouping__c = gr.Id;
        srtype.Name = 'TestRequestType';
        srtype.CS_Request_Type__c = false;
        insert srtype;

        Contact c = new Contact();
        c.FirstName = 'FirstTest';
        c.LastName = 'LastTest';
        c.AccountId = A.Id;
        c.Email = 'test@gmail.com';
        insert c;
        
        Service_Request1__c sr = new Service_Request1__c();
        sr.Account_Name__c = a.Id;
        sr.Property_of_Interest__c = p.Id;
        sr.Service_Request_Type__c = srtype.Id;
        sr.Work_Order_Entered_in_PMS__c = false;
        sr.Status__c = 'Request Sent';
        sr.Case_Origin__c = 'Phone';
        sr.Contact_Name__c = c.Id;
        sr.Unit_Name__c = '202';
        sr.Work_Order_Notes__c = 'Test';
        sr.Permission_to_Enter__c = 'Yes';
        insert sr;
        
        System.schedule( 'YardiSRScheduler', '00 54 16 22 05 ?', new YardiSRScheduler( 2 ) );

        Test.stopTest();
    }
}