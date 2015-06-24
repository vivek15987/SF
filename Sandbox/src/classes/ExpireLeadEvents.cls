public class ExpireLeadEvents {
    
     public ExpireLeadEvents() {
        List<Lead_Event__c> lstExpiredLeadEvents = new List<Lead_Event__c>();
        List<Lead_Event__c> leadEvents =[ Select 
                                         	Id, Agent__r.Auto_Expire_Past_Due_Tasks__c, Date__c
                                          FROM 
                                         	Lead_Event__c
                                          WHERE 
                                         	Status__c = 'Open' 
                                         	AND Date__c < TODAY
											AND Agent__r.Auto_Expire_Past_Due_Tasks__c != NULL];
        
        for(Lead_Event__c le : leadEvents)
        {           	
            if( le.Date__c < date.today().addDays(- Integer.valueOf(le.Agent__r.Auto_Expire_Past_Due_Tasks__c)) ) {
                le.Status__c = 'Expired';
                lstExpiredLeadEvents.add(le);
            }
        }
        
        upsert(lstExpiredLeadEvents);
    }
}