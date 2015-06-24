public class RMPullEmployeesController {
    
    public List<Contact> Contacts 	= new List<Contact>();
    public String strLeadPickLists 	= '';
    public Set<String> UniqueAgentsNames = new Set<String>();
    public Set<String> PropertyCodes = new Set<String>();

    public void sendRequest() {
        
        System.debug('System.isScheduled() - ' + System.isScheduled());
        System.debug('System.isBatch() - ' + System.isBatch());
        if( System.isScheduled() ) {
            System.debug('True');
        } else {
            System.debug( 'False' );
        }

        List<Integration__c> integrations = [
                                                SELECT
                                                    Id,
                                                    Name,
                                                    Account__c,
                                                    ResMan_API_URL__c,
                                                    ResMan_API_Key__c,
                                                    ResMan_Integration_Partner_ID__c,
            										ResMan_Account_Id__c
                                                FROM
                                               		Integration__c
                                                WHERE
                                                    ResMan_Integration_Active__c = true
            										AND Get_ResMan_Agent_Info__c != null
                                                    AND ResMan_Account_Id__c != NULL
                                            ];
        System.debug( 'Integrations - ' + integrations );
        
        if( null != integrations ) {
            
            for( Integration__c integration : integrations ) {
                
                this.RMGetProperties( integration );
                UniqueAgentsNames.clear();
                List<Property__c> Properties = new List<Property__c>();
                if (!Test.isRunningTest()) {
                    Properties = [ SELECT Id, Name, ResMan_Property_Id__c FROM Property__c WHERE ResMan_Property_Id__c IN :PropertyCodes AND Account__c = : integration.Account__c ];
                } else {
                    Properties = [ SELECT Id, Name, ResMan_Property_Id__c FROM Property__c WHERE Account__c = : integration.Account__c ];    
                }
                
                for( Property__c property :Properties ) {
                    
                    System.debug('property - ' + property);
                    String requestBody 	= 'IntegrationPartnerID=' + integration.ResMan_Integration_Partner_ID__c;
                    requestBody 		= requestBody + '&ApiKey=' + integration.ResMan_API_Key__c;
                    requestBody 		= requestBody + '&AccountID=' + integration.ResMan_Account_Id__c;
                    requestBody 		= requestBody + '&PropertyID=' + property.ResMan_Property_Id__c;
                    
                    Http httpPro = new Http();
                    
                    HttpRequest request = new HttpRequest();
                    request.setEndPoint( integration.ResMan_API_URL__c + 'Leasing/GetEmployees' );
                    request.setBody( requestBody );
                    request.setMethod( 'POST' );
                    request.setHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
                    request.setTimeout( 120000 );
                    
                    if (!Test.isRunningTest()) {
                        HTTPResponse res = httpPro.send(request);
                        strLeadPickLists = res.getBody();       
                    }
                    
                    System.debug( 'Response -' );
                    System.debug( strLeadPickLists.unescapeHtml4()  );
                    
                    //Parse Response
                    parseResponse( strLeadPickLists.unescapeHtml4(), integration.Account__c );
                }
            }
        }
    }
    
    void parseResponse ( String strJSON, String AccountId ) {
        
        System.debug('In Parse');
        Map<String, Object> jsonObjectEmployees   			= ( Map<String, Object> ) JSON.deserializeUntyped(strJSON);
        List<Object>jsonObjectEmployeesDetails      		= ( List<Object> )jsonObjectEmployees.get( 'Employees' );
        String ResManStatus									= ( String ) jsonObjectEmployees.get( 'Status' );
        String ResManAccountID								= '' + ( Integer ) jsonObjectEmployees.get( 'AccountID' );
        String ResManPropertyID								= ( String ) jsonObjectEmployees.get( 'PropertyID' );
        
        if( 'Success' == ResManStatus ) {
            
            for( Object contact_temp : jsonObjectEmployeesDetails ) {
                
                Map<String, Object > contact = ( Map<String, Object >  ) contact_temp;
                
                Contact cnct = new Contact();
                cnct.AccountId = AccountId;

                //Name
                // Name with more/less than size of 2 ????
                
                String Name = '';
                if( true == contact.containsKey( 'Name' ) ) {
                    Name = ( String ) contact.get( 'Name' );
                    if( 2 == Name.split(' ').size() ) {
                        cnct.FirstName			= Name.split(' ')[0];
                        cnct.LastName			= Name.split(' ')[1];
                    }
                }
                
                //Phone
                if( true == contact.containsKey( 'Phone' ) ) {
                    cnct.MobilePhone			= ( String ) contact.get( 'Phone' );
                } else {
                    cnct.MobilePhone			= '1234567890';
                }

                //ID
                String EmployeeId = '';
                if( true == contact.containsKey( 'ID' ) ) {
                    cnct.ResMan_Agent_Id__c		= EmployeeId = ( String ) contact.get( 'ID' );
                }
                
                //Email
                if( true == contact.containsKey( 'Email' ) ) {
                    cnct.Email					= ( String ) contact.get( 'Email' );
                }
                
                //SecurityGroup
                /*String SecurityGroup = '';
                if( true == contact.containsKey( 'SecurityGroup' ) ) {
                    SecurityGroup				= ( String ) contact.get( 'SecurityGroup' );
                    //cnct.ResMan_SecurityGroup	= SecurityGroup;
                }*/
                
                

                cnct.Anyone_Home_Type__c 		= 'Agent';
                cnct.LeadSource 				= 'Other';
                cnct.ShowPro_User__c 			= true;

                system.debug('cnct - ' + cnct );
                System.debug('UniqueAgentsNames ' + UniqueAgentsNames );
                if( !UniqueAgentsNames.contains( EmployeeId ) ) {
                    UniqueAgentsNames.add( EmployeeId );
                    List<Contact> UpdateContact	= [ SELECT Id FROM Contact WHERE ResMan_Agent_Id__c = : EmployeeId AND AccountId = :AccountId LIMIT 1];
                    if( null != UpdateContact ) {
                        for( Contact c : UpdateContact ){
                            cnct.Id	= c.Id;
                        }
                    }
                    
                    System.debug('cnct - ' + cnct);
                    Contacts.add( cnct );
                }
                
            }
            
        } else if( 'Failed' == ResManStatus ) {
            String ErrorDescription				= ( String ) jsonObjectEmployees.get( 'ErrorDescription' );
            System.debug( 'Error - ' + ErrorDescription );
        }
    }
    
    public void RMGetProperties( Integration__c I ) {
        
        String strGetProperties = '';
        Http httpPro = new Http();
        HttpRequest request = new HttpRequest();
        String BodyContent = 'IntegrationPartnerID=' + I.ResMan_Integration_Partner_ID__c + '&ApiKey=' + I.ResMan_API_Key__c + '&AccountID=' +  I.ResMan_Account_Id__c;
        request.setEndPoint( I.ResMan_API_URL__c + 'Account/GetProperties?');
        request.setMethod( 'POST' );
        request.setHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
        request.setHeader( 'Accept' , 'application/json');
        request.setBody( BodyContent );
        request.setHeader('Content-Length', '100'); 
        request.setTimeout( 120000 );
        
        if (!Test.isRunningTest()) {
			HTTPResponse res = httpPro.send(request);
        	strGetProperties = res.getBody();   
            strGetProperties = strGetProperties.unescapeHtml4();
        }
        System.debug( strGetProperties );        
        PropertyCodes.clear();               
        if( '' != strGetProperties ) {
            Map<String, Object> jsonObjectProperties     	 = (Map<String, Object>) JSON.deserializeUntyped(strGetProperties);
            if( jsonObjectProperties.containsKey( 'Properties' ) ) {
                List<Object>Properties_temp                         	 = ( List<Object> )  jsonObjectProperties.get( 'Properties' );
                if( null != Properties_temp ) {
                    for( Object Property_temp: Properties_temp ) {
                        Map<String, Object> PropertyCode_temp         = ( Map<String,Object> ) Property_temp;
                        if( PropertyCode_temp.containsKey( 'PropertyID' ) ) {
                            PropertyCodes.add( String.valueOf( PropertyCode_temp.get( 'PropertyID' ) ) ); 
                        }
                    }
                }
            }
        }
    }
}