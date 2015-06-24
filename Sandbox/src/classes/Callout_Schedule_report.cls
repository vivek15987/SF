global class Callout_Schedule_report {
 @future (callout=true)
    WebService static void Fetch_Report_link() {
        //Modify these variables:
       
        String jiraURL = 'http://scheduledreports.anyonehome.com/Run_Scheduler.aspx';
       
 
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
     
        req.setEndpoint(jiraURL);
        req.setMethod('GET');
  
        try {
        if (!Test.isRunningTest())
         {
            res = http.send(req);
            }            
        }
         catch(System.CalloutException e)
          {          
            System.debug(res.toString());
        }
    }
 
}