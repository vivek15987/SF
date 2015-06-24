trigger SendEmailReminderOnLeadEvent on Lead_Event__c (before insert, after update) {

    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    
    Lead_Event__c[] leadEvents = Trigger.new;
    Lead_Event__c leadEvent = leadEvents[0];
    
    if( true == leadEvent.Send_Reminder_Email__c && null != leadEvent.Agent__c) {
        String intContactId = leadEvent.Agent__c;
        String prospectId = leadEvent.Prospect__c;
        
        List<Contact> lstAgents = [ SELECT Email from Contact WHERE Id =:intContactId];
        List<Contact> lstProspect = [ SELECT Id from Contact WHERE Id =:intContactId];
        
        Contact prospect = lstProspect[0];
        Contact contact = lstAgents[0];
        
       /* if( null != contact.Email ) {
        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           
            EmailTemplate et=[Select id, IsActive from EmailTemplate where name=:'Lead Event Email Reminder'];
           
            if( true == et.IsActive ) {
                List<String> sendTo = new List<String>();
                sendTo.add(contact.Email);
                mail.setToAddresses(sendTo);
                
                mail.setSenderDisplayName('AnyoneHome');
                mail.setTemplateId(et.Id);
                mail.setTargetObjectId(prospect.Id);
                mails.add(mail);
                Messaging.sendEmail(mails);   
            }
        }*/   
    }
}