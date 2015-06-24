global class CalloutED {
 @future (callout=true)
    WebService static void EDpost( String argsParam) {

        //String calloutURL = 'http://home-c9.incontact.com/inContact/Manage/Scripts/Spawn.aspx?scriptName=Spawn%20Emergency%20Call&bus_no=4593739&scriptId=2558093&skill_no=806811';
        //http://autodial.anyonehome.com/
        
        String calloutURL = 'http://autodial.anyonehome.com/';
 
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        //req.setEndpoint(calloutURL+argsParam);
        
        req.setEndpoint('http://autodial.anyonehome.com/called.aspx?p1='+argsParam);
        
        //+'&p2=&p3=&p4=&p5=&Guid=');//1d50d7c7-4d7a-4b50-881f-08c9fd0ec93f');
        //req.setEndpoint(calloutURL);
                
        req.setMethod('GET');
  
        try { 
            
            if (!Test.isRunningTest())
            {
            
            //chkCalloutED
            //Emergency_Dispatch__c thisiadded=new Emergency_Dispatch__c();
            //thisiadded.Id=argsParam;
            
            //thisiadded.chkCalloutED__C=calloutURL+'&p1='+argsParam+'&p2=&p3=&p4=&p5=&Guid=';//1d50d7c7%2D4d7a%2D4b50%2D881f%2D08c9fd0ec93f%2D';
            //update thisiadded;
            
            res = http.send(req);
            }
            
            
        }
        catch(System.CalloutException e) { 
        
           // Emergency_Dispatch__c thisiadded=new Emergency_Dispatch__c();
              //  thisiadded.Id=argsParam;
                
                //thisiadded.chkCalloutED__C=res.toString()+calloutURL;//+'&p1='+argsParam+'&p2=&p3=&p4=&p5=&Guid=1d50d7c7-4d7a-4b50-881f-08c9fd0ec93f';
               // thisiadded.chkCalloutED__C=res.toString()+calloutURL+'&p1='+argsParam+'&p2=&p3=&p4=&p5=&Guid=';//1d50d7c7-4d7a-4b50-881f-08c9fd0ec93f';
              //  update thisiadded;
        
                 
            System.debug(res.toString());
        }
    }
 
}