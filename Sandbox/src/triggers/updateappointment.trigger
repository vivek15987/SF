trigger updateappointment on Property__c (after update){
    
    Set<String> PropertyNames = new Set<String>();
    List<Appointment__c> listappointment = new List<Appointment__c>();
    for( Property__c p : trigger.new ) {
        PropertyNames.add( p.name );
    }        
    
    List<Appointment__c> appList =[Select Id,Invite_Status__c,CanceledRejected_By__c From Appointment__c where Property_name__c IN:PropertyNames and Property__r.Active__c = 'No' and Appointment_Date__c>=today AND (Invite_Status__C='Invited' OR Invite_Status__C='Accepted') ];
    system.debug('appList - '+appList.size());
    if (appList.size()>0)
    {
        for (Appointment__c aa:appList)
        {
            aa.Invite_Status__c='Canceled' ;          
            aa.CanceledRejected_By__c='Automated System (home leased)';
            listappointment.add(aa);            
        }        
    }
    Update listappointment;     
}