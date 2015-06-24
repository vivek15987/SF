global class BlockedSFRecordsForBridge implements Database.Batchable<sObject>{

    public Boolean isTestScheduler = false;

    public BlockedSFRecordsForBridge () {}    

    public BlockedSFRecordsForBridge( Boolean isTestScheduler ) {
       this.isTestScheduler = isTestScheduler; 
    }

    global Database.querylocator start(Database.BatchableContext BC){    
        String query;
        if( !this.isTestScheduler ) {
       		query = 'SELECT PC_Integration_Failed__c,PC_Integration_Fail_Success_Message__c,Pop_Card_Entered_in_PMS__c,Yardi_Pop_Card_Id__c FROM Case WHERE AccountId = \'001i000000sjFPS\' AND CreatedDate <= TODAY';
        } else {
            query = 'SELECT PC_Integration_Failed__c,PC_Integration_Fail_Success_Message__c,Pop_Card_Entered_in_PMS__c,Yardi_Pop_Card_Id__c FROM Case WHERE CreatedDate <= TODAY';
        }
	    return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<case> scope){
    	List<case> cases = new List<case>();
    	
        for(case c : scope){
            c.Unit_of_Interest__c = NULL;
            c.PC_Integration_Failed__c = TRUE;
            c.PC_Integration_Fail_Success_Message__c = 'created before integration';
            c.Yardi_Pop_Card_Id__c = '1111';
            cases.add(c);
        }
    	update cases;
    }

    global void finish(Database.BatchableContext BC){
    }
}