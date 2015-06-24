trigger archieveCommunicationMessages on Contact (after update) {
	Contact c = trigger.old[0];
    Contact c1 = trigger.new[0];
   
    if( (NULL != c1.Auto_Archive_Read_Emails_After_Days__c && NULL == c.Auto_Archive_Read_Emails_After_Days__c) || ( NULL != c1.Auto_Archive_Read_Emails_After_Days__c && NULL != c.Auto_Archive_Read_Emails_After_Days__c && Integer.valueOf( c.Auto_Archive_Read_Emails_After_Days__c ) != Integer.valueOf(  c1.Auto_Archive_Read_Emails_After_Days__c ) ) ) {
        List<Communication__c> lstCommunications = new List<Communication__c>();
        List<Communication__c> lstMessages =[ Select 
                                         Id, Agent__r.Auto_Archive_Read_Emails_After_Days__c, Date__c
                                         FROM 
                                         Communication__c
                                         WHERE 
                                         Agent__c =: c.Id
                                         AND Date__c < TODAY
                                         AND Agent__r.Auto_Archive_Read_Emails_After_Days__c != NULL];
        System.debug(lstMessages);
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