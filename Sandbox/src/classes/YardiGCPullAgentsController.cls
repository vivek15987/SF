public class YardiGCPullAgentsController {

    public LIST<Contact> Contacts 					= new LIST<Contact>();
    public List<Contact> AccountContacts 			= new List<Contact>();
    public Map<String, List<Contact>>AllContacts	= new Map< String, List<Contact>>();
    public List<Property__c> Properties 			= new List<Property__c>();
    public List<Integration__c> searchList 			= new List<Integration__c>();
    final String strInterfaceEntity 				= 'Anyone Home';
    final String strInterfaceLicense 				= 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
    public Set<String> PropertyCodes        		= new Set<String>();
    public Set<String> AccountsURL					= new Set<String>();
    public String strPropertiesXml;

    //Need to seperate pull request in different file / Need to change file name  V.R.S
    public YardiGCPushWsdltoApexController.ItfILSGuestCardSoap yvn; 
    public YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn20;
    public String GetYardiAgentsSourcesResults_Login_responseXML;

    public Map<String, LIST<Contact>> PullYardiAgentsSourcesResults( Boolean isTestYardiGCPullAgentsScheduler ) {

        Map<String, Map<String, Map<String, Set<String>>>> AgentsSources;
        Map<String, Map<String, Set<String>>> PropertyAgents;
        Set<String> AgentsNames = new Set<String>();
        Set<String> UniqueAgentsNames = new Set<String>();
        String PropertyName;

        YardiGCAgentsSourcesResponseController responseController = new YardiGCAgentsSourcesResponseController();

        try{
        	searchList = [ SELECT Id,Account__r.Id, Name, Yardi_Database_Name__c, Push_Guest_Cards_to_Yardi__c, Yardi_Integration_Active__c, Yardi_Server_Name__c, Yardi_ID__c, Yardi_Password__c, Yardi_Platform_Type__c, Yardi_API_URL__c, Yardi_SR_API_URL__c, Grouping__c, Yardi_Version_Number__c FROM Integration__c WHERE Get_Yardi_Agent_Info__c != null ];
        } catch( Exception e ){
            System.debug(e.getMessage());
        }

        if( !searchList.isEmpty() ) {

            for( Integration__c I :searchList ) {   
				System.debug( I );
                if( '4' == I.Yardi_Version_Number__c ){
                    yvn = new  YardiGCPushWsdltoApexController.ItfILSGuestCardSoap();
                    yvn.endpoint_x = I.Yardi_API_URL__c;
                    yvn.timeout_x = 120000;
                    try {
                        if( false == isTestYardiGCPullAgentsScheduler ) {
                            strPropertiesXml = yvn.GetPropertyConfigurations( I.Yardi_ID__c, I.Yardi_Password__c , I.Yardi_Server_Name__c,I.Yardi_Database_Name__c, I.Yardi_Platform_Type__c, strInterfaceEntity, strInterfaceLicense );
                        }
                    } catch( Exception e ) {
                        System.debug( e.getMessage() );
                    }
                 } else {
                     yvn20 = new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
                     yvn20.endpoint_x = I.Yardi_API_URL__c;
                     yvn20.timeout_x = 120000;
                     try{
                         if( false == isTestYardiGCPullAgentsScheduler ) {
                             strPropertiesXml = yvn20.GetPropertyConfigurations( I.Yardi_ID__c, I.Yardi_Password__c , I.Yardi_Server_Name__c,I.Yardi_Database_Name__c, I.Yardi_Platform_Type__c, strInterfaceEntity, strInterfaceLicense );
                         }
                     } catch( Exception e ) {
                        System.debug( e.getMessage() );
                    }
                 }
                
                //fetch properties using property configuration method here for each integration objects.
                this.PropertyCodes.clear();
                
                if( null != strPropertiesXml ) {
                    PropertyCodes = this.GetPropertyConfigurations(strPropertiesXml);
                }
                
                if( null == PropertyCodes ){
                    Properties = [ SELECT Customer_Prop_ID__c  FROM Property__c WHERE Account__c = :I.Account__r.Id AND Customer_Prop_ID__c != null ];
                    if( null != Properties ) {
                        for( Property__c prop :Properties ) {
                            PropertyCodes.add( prop.Customer_Prop_ID__c );
                        }    
                    }
                }
                System.Debug( 'PropertyCodes =>' + PropertyCodes );

                 if( null != UniqueAgentsNames && !UniqueAgentsNames.isEmpty()  ){
                    UniqueAgentsNames.clear();    
                }

                if( null != PropertyCodes ) {
                	for( String p:PropertyCodes ) {
                        try{
                            if( '4' == I.Yardi_Version_Number__c ){
                                if( false == isTestYardiGCPullAgentsScheduler ) {
                                    GetYardiAgentsSourcesResults_Login_responseXML = yvn.GetYardiAgentsSourcesResults_Login( I.Yardi_ID__c, I.Yardi_Password__c , I.Yardi_Server_Name__c,I.Yardi_Database_Name__c, I.Yardi_Platform_Type__c, p , strInterfaceEntity, strInterfaceLicense );
                                }
                            } else {
                                if( false == isTestYardiGCPullAgentsScheduler ) {
                                    GetYardiAgentsSourcesResults_Login_responseXML = yvn20.GetYardiAgentsSourcesResults_Login( I.Yardi_ID__c, I.Yardi_Password__c , I.Yardi_Server_Name__c,I.Yardi_Database_Name__c, I.Yardi_Platform_Type__c, p , strInterfaceEntity, strInterfaceLicense );
                                }
                            }
    
                            System.debug( 'GetYardiAgentsSourcesResults_Login_responseXML = ' + GetYardiAgentsSourcesResults_Login_responseXML );
                            XmlStreamReader reader 									= new XmlStreamReader( GetYardiAgentsSourcesResults_Login_responseXML );
                            YardiGCAgentsSourcesResponseController rspController 	= new YardiGCAgentsSourcesResponseController();
                            PropertyAgents 											= rspController.ParseAgentSourcesXML( reader );
                            AgentsNames 											= PropertyAgents.get(rspController.PropertyCode).get('AgentNames');
    
                            for( String an : AgentsNames ) {
                                if( !UniqueAgentsNames.contains(an) ) {
                                    UniqueAgentsNames.add(an);
                                }
                            }
                        } catch( Exception e ) {
                            System.debug(e.getMessage() );
                        }
                    }
                }

                AccountContacts = new List<Contact>();

                if( !AccountsURL.contains(I.Yardi_API_URL__c) ) {

                    try{
                        AccountContacts = [ SELECT AccountId, FirstName, LastName FROM Contact WHERE AccountId IN (:I.Account__r.Id )];
                    } catch( Exception e ) {
                        System.debug(e.getMessage() );
                    }

                    AccountsURL.add(I.Yardi_API_URL__c);

                    System.debug( 'AccountsURL = ' + AccountsURL );

                	//Not cover inactive date attribute as of now ( because we need to think about remove dependancy) V.R.S
                    if( !UniqueAgentsNames.isEmpty() ) {

                        for( String str: UniqueAgentsNames  ) {
                            
                            Boolean hasContact = false;
                            if( null != AccountContacts ) {
                                for(  Contact c : AccountContacts  ) {
                                    if( null != c.FirstName ) {
                                        if( str == c.FirstName + ' ' + c.LastName  ) {
                                            hasContact = true;
                                        }
                                    } else {
                                        if( str == c.LastName  ) {
                                            hasContact = true;
                                        }
                                    }
                                }
                            }
                            
                            if( !hasContact ){
                                List<String> Name = str.split(' ');
                                Contact NewContact					= new Contact();
                                
                                if( Name.size() == 2 || Name.size() == 1 ) {
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
                                    NewContact.Pulled_from_Yardi__c		= true;
                                    NewContact.ShowPro_User__c 			= true;
                                    Contacts.add(NewContact);
                                }
                            }
                        }
                    } else {
                        System.debug('There is no contacts to insert/update.');
                    }
                   	AllContacts.put( 'Account', Contacts );
                }
            }
        }
        return AllContacts;
    }
    
    public Set<String> GetPropertyConfigurations( String strPropertiesXml ) {       

        XmlStreamReader reader 				= new XmlStreamReader( strPropertiesXml );
        boolean isSafeToGetNextXmlElement 	= true;
        Set<String> propertyCodes 			= new Set<String>();

        while( isSafeToGetNextXmlElement ) {               
           if ( reader.getEventType() == XmlTag.START_ELEMENT ) {  
               if ( 'Code' == reader.getLocalName() ) {

                   XmlStreamReader reader1;
                   boolean isSafeToGetNextXmlElement1 = true;
                   reader1 = reader;

                   //Inner Loop : Iterate tag eventes ( Event Types :  Start , Character , End )
                   while(isSafeToGetNextXmlElement1) {
                       if (reader1.getEventType() == XmlTag.END_ELEMENT) {
                           break;
                       } else if (reader1.getEventType() == XmlTag.CHARACTERS) {
                           propertyCodes.add( String.valueOf( reader1.getText() ) );                             
                       }

                       // Always use hasNext() before calling next() to confirm 
                       // that we have not reached the end of the stream
                       if (reader1.hasNext()) {
                           reader1.next();
                       } else {
                           isSafeToGetNextXmlElement1 = false;
                           break;
                       }
                   }
               }
            }
            
            if ( reader.hasNext() ) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        
        return propertyCodes;
    }
}