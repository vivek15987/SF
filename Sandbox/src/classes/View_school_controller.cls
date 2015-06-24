public class View_school_controller {
   public  View_school_controller() {  

    }
    
    public  View_school_controller(ApexPages.StandardController stc) {

    }   

    public PageReference myMethod(){       
        return null;
    }   
    @RemoteAction  
    public static List<Map<String,String>> getSchools ( string propertyId ) { 
        
        List<Map<String,String>> result = new List<Map<String,String>>(); 
        
        String Latitude = '';   
        String Longitude = '';
        
        
        List<Property__c> properties = [ SELECT 
                                        Id, Name, Property__c.Zip_Code_Lookup__r.Longitude__Longitude__s, Property__c.Zip_Code_Lookup__r.Latitude__Latitude__s 
                                        FROM Property__c 
                                        WHERE Id =: propertyId Limit 1];
        
        if(properties.size() > 0){
            
            for( Property__c property : properties) {
                if(property.Zip_Code_Lookup__r.Latitude__Latitude__s != null){
                    Latitude = String.valueOf( property.Zip_Code_Lookup__r.Latitude__Latitude__s);
                }
                if(property.Zip_Code_Lookup__r.Longitude__Longitude__s != null){
                    Longitude = String.valueOf( property.Zip_Code_Lookup__r.Longitude__Longitude__s);
                } 
            }
            
            if(Longitude != '' && Latitude != ''){ 
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http(); 
                String username = 'anyonehome';
                String Api_key = 'yVa8A1)!f439!7!2MYY!Wb6Y8c$p7cZP'; 
                
                String  Name = '';
                String xml = '<?xml version="1.0" encoding="UTF-8" ?><data><auth><loginname>'+username+'</loginname><key>'+Api_key+'</key></auth>'+ 
                    '<request><dataset>SAZ</dataset><method>getSchoolByCoord</method><returnType>json</returnType><count>false</count><parameters><lat>'+Latitude+'</lat><lon>'+Longitude+'</lon></parameters></request></data>';
                
                req.setEndpoint('http://api.maponics.com/interface/');
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                req.setMethod('POST');
                req.setBody('apirequest=' + EncodingUtil.urlEncode(xml, 'UTF-8'));
                if( !System.isBatch() && !test.isRunningTest() ) { 
                    res = http.send(req);    
                } else{ 
                    res.setStatus('OK');
                    res.setBody('[{"resultcode":0,"message":"Return OK","requestid":"172-17272899","request":[[{"mx_id":"FL-DADE-2929-FL-PB92023","nces_disid":"1200390","nces_schid":"120039000390","sch_name":"FIENBERG FISHER K-8 CENTER","ed_level":"P","district_name":"MIAMI-DADE COUNTY SCHOOL DISTRICT"},{"mx_id":"FL-DADE-2929-FL-PB92209","nces_disid":"1200390","nces_schid":"120039000594","sch_name":"MIAMI BEACH SENIOR HIGH SCHOOL","ed_level":"H","district_name":"MIAMI-DADE COUNTY SCHOOL DISTRICT"},{"mx_id":"FL-DADE-2929-FL-PB91540","nces_disid":"1200390","nces_schid":"120039000570","sch_name":"NAUTILUS MIDDLE SCHOOL","ed_level":"M","district_name":"MIAMI-DADE COUNTY SCHOOL DISTRICT"},{"mx_id":"FL-DADE-2929-FL-PB92023","nces_disid":"1200390","nces_schid":"120039000390","sch_name":"FIENBERG FISHER K-8 CENTER","ed_level":"M","district_name":"MIAMI-DADE COUNTY SCHOOL DISTRICT"}]]}]');
                    res.setStatusCode(200);
                }  
                
                if (res.getStatusCode() == 200) {    
                    JSONParser parser = JSON.createParser(res.getBody());
                    Map<String,String> tmp = new Map<String,String>();
                    
                    while (parser.nextToken() != null) {
                        
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'sch_name')) {  
                            parser.nextToken();  
                            Name = parser.getText();
                            tmp.put('School_Name', Name);
                            
                        }
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'ed_level')) {  
                            parser.nextToken();  
                            Name = parser.getText();
                            tmp.put('School_Level', Name);
                            
                        }
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'district_name')) {  
                            parser.nextToken();  
                            Name = parser.getText();
                            tmp.put('District_Name', Name); 
                            result.add(tmp);  
                            tmp = new Map<String,String>(); 
                        } 
                        
                    }  
                }   
            } 
        } 
        
        return result; 
    }
}