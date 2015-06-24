@isTest(SeeAllData=true) 
public class SendEmailReminderSchedulerTest { 
    
    public static String CRON_EXP = '0 0 0 3 9 ? 2022';
	static testMethod void validateSendEmailRemainderOnLeadEvent() {
          Test.startTest();
        
         String jobId = System.schedule('sendEmailSchedule',
      									 SendEmailReminderScheduler.CRON_EXP, 
         								 new SendEmailReminderScheduler());

      	// Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
             NextFireTime
             FROM CronTrigger WHERE id = :jobId];
       
         System.assertEquals('2022-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));
        
         Test.stopTest();

     }
}