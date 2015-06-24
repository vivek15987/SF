@isTest(SeeAllData=true)
public class updateMostRecentDateOnContactTest {
    static testMethod void validateUpdateMostRecentDateOnContact() {
         Account a=new Account();
         a.Name ='SurTEST';
         a.Phone='9999999';
         a.Type='Test sur';
         insert a;
        
         Property__c p = new Property__c();
         p.Account__c = a.Id;
         insert p; 
    
         Contact c = new Contact();
         c.FirstName = 'SurTEST';
         c.LastName = 'User';
         c.AccountId = a.Id;
         insert c;
        
         Contact agent = new Contact();
         agent.FirstName = 'TEST';
         agent.LastName = 'User';
         agent.AccountId = a.Id;
         insert agent;
    
         Case ca = new Case();
         ca.AccountId = a.Id;
         ca.Property_of_Interest__c = p.Id;
         ca.ContactId = c.Id;
         insert ca;
        
         Appointment__c app = new Appointment__c(); 
         app.Case__c  = ca.Id;
         app.Contact__c = agent.Id;
         app.Origin_Entity__c = 'Anyone Home Contact Center';
         app.Appointment_Confirmed__c = 'Yes'; 
         Date d = Date.newInstance(2014, 10, 25);
    	 app.Appointment_Date__c = d;
         app.From__c = '6:00 a.m.'; 
         app.To__c = '';
         app.Invite_Status__c = 'Invited';          
         insert app;
         Test.startTest();
  		 Test.stopTest();  
     }
}