global class RMPullEmployeesBatch implements Database.Batchable<Contact>, Database.AllowsCallouts{
	
    public List<Contact> arrobjContacts = new List<Contact>();
    public RMPullEmployeesController rm = new RMPullEmployeesController();
    
    global Iterable<Contact> start(Database.BatchableContext BC) {

		rm.sendRequest();
        arrobjContacts = rm.Contacts;
        return arrobjContacts;
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
       	upsert scope;     
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}