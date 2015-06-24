global class SFRecordCorrectionBatch implements Database.Batchable<sObject>{    
    public Boolean isTestScheduler = false;

    public SFRecordCorrectionBatch () {}    
    
    public SFRecordCorrectionBatch( Boolean isTestScheduler ) {
       this.isTestScheduler = isTestScheduler; 
    }
    
    global Database.querylocator start(Database.BatchableContext BC){    
        String query;
        if( !this.isTestScheduler ) 
            query = 'SELECT Id, integration_fail_success_message__c FROM Case WHERE integration_fail_success_message__c LIKE \'%XSD Error:The element%\' AND integration_fail_success_message__c LIKE \'%Events%\'';
        else 
            query = 'SELECT Id,GC_Entered__c,integration_fail_success_message__c,Yardi_Guest_Card_ID__c FROM Case WHERE GC_Entered__c = true AND integration_fail_success_message__c = null AND Yardi_Guest_Card_ID__c = null ';
            
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<case> scope){
        List<case> cases = new List<case>();
        
        for(case c : scope){
            
            c.Integration_Failed__c = FALSE;
            c.GC_Entered__c = FALSE;
            c.integration_fail_success_message__c = NULL;   
            
            cases.add(c);
        }  
        
        System.debug( 'vivek' );
          System.debug( 'kunal' );
        update cases;        
    }
    
    global void finish(Database.BatchableContext BC){
    
    }
}