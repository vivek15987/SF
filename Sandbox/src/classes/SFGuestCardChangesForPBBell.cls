global class SFGuestCardChangesForPBBell implements Database.Batchable<sObject>{    
    public Boolean isTestScheduler = false;
    public SFGuestCardChangesForPBBell() {}
    
    public SFGuestCardChangesForPBBell( Boolean isTestScheduler ) {
        this.isTestScheduler = isTestScheduler; 
    }
    
    global Database.querylocator start(Database.BatchableContext BC){     
       	String query;
    	if( !this.isTestScheduler )     
	    	query = 'SELECT Id,integration_fail_success_message__c FROM Case WHERE  Integration_Failed__c = true AND Floor_Plan_of_Interest__c = null AND Unit_of_Interest__c = null AND LastModifiedById = \'005i0000000OegvAAC\' AND LastModifiedDate >= LAST_MONTH AND AccountId = \'001i00000142oXj\'';
       	else
        	query = 'SELECT Id,integration_fail_success_message__c FROM Case WHERE  Integration_Failed__c = true AND Floor_Plan_of_Interest__c = null AND Unit_of_Interest__c = null';
       	
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