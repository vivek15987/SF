public class AutoArchieveCommunicationMessages {
	public AutoArchieveCommunicationMessages() {
        List<Communication__c> lstCommunications = new List<Communication__c>();
        List<Communication__c> lstMessages =[ Select 
                                         Id, Agent__r.Auto_Archive_Read_Emails_After_Days__c, Date__c
                                         FROM 
                                         Communication__c
                                         WHERE 
                                         Date__c < TODAY
                                         AND Agent__r.Auto_Archive_Read_Emails_After_Days__c != NULL];
       
        for(Communication__c co : lstMessages)
        {               
            if( co.Date__c < date.today().addDays(- Integer.valueOf(co.Agent__r.Auto_Archive_Read_Emails_After_Days__c)) ) {
                co.Archive__c = true;
                lstCommunications.add(co);
            }
        }
        
        if (!Test.isRunningTest()) {
        	upsert(lstCommunications);
        }
    }
}