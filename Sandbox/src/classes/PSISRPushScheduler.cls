global class PSISRPushScheduler implements Schedulable {

    Integer intervalMinutes;
    Boolean isTestPSISRPushScheduler;
    
    public PSISRPushScheduler() {
        this.intervalMinutes = 5;
        this.isTestPSISRPushScheduler = false;
   	}
    
    public PSISRPushScheduler(Integer intervalMinutes, Boolean isTestPSISRPushScheduler) {
        this.intervalMinutes = intervalMinutes;
        this.isTestPSISRPushScheduler = isTestPSISRPushScheduler;
    }
    
    global void execute(SchedulableContext sc) {
        DateTime now  = DateTime.now();
      	DateTime nextRunTime = now.addMinutes(intervalMinutes);
      	String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 

        if( false == isTestPSISRPushScheduler ) {
            System.schedule( PSISRPushScheduler.class.getName() + '-' + now.format(), cronString, new PSISRPushScheduler( intervalMinutes, this.isTestPSISRPushScheduler ) );
            PSISRPushBatch Batch = new PSISRPushBatch( isTestPSISRPushScheduler );
            Database.executeBatch( Batch, 3 );
            System.abortJob( sc.getTriggerId() );
        }
    }
}