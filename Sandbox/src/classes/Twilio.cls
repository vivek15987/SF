global class Twilio {
	    
    @future (callout=true)
    WebService static void send(String IncomingPhoneNumberSid, String ContactId) {
        String account_sid = 'ACd205e012ca96ffb8791a6a58c40460b6';
		String authVersion = '2010-04-01';
        String AuthToken = '9d05ce8c9cf9a2751371e05bc93900c7';
        
        String endpoint = 'https://' + account_sid + ':' +  AuthToken + '@api.twilio.com/'+authVersion+'/Accounts/'+account_sid+ '/IncomingPhoneNumbers/' + IncomingPhoneNumberSid + '.json';
        
        HttpRequest req = new HttpRequest(); 

        req.setMethod('DELETE');
        req.setHeader('Authorization','Basic '+ EncodingUtil.base64Encode(Blob.valueOf(account_sid+':'+AuthToken)));
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setEndpoint(endpoint);
       
        HTTPResponse res = new HTTPResponse();
        if (!Test.isRunningTest()) {
            Http http = new Http();      
            res = http.send(req);    
            
            if (res.getStatusCode() == 204) {
               // update contact.
               Contact c = new Contact();
               c.Id = ContactId;
               c.Twilio_Number_SID__c = NULL;
               c.Twilio_SMS_Number__c = NULL;
               update c;
            }          
        }
    }
}