global class YardiSRScheduler implements Schedulable {    
    Integer intervalMinutes = 1;
    
    public YardiSRScheduler(Integer intervalMinutes) {
        this.intervalMinutes = intervalMinutes;
    } 
    
    global void execute(SchedulableContext sc) {       
        
        Id SchedulerId, jobId;
        String cronString, schedulerName;
        DateTime now  = DateTime.now();
        schedulerName = YardiSRScheduler.class.getName() + ' - ' + now.format();
        
        try {
            if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND Status = 'Holding' ] < 100 && [SELECT count() FROM AsyncApexJob WHERE JobType = 'BatchApex' AND  Status IN ('Holding','Processing','Queued') AND ApexClass.Name = 'YardiSRScheduler'] <= 10 ){ 
                DateTime nextRunTime = now.addMinutes(this.intervalMinutes);
                cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
                
                SchedulerId = System.schedule( schedulerName, cronString, new YardiSRScheduler(this.intervalMinutes) );
                
                //doFutureCall();
                
                YardiSRBatch ObjBatch = new YardiSRBatch();
                Database.executeBatch( ObjBatch, 50 ); 
                
            } else {
                //schedule this same schedulable class again in 3 mins
                DateTime nextRunTime = now.addMinutes(3);
                cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
                
                SchedulerId = System.schedule( schedulerName, cronString, new YardiSRScheduler(this.intervalMinutes) );
            }
            
            jobId = sc.getTriggerId();
            System.abortJob(jobId);
            
        } catch ( Exception e ) {
            System.Debug( e.getMessage() );
            System.Debug( e.getStackTraceString() );
        }
    }
    
   /* @future(callout=true)
    public static void doFutureCall(){
        
        LIST<Service_Request1__c> servicerequestToUpdate = new LIST<Service_Request1__c>();
        LIST<Service_Request1__c> servicerequests = new LIST<Service_Request1__c>();
        
        Integer Count = 0;
        
        YardiSRController wb = new YardiSRController();
        servicerequests = wb.execute();    
        System.debug('Size of Object : ' + servicerequests.size());
        if(servicerequests.size() > 0 ) {
            for( Service_Request1__c sr : servicerequests ) {
                servicerequestToUpdate.add(sr);
                count = count + 1;
                if( ( 199 < servicerequestToUpdate.size() && ( ( servicerequestToUpdate.size() != 1 && math.mod(servicerequests.size(), 199) == 1 ) || count == servicerequests.size() )) || ( 199 >= servicerequests.size() && servicerequests.size() == count ) ) {
                    update servicerequestToUpdate; 
                    servicerequestToUpdate.clear();
                }
            }   
        }
    } */ 
}