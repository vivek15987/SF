global class Callout_SyncGroupNProperties{
 @future (callout=true)
    WebService static void SyncGroupNProperties() {
        //Modify these variables:
       
        String jiraURL = 'http://reports.anyonehome.com/Fetch_Additional_Group_with_Property.aspx';
       
 
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
     
        req.setEndpoint(jiraURL);
        req.setMethod('GET');
        System.debug('Test'+jiraURL);
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