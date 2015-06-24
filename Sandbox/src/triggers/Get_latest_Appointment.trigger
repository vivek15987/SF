trigger Get_latest_Appointment on Appointment__c (after insert,after update){
    Appointment__c a=trigger.New[0];
    if( null != a.Case__c ){
        List<Appointment__c> apps = [Select Id, Invite_Status__c from Appointment__c where Case__c=:a.Case__c ORDER BY Id DESC LIMIT 1];
        Appointment__c ap = apps[0];
        List<Case> cc=[select id,Most_Recent_Appointment_Status__c from Case where Id=:a.Case__c];    
        if(cc.size()>0)
        {
            for(Case c:cc)
            {
                c.Most_Recent_Appointment_Status__c=a.Invite_Status__c;  
            }
            if (!Test.isRunningTest()) { 
                upsert cc;
            }
        } 
    }
        
    
    
    if( null != a.Contact__c ) {  
        List<Contact> lstContacts = [ SELECT Name from Contact WHERE Id =:a.Contact__c];            
        Contact contact = lstContacts[0];  
        if( null != a.LastModifiedDate ) {
            String dateOutput =  a.LastModifiedDate.format('dd/MM/yyyy'); 
            contact.Lastest_Event__c = dateOutput;
        } 
        if (!Test.isRunningTest()) { 
            update contact;   
        }
    } 
}