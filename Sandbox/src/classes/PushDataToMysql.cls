global class PushDataToMysql {
   
   public class PushDataToMysqlException extends Exception {
    }
	
   @future (callout=true)
    WebService static void push(String message) {
      
		String endpoint = 'http://sfdcdatamigration-env.elasticbeanstalk.com/data_polling/insert_data?data=' + message;
System.debug(endpoint);
        HttpRequest req = new HttpRequest(); 

        req.setMethod('GET');
        req.setEndpoint(endpoint);
        //req.setHeader('Content-Type', 'application/json');
       // req.setBody(message); 
       // req.setCompressed(true);
        
        HTTPResponse res = new HTTPResponse();
        
         try { 
            if (!Test.isRunningTest()) {
                Http http = new Http();      
                res = http.send(req);    
            }
        }
        catch(System.CalloutException e) {          
            System.debug(res.toString());
        }
    }
}