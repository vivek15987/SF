public class UpdateProperties implements Database.Batchable<sObject> {
    public String q;
    public UpdateProperties( String accountId ){
        q= 'SELECT Id,Street_Number__c FROM Property__c'; //+  ' WHERE Account__c = \'' + accountId + '\'';      
    } 
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        System.debug(q);
        return Database.getQueryLocator(q);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        for(sobject s : scope){
            s.put('Street_Number__c',''); 
        }
        update scope;
    }
    
    public void finish(Database.BatchableContext BC){
    }
}