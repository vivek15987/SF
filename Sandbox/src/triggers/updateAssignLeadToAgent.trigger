trigger updateAssignLeadToAgent on Appointment__c (after insert, after update) {
    
    Appointment__c app = trigger.New[0];

    if( null != app.Case__c ) {
        Case c = [Select Id, ContactId from Case where Id=:app.Case__c LIMIT 1];
          System.debug('c===>'+c);
        if(null != c.ContactId) {
            Contact c1 = new Contact();
            c1.Id = c.ContactId;
            
            c1.Agent_Assigned__c = app.Contact__c;
            system.debug('app.contact__c+++++++' +app.Contact__c);
            update c1;
            
        }
    }  
}