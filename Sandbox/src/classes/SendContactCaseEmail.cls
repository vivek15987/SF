global class SendContactCaseEmail {
    
    @future(callout = true)
    global static void SendNotificationEmail(String contactId, String contactName) {  
        
        String calloutURL = 'http://phpjobs-env.elasticbeanstalk.com/callouts/send_contact_cases.php'; 
        String params = '?contact_id='+EncodingUtil.urlEncode( contactId, 'UTF-8')+'&contact_name='+EncodingUtil.urlEncode( contactName, 'UTF-8');
      
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http(); 
         
        req.setEndpoint(calloutURL+params);      
         
        req.setMethod('GET'); 
        try {  
            if( test.isRunningTest() ) {  
                List<Contact> lstcontact = [select Id, FirstName, LastName  From Contact Where Id=:contactId];
                if(lstcontact.size() > 0 ){
                    for (Contact ct: lstcontact)
                    {  
                        String name = ct.FirstName +' '+  ct.LastName; 
                        System.assertEquals( contactName, name );          
                    }  
                } 
            }
            if (!Test.isRunningTest())
            {   
                res = http.send(req);
                System.debug(res.toString());
            }
            
        }
        catch(System.CalloutException e) {          
            System.debug(res.toString());
        } 
    } 
}