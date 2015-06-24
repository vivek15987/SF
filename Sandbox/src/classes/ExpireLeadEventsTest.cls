@isTest(SeeAllData=true) 
public class ExpireLeadEventsTest {
 public static String CRON_EXP = '0 0 0 3 9 ? 2022';
	static testMethod void validateSendReminderEmailOnLeadEvent() {
         Test.startTest();
        
         Account a=new Account();
         a.Name ='TEST';
         a.Phone='9999999';
         a.Type='Test Rohan';
         insert a;
        
         Property__c p = new Property__c();
         p.Account__c = a.Id;
         insert p;
         
         Contact c = new Contact();
         c.FirstName = 'Rohan';
         c.LastName = 'Patil'; 
         c.AccountId = a.Id;
         c.Auto_Expire_Past_Due_Tasks__c = '2';
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
         le.Date__c =  Date.today().addDays(-3);
         le.Type__c  = 'Email';
         le.Time__c  = '6:00 PM'; 
         insert le;
        
        Lead_Event__c le1 = new Lead_Event__c();
         le1.Name = 'Lead Event';
         le1.Agent__c = c.Id;
         le1.Prospect__c = c1.Id;
         le1.Comments__c ='Testing';
         le1.Send_Reminder_Email__c = true;
         le1.Status__c = 'Open';
         le1.Date__c =  Date.today();
         le1.Type__c  = 'Call';
         le1.Time__c  = '6:00 PM'; 
         insert le1;
          
         String jobId = System.schedule('ExpireLeadEventSchedule',
      									 ExpireLeadEventsTest.CRON_EXP, 
         								 new ExpireLeadEventSchedular());

      	// Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
             NextFireTime
             FROM CronTrigger WHERE id = :jobId];
        
         System.assertEquals('2022-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));
        
         Test.stopTest();

     }
}