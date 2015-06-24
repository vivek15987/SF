global class SFGuestCardChangesForBLT implements Database.Batchable<sObject>{    
    public Boolean isTestScheduler = false;
    
    public SFGuestCardChangesForBLT() {}

    public SFGuestCardChangesForBLT( Boolean isTestScheduler ) {
    	this.isTestScheduler = isTestScheduler;
    }   
    
    global Database.querylocator start(Database.BatchableContext BC){     
       	String query;
       	if( !this.isTestScheduler ) 
        	query = 'SELECT Account1__c,AccountId,Id,Integration_Failed__c,integration_fail_success_message__c,LastModifiedById,LastModifiedDate FROM Case WHERE AccountId = \'001i000000ZyFO5\' AND Origin = \'Email\' AND LastModifiedDate >= LAST_MONTH AND Integration_Failed__c = true AND LastModifiedById = \'005i0000000OegvAAC\'';
       	else
        	query = 'SELECT Account1__c,AccountId,Id,Integration_Failed__c,integration_fail_success_message__c,LastModifiedById,LastModifiedDate FROM Case WHERE Origin = \'Email\' AND Integration_Failed__c = true';
       	
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<case> scope){
    	List<case> cases = new List<case>();
    	
        for(case c : scope){
            
            c.Integration_Failed__c = FALSE;
            c.integration_fail_success_message__c = NULL;	
            
            cases.add(c);
        }  
        
        System.debug( 'casee - ' + cases );
    	update cases;        
    }
    
    global void finish(Database.BatchableContext BC){
    
    }
}