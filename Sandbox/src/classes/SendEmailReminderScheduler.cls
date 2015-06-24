global class SendEmailReminderScheduler implements Schedulable { 
     //Uncomment when running test class SendEmailRemainderOnLeadEventTest
      public static String CRON_EXP = '0 0 0 3 9 ? 2022'; 
      global void execute(SchedulableContext SC) {          
         SendReminderEmailOnLeadEvent sendEmail = new SendReminderEmailOnLeadEvent(); 
         // To Initiate SendReminderEmailOnLeadEvent 
 		 // System.schedule('Send Lead Event Email Reminder', '0 51 17 ? * SUN-SAT' , new SendEmailReminderScheduler() ); 
 		 
     }
}