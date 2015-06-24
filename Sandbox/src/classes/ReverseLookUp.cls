global class ReverseLookUp {  
    
    @future(callout = true)
    global static void myMethod(String strPhone, String contactId) {  
        
        String Name = '';
        String firstName = '';
        String lastName = ''; 
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http(); 
        
        if(strPhone != '' && contactId != ''){
          //list of new instance of object to update.   
          List<Contact> new_contact = [select Id,Created_by_ShowPro_User__c From Contact Where Id=:contactId]; 
            if( new_contact.size() > 0 ) { 
                for (Contact c: new_contact)
                {  
                    if( c.Created_by_ShowPro_User__c == null || c.Created_by_ShowPro_User__c == false){
                        strPhone = strPhone.trim(); 
                        
                        Pattern p = Pattern.compile('[^0-9]');  
                        //return a string that contains only numeric values from 0-9 from my original input
                        String cleansed_phone = p.matcher(strPhone).replaceAll('');
                        
                        //String endpoint = 'https://AC9dda331ab8d6494f80da2f034db6b2fe:AU7c012429c21d45a88001ba1bf3140b6a@api.opencnam.com/v2/phone/'+cleansed_phone+'?format=json';
                        String endpoint = 'https://api.opencnam.com/v2/phone/'+cleansed_phone+'?format=json&account_sid=AC9dda331ab8d6494f80da2f034db6b2fe&auth_token=AU7c012429c21d45a88001ba1bf3140b6a';
                        
                        req.setMethod('GET');
                        req.setEndpoint(endpoint);    
                        if( !System.isBatch() && !test.isRunningTest() ) { 
                            res = http.send(req); 
                            System.debug(res.getBody());
                        } else{ 
                            res.setStatus('OK');
                            res.setBody('{ "updated": "2012-10-11T02:33:47.505340",  "name": "GOOGLE INC",  "created": "2012-09-23T18:20:11.807425",  "price": "-0.004", "uri": "/v2/phone/%2B16502530000",  "number": "+16502530000" }');
                            res.setStatusCode(200);
                        } 
                        if (res.getStatusCode() == 200) {  
                            
                            JSONParser parser = JSON.createParser(res.getBody());

                            while (parser.nextToken() != null) {
                                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'name')) { 
                                    parser.nextToken();  
                                    Name = parser.getText();
                                    if(Name.contains(','))
                                    {
                                        List<String> parts  = Name.split(',\\s*'); 
                                        firstName = parts[parts.size()-1];
                                        lastName = parts[0];
                                    } else{
                                        firstName = Name.substringAfter(' ');
                                        lastName = Name.substringBefore(' ');
                                    }  
                                }
                            }  
                        } 
                        if( firstName != '' && lastName != ''){ 
                            c.FirstName = firstName; 
                            c.LastName = lastName; 
                        }
                    }
                }
                //then update the new instance list. 
                upsert new_contact;
                
                
                if( test.isRunningTest() ) { 
                    List<Contact> lstcontact = [select Id, LastName, Name From Contact Where Id=:contactId]; 
                    for (Contact ct: lstcontact)
                    {  
                        System.assertEquals( ct.LastName,'GOOGLE' );  
                        System.assertEquals( ct.Name,'INC GOOGLE' );            
                    }  
                }
            } 
        }
    }
     
}