@isTest
public class TestRMPullEmployeesController {

    static testMethod void testrmpullemployeescontroller() {

        Account a = new Account();
        a.Name	= 'Test';
        insert a;

        Integration__c i 					= new Integration__c();	
        i.Account__c						= a.Id;
      	i.ResMan_API_URL__c					= 'www.test.com';
        i.ResMan_API_Key__c					= 'apiKey';
        i.ResMan_Integration_Active__c		= true;
        i.ResMan_Integration_Partner_ID__c	= '1234';
        i.Get_ResMan_Agent_Info__c			= 'Realtime';
        i.ResMan_Account_Id__c				= '1231';
        insert i;

        Property__c p 			= new Property__c();
        p.Account__c 			= a.Id;
        p.Name					= 'Test Property';
        p.ResMan_Property_Id__c = 'test';
        insert p;
        
         Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;
        
        RMPullEmployeesScheduler sc = new RMPullEmployeesScheduler();
        RMPullEmployeesScheduler sc1 = new RMPullEmployeesScheduler( 3 );
        System.schedule( 'RMPullEmployeesScheduler', '00 23 14 03 02 ?', new RMPullEmployeesScheduler( 2 ) );
        RMPullEmployeesController controller = new RMPullEmployeesController();
        set<String> PropCodes = new set<String>();
        PropCodes.add( 'test' );
        controller.PropertyCodes = PropCodes; 
        controller.strLeadPickLists = '{"Employees":[{"Name":"Briana Leasing","ID":"4f937793-baf9-4a72-bcc3-3fd06653cecd","Email":"bleasing@gmail.com","SecurityGroup":"Leasing"}],"MethodName":"GetEmployees","Status":"Success","AccountID":400,"PropertyID":"b342e58c-f5ba-4c63-b050-cf44439bb37d"}';
        controller.sendRequest();
        
        RMPullEmployeesBatch EmployeesBatch = new RMPullEmployeesBatch();
        EmployeesBatch.rm  = controller;
		Database.executeBatch( EmployeesBatch, 20 );

    }

}