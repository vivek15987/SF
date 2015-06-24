@isTest(SeeAllData=true) 
public class AutoArchieveCommunicationMessagesTest {
	public static String CRON_EXP = '0 0 0 3 9 ? 2022';
	static testMethod void validateAutoArchieveCommunicationMessages() {
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
        
         Communication__c le = new Communication__c();
         le.Name = 'Communication 1';
         le.Agent__c = c.Id;       
         le.Date__c =  Date.today().addDays(-3);
         insert le;
        
        
        Communication__c le1 = new Communication__c();
         le1.Name = 'Communication 2';
         le1.Agent__c = c.Id;
         le1.Date__c =  Date.today();
         insert le1;
          
         String jobId = System.schedule('AutoArchieveCommunicationSchedule',
      									 AutoArchieveCommunicationMessagesTest.CRON_EXP, 
         								 new AutoArchieveCommunicationSchedular());

      	// Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
             NextFireTime
             FROM CronTrigger WHERE id = :jobId];
        
         System.assertEquals('2022-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));
        
         Test.stopTest();

     }
}