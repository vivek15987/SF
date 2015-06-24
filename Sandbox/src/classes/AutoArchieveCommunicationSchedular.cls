global class AutoArchieveCommunicationSchedular implements Schedulable {
	 public static String CRON_EXP = '0 0 6 * * ?'; 
      global void execute(SchedulableContext SC) {          
         AutoArchieveCommunicationMessages e = new AutoArchieveCommunicationMessages();
     }
}