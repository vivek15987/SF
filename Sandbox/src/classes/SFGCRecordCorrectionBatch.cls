global class SFGCRecordCorrectionBatch implements Database.Batchable<sObject>{

    public Boolean isTestScheduler = false;

    public SFGCRecordCorrectionBatch () {}    

    public SFGCRecordCorrectionBatch( Boolean isTestScheduler ) {
       this.isTestScheduler = isTestScheduler; 
    }

    global Database.querylocator start(Database.BatchableContext BC){    
        String query;
        if( !this.isTestScheduler ) {
       		query = 'SELECT AccountId,Id,Integration_Failed__c,integration_fail_success_message__c,LastModifiedDate FROM Case WHERE LastModifiedDate = LAST_N_DAYS:2 AND Yardi_Guest_Card_ID__c = NULL AND Integration_Failed__c = true AND AccountId IN ( \'001i0000008nT3CAAU\' ) ';
        } else {
            query = 'SELECT AccountId,Id,Integration_Failed__c,integration_fail_success_message__c,LastModifiedDate FROM Case WHERE LastModifiedDate = LAST_N_DAYS:60 AND Yardi_Guest_Card_ID__c = NULL AND Integration_Failed__c = true';
        }
	    return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<case> scope){
    	List<case> cases = new List<case>();
    	
        for(case c : scope){
            c.Integration_Failed__c = FALSE;
            c.GC_Entered__c = FALSE;
            c.integration_fail_success_message__c = NULL;	
            c.Yardi_Guest_Card_ID__c = NULL;
            cases.add(c);
        }
    	update cases;
    }

    global void finish(Database.BatchableContext BC){
    }
}