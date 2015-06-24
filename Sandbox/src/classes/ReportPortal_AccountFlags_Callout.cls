global class ReportPortal_AccountFlags_Callout{
 @future (callout=true)
    WebService static void Wspost(String argsParam) {

        String calloutURL ='http://reports.anyonehome.com/AccountMasterService.aspx';
               
        //string testt=calloutURL+argsParam;
        //system.debug(testt);
        
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setEndpoint(calloutURL+argsParam);      
        
       
       
        req.setMethod('GET');
  
        try { 
            
            if (!Test.isRunningTest())
            {   
                res = http.send(req);
            }
            
        }
        catch(System.CalloutException e) {          
            System.debug(res.toString());
        }
    }
 
}