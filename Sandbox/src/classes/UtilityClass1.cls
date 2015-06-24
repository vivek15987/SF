public with sharing class UtilityClass1 {
  
    public static List<Messaging.Singleemailmessage> sendEmail(List<EmailMessageWrapper> listEmailMessageWrapper, String emailTemplateName) {
 
          
        String agentName = 'Surgaya Khundrakpam' ;
        String email = 'Email';
        String currDate = '2014-12-01';   
        String currTime = '4:30 PM';
        String prospectName = 'Sur Khund'; 
        String comments = 'This is a test email';
        String prospectId = 'Surkh';  
        
        List<Messaging.SendEmailResult> listEmailResult = null;

        List<Messaging.Singleemailmessage> listSingleEmailMessages = new List<Messaging.Singleemailmessage>();
  
        EmailTemplate emailTemplate=[Select Id, BrandTemplateId,Subject, HtmlValue, Body, IsActive from EmailTemplate where developerName=:emailTemplateName
                                                                                AND IsActive = TRUE];
        OrgWideEmailAddress  org =[SELECT Address, DisplayName,Id FROM OrgWideEmailAddress WHERE Address =: 'customercare@anyonehome.com'];
        System.debug(emailTemplate);
        for (EmailMessageWrapper emailMessageWrapper : listEmailMessageWrapper) {

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(org.Id); 
            
            if(emailMessageWrapper.FromAddress != null && emailMessageWrapper.FromAddress.length() > 0) 
                mail.setReplyTo(emailMessageWrapper.FromAddress);

            if(emailMessageWrapper.ToAddress != null && emailMessageWrapper.ToAddress.length() > 0)  
                mail.setToAddresses(new String[] { emailMessageWrapper.ToAddress }); 
             else
                mail.setTargetObjectId(emailMessageWrapper.ToAddressId);

            if(emailMessageWrapper.BccAddress != null && emailMessageWrapper.BccAddress.length() > 0)

                mail.setBccAddresses(new String[] {emailMessageWrapper.BccAddress });

            String subject = null;
                    
            if(emailMessageWrapper.Subject != null && emailMessageWrapper.Subject.length() > 0) {

                mail.setSubject(emailMessageWrapper.Subject);

                subject = emailMessageWrapper.Subject;

            } 
            else
                subject = emailTemplate.Subject;
 
            for(String key: emailMessageWrapper.ParameterSubjectMap.keySet())

                subject = subject.replace(key, (emailMessageWrapper.ParameterSubjectMap.get(key) == null ? '' : emailMessageWrapper.ParameterSubjectMap.get(key)));
   
            mail.setSubject(subject);
            
            String htmlBody = emailTemplate.HtmlValue;

            String plainBody =  emailTemplate.Body;

            for (String key : emailMessageWrapper.ParameterBodyMap.keySet()) {

                htmlBody = htmlBody.replace(key, (emailMessageWrapper.ParameterBodyMap.get(key) == null) ? '' : emailMessageWrapper.ParameterBodyMap.get(key));

                plainBody = plainBody.replace(key, (emailMessageWrapper.ParameterBodyMap.get(key) == null) ? '' : emailMessageWrapper.ParameterBodyMap.get(key));
         
            } 
            plainBody = '<html>'+plainBody+'<html>';
 
            htmlBody = htmlBody.replaceAll('<!\\[CDATA\\[', ''); // replace '<![CDATA['
            htmlBody= htmlBody.replaceAll('\\]\\]>', ''); // replace ']]'
        
            mail.setHtmlBody(htmlBody); 
            mail.setSaveAsActivity(false); 
            mail.setPlainTextBody(plainBody);    
            
            List<String> toName = mail.getToAddresses();  
            String fromName = mail.getReplyTo();
            
            String htmlBodyContents = mail.getHtmlBody();
            Boolean prospectNameResult = htmlBodyContents.contains(prospectName); 
            if(prospectNameResult) 
                System.assertEquals(prospectNameResult, true);
            
            Boolean emailResult = htmlBodyContents.contains(email);
            if(emailResult) 
                System.assertEquals(emailResult, true);
            
            Boolean currDateResult = htmlBodyContents.contains(currDate);
            if(currDateResult) 
                System.assertEquals(currDateResult, true);
            
            Boolean currTimeResult = htmlBodyContents.contains(currTime);
            if(currTimeResult) 
                System.assertEquals(currTimeResult, true);
            
            Boolean commentsResult = htmlBodyContents.contains(comments);
            if(commentsResult)
                System.assertEquals(commentsResult, true);
             
            Boolean prospectIdResult = htmlBodyContents.contains(prospectId);
            if(prospectIdResult)
                System.assertEquals(prospectIdResult, true);
  
            System.assertEquals(fromName, 'customercare@anyonehome.com');
         
            listSingleEmailMessages.add(mail);        
        }
        listEmailResult = Messaging.sendEmail(listSingleEmailMessages);
        
        for(Messaging.SendEmailResult sendEmailResult: listEmailResult){ 
         if(!sendEmailResult.isSuccess()){ 
             System.assertEquals(sendEmailResult.isSuccess(), false); 
         } else { 
             System.assertEquals(sendEmailResult.isSuccess(), true); 
         }
       }
        return listSingleEmailMessages;
    }
}