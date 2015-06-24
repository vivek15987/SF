public class PSIGCPullAgentsController {
    public String strLeadPickLists;
    public Set<String> AccountsURL                  = new Set<String>();
    public List<Contact> arrobjContacts				= new List<Contact>();
    
    public void pullPSIAgents( Boolean isPSIGCPullAgentsScheduler ) {

        List<Integration__c> searchList = [ SELECT 
                                                Id, Account__r.Id, Name, PSI_Password__c, PSI_Username__c, PSI_API_URL__c
                                            FROM 
                                                Integration__c
                                            WHERE 
                                                PSI_Integration_Active__c = true
                                            	AND Get_PSI_Agents_Info__c != null ];

        if( !searchList.isEmpty() ) {
            
            for( Integration__c I :searchList ) {   
                
                if( !AccountsURL.contains(I.PSI_API_URL__c) ) {
                    AccountsURL.add( I.PSI_API_URL__c );
                    
                    List<Property__c> Properties = [ SELECT 
                                                        PSI_Prop_ID__c 
                                                    FROM 
                                                        Property__c 
                                                    WHERE 
                                                        Account__c = :I.Account__r.Id 
                                                        AND PSI_Prop_ID__c != null ];
                    
                    if( !Properties.isEmpty() ) {
                        Map<String, String> arrstrLeasingAgentNamesIds  = new Map<String, String>();
                        
                        for( Property__c Property: Properties ) {
                            this.getLeadPickLists( I.PSI_Username__c, I.PSI_Password__c, I.PSI_API_URL__c, Property.PSI_Prop_ID__c, isPSIGCPullAgentsScheduler );
                            
                            if( null != strLeadPickLists ) {
                                Map<String, Object> JSONdeserializedResponse = (Map<String, Object>) JSON.deserializeUntyped( strLeadPickLists );
                        
                                if( JSONdeserializedResponse.containsKey( 'response' ) ) {
                                JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('response');
                                
                                if( JSONdeserializedResponse.containsKey( 'result' ) ) {
                                JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('result');
                                        
                                if( JSONdeserializedResponse.containsKey( 'Property' ) ) {
                                JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('Property');
                                    
                                if( JSONdeserializedResponse.containsKey( Property.PSI_Prop_ID__c ) ) {
                                JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get( Property.PSI_Prop_ID__c );
                                            
                                if( JSONdeserializedResponse.containsKey( 'LeasingAgents' ) ) {
                                JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get( 'LeasingAgents' );
                                                
                                if( JSONdeserializedResponse.containsKey( 'LeasingAgent' ) ) {
                                    List<Object> ListLeasingAgents = ( List<Object> ) JSONdeserializedResponse.get( 'LeasingAgent' );
                                                    
                                    for( Object objLeasingAgent : ListLeasingAgents ) {
                                        Map<String, Object> LeasingAgent = ( Map<String, Object> ) objLeasingAgent;
                                        LeasingAgent = ( Map<String, Object> ) LeasingAgent.get( '@attributes' );
                                        if( !arrstrLeasingAgentNamesIds.containsKey( String.valueOf( LeasingAgent.get( 'Id' ) ) ) ) {
                                            arrstrLeasingAgentNamesIds.put( String.valueOf( LeasingAgent.get( 'Id' ) ), ( String ) LeasingAgent.get( 'name' ) );
                                        }
                                    }
                                }}}}}}
                            }
                        }
                         
                        if( !arrstrLeasingAgentNamesIds.isEmpty() ) {
                            List<Contact> AccountContacts = [ SELECT AccountId, FirstName, LastName FROM Contact WHERE AccountId = :I.Account__r.Id ];
                        	
                            for( String key : arrstrLeasingAgentNamesIds.keyset() ) {
                                List<String> Name = arrstrLeasingAgentNamesIds.get(key).split(' ');
                                
                                if( 2 >= Name.size() ) {
                                    Boolean hasContact = false;
                                    for( Contact c: AccountContacts ) {
                                        if( ( null != c.FirstName && c.FirstName + ' ' + c.LastName == arrstrLeasingAgentNamesIds.get(key) ) || c.LastName == arrstrLeasingAgentNamesIds.get(key) ) {
                                            hasContact = true;
                                            break;
                                        } 
                                    }
                                    
                                    if( !hasContact ) {
                                        Contact newContact = new Contact();
                                        if( Name.size() == 2 ) { 
                                            NewContact.FirstName 			= Name[0];
                                            NewContact.LastName				= Name[1];
                                        } else {
                                            NewContact.LastName				= Name[0];
                                        }
                                        
                                        NewContact.AccountId				= I.Account__r.Id;
                                        NewContact.MobilePhone				= '1234567890';
                                        NewContact.Anyone_Home_Type__c 		= 'Agent';
                                        NewContact.LeadSource 				= 'Other';
                                        //NewContact.Pulled_from_Yardi__c		= true;
                                        NewContact.ShowPro_User__c 			= true;
                                        
                                        arrobjContacts.add(NewContact);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
              public String parseFloorPlanElement( XmlStreamReader reader) {
        String XMLElementValue;
        boolean isSafeToGetNextXmlElement1 = true;
                   
        while(isSafeToGetNextXmlElement1) {
            
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                XMLElementValue = reader.getText();                           	
            }
            
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement1 = false; break;
            }
        }         
        
        return XMLElementValue;
    } 
              
    public void getLeadPickLists( String Username, String Password, String PSI_API_URL, String PropertyId, Boolean isPSIGCPullAgentsScheduler ) {
        JSONGenerator JSONrequest = JSON.createGenerator(true); 
        JSONrequest.writeStartObject();
            JSONrequest.writeFieldName('auth');
                JSONrequest.writeStartObject();
                JSONrequest.writeStringField( 'type', 'basic');
                JSONrequest.writeStringField( 'password', Password );
                JSONrequest.writeStringField( 'username', Username );
            JSONrequest.writeEndObject();
            JSONrequest.writeNumberField( 'requestId' , 15 );   
            JSONrequest.writeFieldName('method');
            JSONrequest.writeStartObject();
                JSONrequest.writeStringField( 'name', 'getLeadPickLists');
                JSONrequest.writeFieldName( 'params' );
                JSONrequest.writeStartObject();
                    JSONrequest.writeStringField( 'propertyIds', PropertyId );
               JSONrequest.writeEndObject();
            JSONrequest.writeEndObject();
        JSONrequest.writeEndObject();
        
        Http httpPro = new Http();
        HttpRequest request = new HttpRequest();
        

        //stringurl="https://api.myresman.com/MITSLite/PostLeadManagement4_0";
        request.setEndPoint( 'https://api.myresman.com/MITSLite/PostLeadManagement4_0' );
        request.setMethod( 'POST' );
        request.setHeader( 'Content-Type', 'application/xml' );
        request.setBody( '<ResMan><IntegrationPartnerID>100</IntegrationPartnerID> <ApiKey>6aw7y9m3m04849lqld6em9sudl5fg01u</ApiKey> <LeadManagement><Prospects><Prospect><Customers><CustomerType="prospect"><IdentificationIDType="PropertyID"IDValue="1234"/><Name></Name><AddressAddressType="current"><FirstName>Amy</FirstName><MiddleName>Rebecca</MiddleName><LastName>Prospect</LastName><AddressLine1>1234MainSt</AddressLine1><AddressLine2>#480</AddressLine2><City>Provo</City><State>UT</State><PostalCode>84601</PostalCode></Address><Email>amy@prospect.com</Email><PhonePhoneType="cell"></Phone></Customer></Customers><CustomerPreferences><DesiredFloorplan>2B2b</DesiredFloorplan><DesiredUnit><MarketingName>1008</MarketingName></DesiredUnit><DesiredRentExact="850.00"/><DesiredNumBedroomsExact="1"/><DesiredLeaseTerms>1</DesiredLeaseTerms></CustomerPreferences><Events><EventEventDate="2013-09-06T13:23:35.944"EventType="WalkIn"><Comments>Interestedinatwobedroomapartment</Comments><FirstContact>true</FirstContact></Event></Events><PhoneNumber>(904)555-5555</PhoneNumber></Prospect></Prospects></LeadManagement> </ResMan> ');
        request.setTimeout( 120000 );
        
        if( true == isPSIGCPullAgentsScheduler ) {
            HTTPResponse res = httpPro.send(request);
        
            strLeadPickLists = res.getBody();       
            System.debug( 'strLeadPickLists -' );
            System.debug( strLeadPickLists );
        }
    }
}