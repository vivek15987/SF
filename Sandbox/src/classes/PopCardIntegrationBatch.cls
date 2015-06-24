global class PopCardIntegrationBatch implements Database.Batchable<Case>, Database.AllowsCallouts{
	public List<Case> arrobjCases = new List<Case>();
    public PopCardIntegrationController popcard = new PopCardIntegrationController();
    
    global Iterable<Case> start(Database.BatchableContext BC) {
      	popcard.pushPopCards();
        arrobjCases = popcard.arrobjCases;
       
        return arrobjCases;
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope){
       	upsert scope;     
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}