global class ExpireLeadEventSchedular implements Schedulable { 
     public static String CRON_EXP = '0 0 6 * * ?'; 
      global void execute(SchedulableContext SC) {          
         ExpireLeadEvents e = new ExpireLeadEvents();
     }
}