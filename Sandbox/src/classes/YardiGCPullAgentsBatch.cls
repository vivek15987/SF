global class YardiGCPullAgentsBatch implements Database.Batchable<Contact> ,Database.AllowsCallouts {

    public Boolean isTestYardiGCPullAgentsScheduler = false;
	public YardiGCPullAgentsController YGPullAgents = new YardiGCPullAgentsController();
        
    public YardiGCPullAgentsBatch( Boolean isTestYardiGCPullAgentsScheduler ) {
        this.isTestYardiGCPullAgentsScheduler = isTestYardiGCPullAgentsScheduler;
    }
    
    global Iterable<Contact> start(Database.BatchableContext BC) {
        Map<String, List<Contact>> ContactsToUpdate = new Map<String, List<Contact>>();
        ContactsToUpdate = YGPullAgents.PullYardiAgentsSourcesResults(this.isTestYardiGCPullAgentsScheduler); 
        if( !ContactsToUpdate.isEmpty() ) {
            return ContactsToUpdate.get( 'Account' );
        } else {
            return new List<Contact>();
        }
        
    }

    global void execute(Database.BatchableContext BC, List<Contact> Scope) {
        upsert Scope;
    }

    global void finish(Database.BatchableContext BC) {
     }

    
}