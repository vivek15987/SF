public class SendIntegrationFailureEmailsController {
	public void doSendEmail( String strSubject, String body, List<String> sendTo, String ReplyTo, List<String> ccTo, String SenderDisplayName ) {
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses( sendTo );
		
        if( !String.isEmpty(ReplyTo) ) {
        	mail.setReplyTo( ReplyTo );
        }
        
        if( !ccTo.isEmpty() ) {
            mail.setCcAddresses(ccTo);
        }
        	
        mail.setSenderDisplayName( SenderDisplayName );
        mail.setSubject( strSubject );
        mail.setHtmlBody( body );
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        // Step 5. Add your email to the master list
        mails.add(mail);
        
        Messaging.sendEmail(mails);
    } 
}