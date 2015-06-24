@isTest(SeeAllData=true) 
public class SendReminderEmailOnLeadEventTest {
 	static testMethod void validateSendReminderEmailOnLeadEvent() {
         Test.startTest();
        
         Account a=new Account();
         a.Name ='TEST';
         a.Phone='9999999';
         a.Type='Test Surgaya';
         insert a;
        
         Property__c p = new Property__c();
         p.Account__c = a.Id;
         insert p;
         
         Contact c = new Contact();
         c.FirstName = 'Surgaya';
         c.LastName = 'Khundrakpam'; 
         c.Email = 'surgaya.khundrakpam@anyonehome.com';
         c.AccountId = a.Id;
         insert c;
        
         Contact c1 = new Contact();
         c1.FirstName = 'Test';
         c1.LastName = 'User'; 
         c1.Email = 'test@test.com';
         c1.AccountId = a.Id;
         c1.Agent_Assigned__c = c.Id;
         insert c1; 
        
         Lead_Event__c le = new Lead_Event__c();
         le.Name = 'Lead Event';
         le.Agent__c = c.Id;
         le.Prospect__c = c1.Id;
         le.Comments__c ='Testing';
         le.Send_Reminder_Email__c = true;
         le.Status__c = 'Open';
         le.Date__c =  Date.today();
         le.Type__c  = 'Email';
         le.Time__c  = '6:00 PM'; 
         insert le;
        
         Test.stopTest();

     }
}