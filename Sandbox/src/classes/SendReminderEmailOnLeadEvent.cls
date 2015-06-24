public class SendReminderEmailOnLeadEvent {
     
     public SendReminderEmailOnLeadEvent() {
        List<String> sendTo = new List<String>();
        List<EmailMessageWrapper> listEmailMessageWrapper = new List<EmailMessageWrapper>();
        List<Messaging.SingleemailMessage> listSingleEmailMessages = new List<Messaging.SingleemailMessage>();
        
        List<Lead_Event__c> leadEvents =[ Select 
                                         	Agent__c, Date__c, Prospect__c, Send_Reminder_Email__c, Status__c, Time__c, Type__c,Comments__c
                                          FROM 
                                         	Lead_Event__c 
                                          WHERE 
                                         	Send_Reminder_Email__c =: true 
                                            AND Status__c =: 'Open' 
                                            AND Date__c = Today ];
       
        for(Lead_Event__c le : leadEvents)
        {  
   			String intContactId = le.Agent__c;
   			String prospectId = le.Prospect__c;
            String todayDate =  String.valueOf(le.Date__c);
             
            List<Contact> lstAgents = [ SELECT Email, Name from Contact WHERE Id =:intContactId];
          	Contact contact = lstAgents[0];
            
            List<Contact> lstProspect = [ SELECT Name from Contact WHERE Id =:prospectId]; 
            Contact prospect = lstProspect[0]; 
              
            if( null != contact.Email ) { 
                
                Map<String, String> mapSubjectParams = new Map<String, String> { 
                    '{!Lead_Event__c.Agent__c}' => contact.Name 
				};
                
                Map<String, String> mapBodyParams = new Map<String, String> { 
						'{!Lead_Event__c.Type__c}' => le.Type__c, 
						'{!Lead_Event__c.Date__c}' => todayDate,  
						'{!Lead_Event__c.Time__c}' => le.Time__c, 
 						'{!Lead_Event__c.Prospect__c}' => prospect.Name, 
                        '{!Lead_Event__c.Comments__c}' => le.Comments__c,
                        '{!Lead_Event__c.ProspectId__c}' => le.Prospect__c
				};
 
              	listEmailMessageWrapper.add(new EmailMessageWrapper('customercare@anyonehome.com', contact.Email, null, null, null, mapSubjectParams, null, mapBodyParams));
            }  
        } 
        if(listEmailMessageWrapper.size() > 0) { 
			listSingleEmailMessages = UtilityClass.sendEmail(listEmailMessageWrapper, 'showpro_new_reminder_task');   
        }
    }  
}