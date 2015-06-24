global class PSIPullFloorPlansScheduler implements Schedulable {

	Integer intervalMinutes;
    Boolean IsPullFloorPlansSchedulerTest;
    
    public PSIPullFloorPlansScheduler() {
        this.intervalMinutes 				= 5;
        this.IsPullFloorPlansSchedulerTest 	= false;
    }
    
    public PSIPullFloorPlansScheduler( Integer intervalMinutes, Boolean IsScheduler ) {
  		this.intervalMinutes 				= intervalMinutes;
        this.IsPullFloorPlansSchedulerTest 	= IsScheduler;
   	}
    
    global void execute(SchedulableContext sc) {
        
        Id SchedulerId, jobId;
        String cronString;
        DateTime now  = DateTime.now();
		try {
            // Re-schedule ourself to run again in "intervalMinutes" time
            if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND Status = 'Holding' ] < 100 ){ 
            	DateTime nextRunTime = now.addMinutes(intervalMinutes);
            	cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
               	
                SchedulerId = System.schedule( PSIPullFloorPlansScheduler.class.getName() + '-' + now.format(), cronString, new PSIPullFloorPlansScheduler( intervalMinutes, this.IsPullFloorPlansSchedulerTest ) );
				
                PSIPullFloorPlansBatch Batch = new PSIPullFloorPlansBatch( this.IsPullFloorPlansSchedulerTest );
                Database.executeBatch( Batch, 3 );
            } else {
                DateTime nextRunTime = now.addMinutes(3);
            	cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
            	
                SchedulerId = System.schedule( PSIPullFloorPlansScheduler.class.getName() + '-' + now.format(), cronString, new PSIPullFloorPlansScheduler( intervalMinutes, this.IsPullFloorPlansSchedulerTest ) );
			}
        	
            jobId = sc.getTriggerId();
            System.abortJob(jobId);
            
            if( true == this.IsPullFloorPlansSchedulerTest ) {
                Account a = new Account();
                insert a;
            }
        } catch( Exception e ) {
            System.Debug( e.getMessage() );
            System.Debug( e.getStackTraceString() );
            
            String strSubject = 'PSIPullFloorPlansScheduler ' + DateTime.now() + ' Error';
            List<String> sendTo = new List<String>();
            sendTo.add('vivek.shah@anyonehome.com');
            
            List<String> ccTo = new List<String>();
            ccTo.add('mitch@anyonehome.com');
            ccTo.add('jaime@anyonehome.com');
            ccTo.add('mahek.joshipura@anyonehome.com');
            
            String ReplyTo = '';
            String SenderDisplayName = 'AnyoneHome Integration Team';
            String body = 'ErrorMessage: <b><I>' + e.getMessage() + '</i></b><br>';
            body += 'StackStrace: <b><I>' + e.getStackTraceString() + '</i></b><br>';
            
            try{ 
				if( null != SchedulerId ) {
                	System.abortJob(SchedulerId);
            	}       
                if( null == jobId ) {
                    jobId = sc.getTriggerId();
            		System.abortJob(jobId);
                }
            	/*
                SendIntegrationFailureEmailsController emailObject = new SendIntegrationFailureEmailsController();
                emailObject.doSendEmail( strSubject, body, sendTo, ReplyTo, ccTo, SenderDisplayName );
                */
            } catch ( Exception e2 ) {
                System.Debug( e2.getMessage() );
            	System.Debug( e2.getStackTraceString() );
            }
            
            DateTime nextRunTime2 = now.addMinutes(3);
            cronString = '' + nextRunTime2.second() + ' ' + nextRunTime2.minute() + ' ' + nextRunTime2.hour() + ' ' + nextRunTime2.day() + ' ' + nextRunTime2.month() + ' ? ' + nextRunTime2.year(); 
		 	
            System.schedule( PSIPullFloorPlansScheduler.class.getName() + '-' + now.format(), cronString, new PSIPullFloorPlansScheduler( intervalMinutes, this.IsPullFloorPlansSchedulerTest ) );
				
        }
        
    }
}