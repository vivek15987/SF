global class CalloutWS {
 @future (callout=true)
    WebService static void Wspost( String argsParam) {

        String calloutURL = 'http://calinvite.anyonehome.com/Default.aspx';
        
        //String calloutURL = 'http://emptrak.ahsits.us/sendinvite.aspx';
        //String calloutURL = 'http://emptrak.ahsits.us/sendmails.aspx';
        //sendinvite.aspx
        
        
        /*
        Agent_Email__c
        Contact_Email__c
        Client_Email__c
        Guest_Email__c
        From__c
        Invite_Status__c
        NoFrom__c
        NoTo__c
        Property_name__c
        To__c
        */
        //string test=calloutURL+argsParam;
        //system.debug(test);
 
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint(calloutURL+argsParam);      
        
        //req.setEndpoint(calloutURL+'/?p1'+connectionId+'&p2='+remoteObject+'&p3='+caseId);
        //req.setEndpoint(calloutURL);
        req.setMethod('GET');
                   System.debug('INside WS callout');
        try { 
            
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