@isTest(SeeAllData=true)
public class SendEmailRemainderOnLeadEventTest {
	static testMethod void validateSendEmailRemainderOnLeadEvent() {
         Account a=new Account();
         a.Name ='TEST';
         a.Phone='9999999';
         a.Type='Test Rohan';
         insert a;
        
         Property__c p = new Property__c();
         p.Account__c = a.Id;
         insert p;
         
         Contact c = new Contact();
         c.FirstName = 'TEST';
         c.LastName = 'User';
         c.Email = 'rohan.patil@anyonehome.com';
         c.AccountId = a.Id;
         insert c;
        
         Lead_Event__c le = new Lead_Event__c();
         le.Name = 'Lead Event';
         le.Agent__c = c.Id;
         le.Comments__c ='Testing';
         le.Send_Reminder_Email__c = true;
         le.Status__c = 'Open';
         insert le;
        
         Test.startTest();
  		 Test.stopTest(); 
     }
}