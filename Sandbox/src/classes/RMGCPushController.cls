public with sharing class RMGCPushController {
    
    public String GCResponse;
    public String resultSearchProspect;
    public String resultProspectSource;
    public String resultLostReason;
    public String strGetProperties;
    
    public Boolean isShowProUser                  		= false;
    public Boolean IsFirstContactTrue                 	= false;
    public Boolean IsFirstEventSent                  	= false;
    public Set<String> PropertyCodes                 	= new Set<String>();
    public List<String> strCredentials                  = new List<String>();
    public List<Case> updatedCases                      = new List<Case>();
    public List<Case> ValidateCases                  	= new List<Case>();
    public List<Map<String, String>> updatedEvents      = new List<Map<String, String>>();
    public LIST<Appointment__c> NeedToUpdateAppointments= new List<Appointment__c>();
    public Map<String, String> arrCases                	= new Map<String, String>();
    Map<String, String> LostProspects                	= new Map<String, String>();
    public Map<String, String> hours                    = new Map<String, String>();
    public Map<String, Object> Result                	= new Map<String, Object>();
    public Map<String, String> IntegrationsCredentials					    	= new Map<String, String>();
    
    public Map<String, Map<String, String>> IntegrationsCredentialsPerAccount   = new Map<String, Map<String, String>>();
    public Map<String, Map<String, String>> LostProspectsPerAccount        		= new Map<String, Map<String, String>>();
    public Map<String, Map<String, String>> TransactionResourcesPerProperty    	= new Map<String, Map<String, String>>();
    
    public RMGCPushController() {  
        hours.put( '0' ,'00:00:00' );
        hours.put( '1' ,'23:00:00' );
        hours.put( '2' ,'22:30:00' );
        hours.put( '3' ,'22:00:00' );
        hours.put( '4' ,'21:30:00' );
        hours.put( '5' ,'21:00:00' );
        hours.put( '6' ,'20:30:00' );
        hours.put( '7' ,'20:00:00' );
        hours.put( '8' ,'19:30:00' );
        hours.put( '9' ,'19:00:00' );
        hours.put( '10' ,'18:30:00' );
        hours.put( '11' ,'18:00:00' );
        hours.put( '12' ,'17:30:00' );
        hours.put( '13' ,'17:00:00' );
        hours.put( '14' ,'16:30:00' );
        hours.put( '15' ,'16:00:00' );
        hours.put( '16' ,'15:30:00' );
        hours.put( '17' ,'15:00:00' );
        hours.put( '18' ,'14:30:00' );
        hours.put( '19' ,'14:00:00' );
        hours.put( '20' ,'13:30:00' );
        hours.put( '21' ,'13:00:00' );
        hours.put( '22' ,'12:30:00' );
        hours.put( '23' ,'12:00:00' );
        hours.put( '24' ,'11:30:00' );
        hours.put( '25' ,'11:00:00' );
        hours.put( '26' ,'10:30:00' );
        hours.put( '27' ,'10:00:00' );
        hours.put( '28' ,'09:30:00' );
        hours.put( '29' ,'09:00:00' );
        hours.put( '30' ,'08:30:00' );
        hours.put( '31' ,'08:00:00' );
        hours.put( '32' ,'07:30:00' );
        hours.put( '33' ,'07:00:00' );
        hours.put( '34' ,'06:30:00' );
        hours.put( '35' ,'06:00:00' );        
    } 
    
    public List<Case> pushGuestCards() { 
        
        Set<String> RMPropIds                       = new Set<String>();
        Set<String> RMAccountIds                    = new Set<String>();
        Map<String, String> RMPropertyIdsPerAccount = new Map<String, String>();
        Map<String, String> PropertiesPerAccount 						= new Map<String, String>();
        Map<String, Map<String, String>> WaitListUnitAndFpPerProperty   = new Map<String, Map<String, String>>();
        
        if( !ValidateCases.isEmpty() ) {
            for( Case cs : ValidateCases ) { 
                if( ! RMPropertyIdsPerAccount.containsKey( cs.Property_of_Interest__r.ResMan_Property_Id__c ) )
                    RMPropertyIdsPerAccount.put( cs.Property_of_Interest__r.ResMan_Property_Id__c , cs.AccountId );
                
                if( ! RMAccountIds.contains( cs.AccountId ) )
                    RMAccountIds.add( cs.AccountId );
                
                if( !RMPropIds.contains( cs.Property_of_Interest__r.ResMan_Property_Id__c ) ) {
                    if( null != cs.Property_of_Interest__r.Group_Membership__c  ) {
                        PropertiesPerAccount.put( cs.Property_of_Interest__r.ResMan_Property_Id__c, cs.Property_of_Interest__r.Group_Membership__c  );
                    } else {
                        PropertiesPerAccount.put( cs.Property_of_Interest__r.ResMan_Property_Id__c, cs.AccountId );
                    }
                    RMPropIds.add( cs.Property_of_Interest__r.ResMan_Property_Id__c );
                }
                    
            }
        }
        
        for( String RMAccountId :RMAccountIds ) {
            if( IntegrationsCredentialsPerAccount.containsKey( RMAccountId ) ) {
                this.GetLostProspectReasons( RMAccountId, IntegrationsCredentialsPerAccount.get( RMAccountId ) );
            }
        }
        
        for( String RMPropId : RMPropIds ) {
            if( RMPropertyIdsPerAccount.containsKey( RMPropId ) && IntegrationsCredentialsPerAccount.containsKey( RMPropertyIdsPerAccount.get( RMPropId ) ) )
                this.GetProspectSources( IntegrationsCredentialsPerAccount.get( RMPropertyIdsPerAccount.get( RMPropId ) ), RMPropId );
        }
        
        List<Unit__c> Waitlist = new List<Unit__c>();
        if( !Test.isRunningTest() ) {
            Waitlist = [SELECT Id, Floor_Plan__r.ResMan_Floor_Plan_ID__c, ResMan_Unit_ID__c, Property__c, Property__r.ResMan_Property_Id__c FROM Unit__c WHERE Floor_Plan__r.Is_Waitlist__c = true AND Is_Waitlist__c = true AND Floor_Plan__r.ResMan_Floor_Plan_ID__c != NULL AND ResMan_Unit_ID__c != NULL AND Property__r.ResMan_Property_Id__c IN : RMPropIds ];
        } else {
            Waitlist = [SELECT Id, Floor_Plan__r.ResMan_Floor_Plan_ID__c, ResMan_Unit_ID__c, Property__c, Property__r.ResMan_Property_Id__c FROM Unit__c ];
        }
        
        if( !Waitlist.isEmpty() ) {
            for( Unit__c unit:Waitlist ) {
                if( false == WaitListUnitAndFpPerProperty.containsKey( unit.Property__c ) ) {
                    Map<String, String> WaitlistUnitPerFp = new Map<String, String>();
                    WaitlistUnitPerFp.put( unit.Floor_Plan__r.ResMan_Floor_Plan_ID__c , unit.ResMan_Unit_ID__c );
                    WaitListUnitAndFpPerProperty.put( unit.Property__c , WaitlistUnitPerFp );
                }
            }
        }
        
        for( Case cs : ValidateCases ) {
            
            try {
                List<Appointment__c> AppointmentPerCase  = new List<Appointment__c>();
                Dom.Document doc           = new Dom.Document();
                Dom.XmlNode LeadManagementNode     = doc.createRootElement( 'LeadManagement', null, null );
                Dom.XmlNode Prospects         = LeadManagementNode.addChildElement( 'Prospects', null, null );
                Dom.XmlNode Prospect           = Prospects.addChildElement( 'Prospect', null, null );
                Dom.XmlNode Customers         = Prospect.addChildElement( 'Customers', null, null );
                Dom.XmlNode Customer           = Customers.addChildElement( 'Customer', null, null );
                Customer.setAttribute( 'Type', 'prospect' );
                
                if( null != cs.Yardi_Guest_Card_ID__c && null != cs.PMS_Applicant_ID__c ) {
                    
                    Dom.XmlNode Identification           = Customer.addChildElement( 'Identification', null, null);
                    Identification.setAttribute( 'IDType', 'ProspectID' );
                    Identification.setAttribute( 'IDValue', cs.Yardi_Guest_Card_ID__c );
                    Identification.setAttribute( 'OrganizationName', 'ResMan' );
                    
                    Dom.XmlNode Identification1           = Customer.addChildElement( 'Identification', null, null);
                    Identification1.setAttribute( 'IDType', 'PersonID' );
                    Identification1.setAttribute( 'IDValue', cs.PMS_Applicant_ID__c  );
                    Identification1.setAttribute( 'OrganizationName', 'ResMan' );
                }
                
                Dom.XmlNode Name           = Customer.addChildElement( 'Name', null, null);
                Dom.XmlNode CustomerFirstName     = Name.addChildElement( 'FirstName', null, null);
                Dom.XmlNode CustomerMiddleName     = Name.addChildElement( 'MiddleName', null, null);
                Dom.XmlNode CustomerLastName       = Name.addChildElement( 'LastName', null, null);
                Dom.XmlNode Address           = Customer.addChildElement( 'Address', null, null);
                Address.setAttribute('AddressType', 'current' );
                
                Dom.XmlNode AddressLine1         = Address.addChildElement( 'AddressLine1', null, null);
                Dom.XmlNode AddressLine2         = Address.addChildElement( 'AddressLine2', null, null);
                Dom.XmlNode City               = Address.addChildElement( 'City', null, null);
                Dom.XmlNode State             = Address.addChildElement( 'State', null, null);
                Dom.XmlNode PostalCode           = Address.addChildElement( 'PostalCode', null, null);
                Dom.XmlNode Email           = Customer.addChildElement( 'Email', null, null);
                Dom.XmlNode Phone           = Customer.addChildElement( 'Phone', null, null);
                Phone.setAttribute('PhoneType', 'cell' );
                
                Dom.XmlNode PhoneNumber       = Phone.addChildElement( 'PhoneNumber', null, null);
                Dom.XmlNode CustomerPreferences   = Prospect.addChildElement( 'CustomerPreferences', null, null );
                Dom.XmlNode DesiredFloorplan       = CustomerPreferences.addChildElement( 'DesiredFloorplan', null, null);
                Dom.XmlNode DesiredUnit         = CustomerPreferences.addChildElement( 'DesiredUnit', null, null);
                Dom.XmlNode MarketingName       = DesiredUnit.addChildElement( 'MarketingName', null, null);  
                Dom.XmlNode DesiredRent         = CustomerPreferences.addChildElement( 'DesiredRent', null, null);
                Dom.XmlNode DesiredNumBedrooms     = CustomerPreferences.addChildElement( 'DesiredNumBedrooms', null, null);
                Dom.XmlNode DesiredLeaseTerms     = CustomerPreferences.addChildElement( 'DesiredLeaseTerms', null, null);
                Dom.XmlNode Events           = Prospect.addChildElement( 'Events', null, null );
                Dom.XmlNode Event           = Events.addChildElement( 'Event', null, null );
                Dom.XmlNode EventID         = Event.addChildElement( 'EventID', null, null);
                EventID.setAttribute( 'IDValue', '0');
                
                Dom.XmlNode Agent           = Event.addChildElement( 'Agent', null, null);
                Dom.XmlNode AgentID         = Agent.addChildElement( 'AgentID', null, null );
                AgentID.setAttribute( 'IDValue', '0');
                
                Dom.XmlNode AgentName         = Agent.addChildElement( 'AgentName', null, null );
                Dom.XmlNode AgentFirstName       = AgentName.addChildElement( 'FirstName', null, null );
                Dom.XmlNode AgentLastName       = AgentName.addChildElement( 'LastName', null, null );
                Dom.XmlNode FirstContact       = Event.addChildElement( 'FirstContact', null, null);
                Dom.XmlNode TransactionSource     = Event.addChildElement( 'TransactionSource', null, null);
                
                //Adding value
                if( null != cs.Contact.FirstName ) {
                    CustomerFirstName.addTextNode( cs.Contact.FirstName );
                }
                
                if( null != cs.Contact.LastName ) {
                    CustomerLastName.addTextNode( cs.Contact.LastName );
                }
                if( null != cs.Address_Line_1__c ) {
                    AddressLine1.addTextNode( cs.Address_Line_1__c );
                }
                
                if( null != cs.Address_Line_2__c ) {
                    AddressLine2.addTextNode( cs.Address_Line_2__c );
                } 
                
                if ( null != cs.City__c ) {
                    City.addTextNode( cs.City__c );
                }
                
                if ( null != cs.State__c ) {
                    State.addTextNode( cs.State__c  ); 
                }
                
                if ( null != cs.Zip_Code__c )  {
                    PostalCode.addTextNode( cs.Zip_Code__c );
                }
                
                
                if( null != cs.Contact.MobilePhone ) {
                    PhoneNumber.addTextNode( cs.Contact.MobilePhone );
                } else if ( null != cs.Contact.Phone ) {
                    PhoneNumber.addTextNode( cs.Contact.Phone );
                }
                
                //Email 
                if( null != cs.Contact.Email ) {
                    Email.addTextNode( cs.Contact.Email );
                }
                
                //ResMan FloorPlan
                String FloorPlanID;
                Floor_Plan__c floorplan = new Floor_Plan__c();
                if( null != cs.Floor_Plan_of_Interest__r.ResMan_Floor_Plan_ID__c  ) {
                    FloorPlanID             = cs.Floor_Plan_of_Interest__r.ResMan_Floor_Plan_ID__c;
                    floorplan.ResMan_Floor_Plan_ID__c   = FloorPlanID;
                } else if( true == WaitListUnitAndFpPerProperty.containsKey( cs.Property_of_Interest__c ) ) {
                    Set<String> WaitListFloorplans    = WaitListUnitAndFpPerProperty.get( cs.Property_of_Interest__c ).keySet();
                    for( String WaitListFloorplan : WaitListFloorplans )   {
                        FloorPlanID = WaitListFloorplan;
                    }
                    floorplan.ResMan_Floor_Plan_ID__c   = FloorPlanID;
                }
                DesiredFloorplan.addTextNode( ( null != String.valueOf( floorplan.ResMan_Floor_Plan_ID__c ) ? String.valueOf( floorplan.ResMan_Floor_Plan_ID__c ) : '' ) );
                
                //ResMan Unit
                if( true == cs.Multi_Family_Case__c  ) {
                    Unit__c unit= new Unit__c();
                    if( null != cs.Unit_of_Interest__c && null != cs.Unit_of_Interest__r.ResMan_Unit_ID__c ) {
                        unit.ResMan_Unit_ID__c = cs.Unit_of_Interest__r.ResMan_Unit_ID__c;
                    } else if( null != FloorPlanID ) {
                        if( WaitListUnitAndFpPerProperty.containsKey( cs.Property_of_Interest__c ) && true == WaitListUnitAndFpPerProperty.get( cs.Property_of_Interest__c ).containsKey( FloorPlanID )  ) {
                            unit.ResMan_Unit_ID__c = WaitListUnitAndFpPerProperty.get( cs.Property_of_Interest__c ).get( FloorPlanID );
                        } else {
                            List<Unit__c> WaitlistUnit = [ SELECT ResMan_Unit_ID__c FROM Unit__c WHERE Floor_Plan__r.ResMan_Floor_Plan_ID__c = :FloorPlanID AND Is_Waitlist__c = true AND ResMan_Unit_ID__c != NULL ];
                            if( !WaitlistUnit.isEmpty() ) {
                                unit.ResMan_Unit_ID__c = WaitlistUnit.get(0).ResMan_Unit_ID__c;
                            }
                        }
                    } else if( WaitListUnitAndFpPerProperty.containsKey( cs.Property_of_Interest__c ) ) {
                        Set<String> WaitListFloorplans    = WaitListUnitAndFpPerProperty.get( cs.Property_of_Interest__c ).keySet();
                        for( String WaitListFloorplan : WaitListFloorplans )   {
                            unit.ResMan_Unit_ID__c = WaitListUnitAndFpPerProperty.get( cs.Property_of_Interest__c ).get( WaitListFloorplan );
                        }
                    }
                    MarketingName.addTextNode( ( null != unit.ResMan_Unit_ID__c ? unit.ResMan_Unit_ID__c : '' ) );
                }
                
                //DesiredRent 
                if( null != cs.Desired_Rent_Start__c && null != cs.Desired_Rent_Range_End__c ) {
                    DesiredRent.setAttribute( 'Exact', String.valueOf(cs.Desired_Rent_Range_End__c )) ; 
                } else if( null == cs.Desired_Rent_Start__c && null != cs.Desired_Rent_Range_End__c ) {
                    DesiredRent.setAttribute( 'Exact', String.valueOf( cs.Desired_Rent_Range_End__c ) );  
                } else if( null != cs.Desired_Rent_Start__c && null == cs.Desired_Rent_Range_End__c ) {
                    DesiredRent.setAttribute( 'Exact', String.valueOf(cs.Desired_Rent_Start__c ) );                                           
                } else {
                    DesiredRent.setAttribute( 'Exact', '0' ); 
                }
                
                //DesiredNumBedrooms
                if ( null != cs.Bed_Count_Pref__c ) {
                    DesiredNumBedrooms.setAttribute( 'Exact', String.valueOf( cs.Bed_Count_Pref__c ) );
                } 
                
                //DesiredLeaseTerms
                if( null !=  cs.Desired_Lease_length__c ) {
                    DesiredLeaseTerms.addTextNode( String.valueOf( cs.Desired_Lease_length__c ) );
                }
                
                //Events
                //EventDate
                if ( null != cs.Date_Time_Sent_Via_Workflow__c ) {
                    
                    DateTime sentViaWorkFlow       	= cs.Date_Time_Sent_Via_Workflow__c;
                    String sentViaWorkFlowDate       = String.valueOf( sentViaWorkFlow.format('yyyy-MM-dd') );
                    String sentViaWorkFlowTime       = String.valueOf( sentViaWorkFlow.format('HH:mm:ss') );
                    String sentViaWorkFlowDateTime  = sentViaWorkFlowDate + 'T' + sentViaWorkFlowTime;
                    Event.setAttribute( 'EventDate', String.valueOf( sentViaWorkFlowDateTime ) );
                } else {
                    String currentDate           = String.valueOf( DateTime.now().format('yyyy-MM-dd') );
                    String currentTime           = String.valueOf( DateTime.now().format('HH:mm:ss') );
                    String currentDateTime       = currentDate + 'T' + currentTime;
                    Event.setAttribute( 'EventDate', currentDateTime );
                }
                
                //EventType
                String strEventTypeAttribute = 'Email';
                if ( null != cs.Origin ) {
                    strEventTypeAttribute = cs.Origin;
                    if( 'Phone' == cs.Origin ) 
                        strEventTypeAttribute = 'Call';
                    if( 'Email' == cs.Origin )
                        strEventTypeAttribute = 'Email';
                    if( 'Voicemail ' == cs.Origin )
                        strEventTypeAttribute = 'Other';
                }
                Event.setAttribute( 'EventType', strEventTypeAttribute );
                String ExternalFirstContactID = cs.External_First_Contact_Id__c;
                if( cs.Is_First_Contact_Entered__c && null != ExternalFirstContactID &&  !ExternalFirstContactID.contains( 'Error' ) ) {
                    EventID.setAttribute( 'IDValue', cs.External_First_Contact_Id__c );
                    EventID.setAttribute( 'OrganizationName', 'ResMan' );
                }
                
                //AgentID
                if( null != cs.Property_of_Interest__r.ResMan_Agent_Id__c ) {
                    AgentID.setAttribute( 'IDValue', cs.Property_of_Interest__r.ResMan_Agent_Id__c );
                }
                
                //AgentFirstName
                AgentFirstName.addTextNode( 'Anyone' );
                
                //AgentLastName
                AgentLastName.addTextNode( 'Home' );
                
                //FirstContact 
                FirstContact.addTextNode( 'true' );
                
                //TransactionResource
                if( TransactionResourcesPerProperty.containsKey( cs.Property_of_Interest__r.ResMan_Property_Id__c ) ) {
                    String SourceType = cs.Ad_Source_Type__c;
                    if( null != cs.Ad_Source_Type__c && true == TransactionResourcesPerProperty.get( cs.Property_of_Interest__r.ResMan_Property_Id__c ).containsKey( SourceType.toLowerCase() ) ) {
                        TransactionSource.addTextNode( TransactionResourcesPerProperty.get( cs.Property_of_Interest__r.ResMan_Property_Id__c ).get( SourceType.toLowerCase() ) );
                    } else {
                        Set<String> DefaultList = TransactionResourcesPerProperty.get( cs.Property_of_Interest__r.ResMan_Property_Id__c ).keySet();
                        //Assigning 0th element
                        for( String s:DefaultList ) {
                            TransactionSource.addTextNode( TransactionResourcesPerProperty.get( cs.Property_of_Interest__r.ResMan_Property_Id__c ).get( s ) ); 
                            break;
                        }
                    }
                }
                
                List<Appointment__c>Appointment = new List<Appointment__c>();
                Appointment = [ SELECT Id, Comments__c, Name, CreatedDate, Appointment_Date__c, NoFrom__c, ResMan_Event_ID__c, Invite_Status__c FROM Appointment__c WHERE Case__c = :cs.Id AND Is_Event_Synced__c = false];    
                
                if( false == Appointment.isEmpty() ) {
                    if( true == cs.Is_First_Contact_Entered__c ) {
                        Events.removeChild( Event );
                    }
                    for( Appointment__c app : Appointment ) {
                        
                        Dom.XmlNode Event1 = Events.addChildElement( 'Event', null, null );
                        
                        Event1.setAttribute( 'EventType',  'Appointment' );
                        
                        Event1.setAttribute( 'EventDate', String.valueOf( ( null != app.Appointment_Date__c ? app.Appointment_Date__c : date.today() ) ) + 'T' + hours.get( String.valueOf( app.NoFrom__c ) ) );
                        
                        Dom.XmlNode Agent1     = Event1.addChildElement( 'Agent', null, null );
                        Dom.XmlNode AgentID1   = Agent1.addChildElement( 'AgentID', null, null );
                        if( null != cs.Property_of_Interest__r.ResMan_Agent_Id__c ) {
                            AgentID1.setAttribute( 'IDValue', cs.Property_of_Interest__r.ResMan_Agent_Id__c );
                        }
                        
                        if( null != app.ResMan_Event_ID__c ) {
                            Dom.XmlNode EventID1 = Event1.addChildElement( 'EventID', null, null );
                            EventID1.setAttribute( 'IDType', 'EventID' );
                            EventID1.setAttribute( 'IDValue', app.ResMan_Event_ID__c );
                            EventID1.setAttribute( ' OrganizationName', 'ResMan' );
                        } else {
                            Dom.XmlNode AgentName1   = Agent1.addChildElement( 'AgentName', null, null );
                            Dom.XmlNode FirstName1   = AgentName1.addChildElement( 'FirstName', null, null );
                            Dom.XmlNode LastName1   = AgentName1.addChildElement( 'LastName', null, null );
                            
                            if( null != cs.Contact.FirstName ) {
                                FirstName1.addTextNode( cs.Contact.FirstName );
                            }
                            
                            if( null != cs.Contact.LastName ) {
                                LastName1.addTextNode( cs.Contact.LastName );
                            }
                        }
                        
                        //FirstContact
                        Dom.XmlNode FirstContact1       = Event1.addChildElement( 'FirstContact', null, null);
                        
                        if( true == cs.Is_First_Contact_Entered__c && false == IsFirstContactTrue ) {
                            IsFirstContactTrue = true;
                            FirstContact1.addTextNode( 'true' );
                        } else {
                            FirstContact1.addTextNode( 'false' );
                        }
                        
                        //Comments
                        Dom.XmlNode Comments1     = Event1.addChildElement( 'Comments', null, null );
                        if( null != app.Comments__c ) {
                            Comments1.addTextNode( app.Comments__c );
                        }
                        
                        //TransactionSource
                        Dom.XmlNode TransactionSource1     = Event1.addChildElement( 'TransactionSource', null, null );
                        
                        if( 'Canceled' ==  app.Invite_Status__c || 'Rejected' == app.Invite_Status__c ) {
                            Event1.setAttribute( 'EventType',  'Cancel' ); 
                            if( LostProspectsPerAccount.containsKey( cs.AccountId ) ) {
                                Set<String> DefaultList_LP = LostProspectsPerAccount.get( cs.AccountId ).keySet();
                                
                                for( String s:DefaultList_LP ) {
                                    TransactionSource1.addTextNode( LostProspectsPerAccount.get( cs.AccountId ).get( s ) ); 
                                    break;
                                }
                            }
                        } else {
                            if( true == TransactionResourcesPerProperty.containsKey( cs.Property_of_Interest__r.ResMan_Property_Id__c ) ) {
                                String SourceType = cs.Ad_Source_Type__c;
                                if( null != SourceType && true == TransactionResourcesPerProperty.get( cs.Property_of_Interest__r.ResMan_Property_Id__c ).containsKey( SourceType.toLowerCase() ) ) {
                                    TransactionSource1.addTextNode( TransactionResourcesPerProperty.get( cs.Property_of_Interest__r.ResMan_Property_Id__c ).get( SourceType.toLowerCase() ) );
                                } else {
                                    Set<String> DefaultList = TransactionResourcesPerProperty.get( cs.Property_of_Interest__r.ResMan_Property_Id__c ).keySet();
                                    for( String s:DefaultList ) {
                                        TransactionSource1.addTextNode( TransactionResourcesPerProperty.get( cs.Property_of_Interest__r.ResMan_Property_Id__c ).get( s ) ); 
                                        break;
                                    }
                                }
                            }
                        }
                        AppointmentPerCase.add(app);
                    }
                }
                
                String xmlstr = doc.toXmlString();
                xmlstr = xmlstr.replace('<?xml version="1.0" encoding="UTF-8"?>', '');
                xmlstr = xmlstr.replace('<Comments />', '<Comments></Comments>');
                xmlstr = xmlstr.replace('<DesiredLeaseTerms />', '<DesiredLeaseTerms></DesiredLeaseTerms>');
                xmlstr = xmlstr.replace('<PhoneNumber/>', '<PhoneNumber></PhoneNumber>');
                xmlstr = xmlstr.replace('<DesiredRent/>', '');
                xmlstr = xmlstr.replace('<MITS:Email/>', '<MITS:Email></MITS:Email>');
                xmlstr = xmlstr.replaceAll('/(^[\r\n]*|[\r\n]+)[\\s\t]*[\r\n]/', '\n' );
                
                System.debug('xmlstr - ' + xmlstr);
                
                String requestBody  = 'IntegrationPartnerID=' + IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'ResManIntegrationPartner' );
                requestBody         = requestBody + '&ApiKey=' + IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'ResManAPIKey' );
                requestBody         = requestBody + '&AccountID=' + IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'ResManAccountId' );
                requestBody         = requestBody + '&PropertyID=' + cs.Property_of_Interest__r.ResMan_Property_Id__c;
                requestBody         = requestBody + '&xml=' + xmlstr;
                
                Http httpPro = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndPoint( IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'ResManAPIUrl' ) + 'MITS/PostLeadManagement4_0' );
                request.setBody( requestBody );
                request.setMethod( 'POST' );
                request.setHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
                request.setHeader( 'Accept', 'application/xml' );
                request.setTimeout( 120000 );
                
                if (!Test.isRunningTest()) {
                    HTTPResponse res = httpPro.send(request);
                    GCResponse = res.getBody();       
                } else {
                    GCResponse = '<ResMan> <Status>Success</Status> <Response> <LeadManagement> <Prospects> <Prospect> <Customers> <Customer Type="prospect"> <Identification IDType="ProspectID" IDValue="4f937793-baf9-4a72-bcc3-3fd06653cecd" OrganizationName="ResMan" /> <Identification IDType="PersonID" IDValue="fb9c14a8-1e37-4df9-95e2-aa71f78531de" OrganizationName="ResMan" /> <Identification IDType="LeaseID" IDValue="4f31f057-4a3d-4b41-8afa-d73b270199ab" OrganizationName="ResMan" /> <Name> <FirstName>Robert</FirstName> <LastName>Parr</LastName> </Name> <Address AddressType="current"> <AddressLine1>123 Ewe Turn</AddressLine1> <City>Dallas</City> <State>TX</State> <PostalCode>77510</PostalCode> <Country>USA</Country> </Address> <Phone> <PhoneNumber>(716) 763-5624</PhoneNumber> </Phone> <Email>robert@email.com</Email> </Customer> <Customer Type="prospect"> <Identification IDType="ProspectID" IDValue="20d3c1d4-e3bd-47a5-9309-e884e98c96d6" OrganizationName="ResMan" /> <Identification IDType="PersonID" IDValue="39029787-bf89-40e8-ac9f-000e22fd3974" OrganizationName="ResMan" /> <Identification IDType="LeaseID" IDValue="4f31f057-4a3d-4b41-8afa-d73b270199ab" OrganizationName="ResMan" /> <Name> <FirstName>Lisa</FirstName> <LastName>Parr</LastName> </Name> <Address AddressType="current"> <AddressLine1>123 Ewe Turn</AddressLine1> <City>Dallas</City> <State>TX</State> <PostalCode>77510</PostalCode> <Country>USA</Country> </Address> </Customer> </Customers> <CustomerPreferences> <TargetMoveInDate>2013-12-05</TargetMoveInDate> <DesiredUnit> <MarketingName>100</MarketingName> </DesiredUnit> <DesiredRent Min="1000" Max="1111" /> <DesiredNumBedrooms Min="1" Max="2" /> <DesiredNumBathrooms Min="2" Max="2" /> <FloorLevelDesired>1</FloorLevelDesired> </CustomerPreferences> <Events> <Event EventDate="2015-02-25T15:02:21-07:00" EventType="Email"> <EventID IDType="EventID" IDValue="817922d5-d3f4-4ec1-a45e-2268b2c008e1" OrganizationName="ResMan" /> <Agent> <AgentID IDValue="a7862f1c-2967-4680-ae2e-51fe9ce78247" /> <Name> <FirstName>John</FirstName> <LastName>Manager</LastName> </Name> </Agent> <EventReasons>Initial contact</EventReasons> <FirstContact>true</FirstContact> <TransactionSource>579d1389-a0e4-4910-9424-200d7d6e8533</TransactionSource> </Event> <Event EventDate="2015-02-25T14:59:50-07:00" EventType="Appointment"> <EventID IDType="EventID" IDValue="er899-34534t" OrganizationName="ResMan" /> <Agent> <AgentID IDValue="a7862f1c-2967-4680-ae2e-51fe9ce78247" /> <Name> <FirstName>John</FirstName> <LastName>Manager</LastName> </Name> </Agent> <EventReasons>Initial contact</EventReasons> <FirstContact>false</FirstContact> <TransactionSource>temp</TransactionSource> </Event> </Events> </Prospect> </Prospects></LeadManagement> </Response> </ResMan>';
                }
                
                System.debug('GCResponse - ' + GCResponse );
                parseGuestCardResponse( GCResponse, cs.CaseNumber );
                
                cs.Is_First_Contact_Entered__c = false;
                cs.GC_Entered__c = false;
                cs.Integration_Failed__c = true;
                cs.integration_fail_success_message__c = 'No response from server. Unable to update in SFDC record.';
                if( arrCases.containsKey( 'ErrorDescription' ) ) {
                    if( arrCases.get( 'ErrorDescription' ).length() > 255 ){
                        cs.integration_fail_success_message__c = (arrCases.get( 'ErrorDescription' )).substring(0,254);
                    } else {
                        cs.integration_fail_success_message__c = arrCases.get( 'ErrorDescription' );
                    }
                }
                
                if( 'Success' == arrCases.get( 'Status' ) && null != arrCases.get( 'ProspectID' ) && null != arrCases.get( 'PersonID' ) ) {
                    cs.GC_Entered__c = true;
                    cs.Integration_Failed__c = false;
                    cs.Is_First_Contact_Entered__c = true;
                    cs.Yardi_Guest_Card_ID__c = arrCases.get( 'ProspectID' );
                    cs.PMS_Applicant_ID__c = arrCases.get( 'PersonID' );
                    cs.integration_fail_success_message__c = 'GC Inserted Sucessfully with ResMan Prospect Id: ' + arrCases.get( 'ProspectID' );
                    
                    for( Map<String, String> updatedEvent: updatedEvents ){
                        if( cs.CaseNumber == updatedEvent.get('CaseNumber') ) {
                            if( ( 'Email' == updatedEvent.get('EventType') || 'Call' == updatedEvent.get('EventType') || 'Other' == updatedEvent.get('EventType') ) ) {
                                cs.External_First_Contact_Id__c = updatedEvent.get( 'EventId' );
                            } else if( 'Appointment' != updatedEvent.get('EventType') ) {
                                cs.External_First_Contact_Id__c = updatedEvent.get( 'EventId' );
                            } else {
                                cs.External_First_Contact_Id__c = 'Error occured. Either invalid Event is received.';
                            }
                        }
                    }
                    
                    if( !AppointmentPerCase.isEmpty() ) {
                        for( Appointment__c app :AppointmentPerCase ) {
                            for( Map<String, String> updatedEvent: updatedEvents ){
                                if( String.valueOf( app.Appointment_Date__c ) + 'T' + hours.get( String.valueOf( app.NoFrom__c ) ) == updatedEvent.get('EventDate') && 'Appointment' == updatedEvent.get('EventType') && cs.CaseNumber == updatedEvent.get('CaseNumber') ) {
                                    
                                    Appointment__c NeedtoUpdateAppPerCase = new Appointment__c();
                                    NeedtoUpdateAppPerCase.Id           = app.Id;
                                    NeedtoUpdateAppPerCase.ResMan_Event_ID__c   = updatedEvent.get( 'EventId' );
                                    NeedtoUpdateAppPerCase.Is_Event_Synced__c   = true;
                                    NeedToUpdateAppointments.add( NeedtoUpdateAppPerCase );
                                }
                            }
                        }
                    }
                }
                updatedCases.add(cs);
            } catch ( Exception e ) {
                Case CaseWithError = new Case();
                CaseWithError.Id = cs.Id;
                String strMessage = 'SFDC: ' + e.getMessage() + ' ' + e.getStackTraceString();
                CaseWithError.integration_fail_success_message__c = ( strMessage.length() > 255 ) ? strMessage.substring(0,254) : strMessage;
                CaseWithError.Integration_Failed__c = true;
                
                System.debug( CaseWithError.integration_fail_success_message__c );
                System.debug( CaseWithError.Integration_Failed__c );
                updatedCases.add( CaseWithError );
            }
            
        }
        
        if( !NeedToUpdateAppointments.isEmpty() ) {
            update NeedToUpdateAppointments;
        }
        
        return updatedCases;
    }
    
    public void GetProspectSources( Map<String, String>strCredentials, String PropertyId ) {
        
        String requestBody       = 'IntegrationPartnerID=' + strCredentials.get( 'ResManIntegrationPartner' );
        requestBody         = requestBody + '&ApiKey=' + strCredentials.get( 'ResManAPIKey' );
        requestBody         = requestBody + '&AccountID=' + strCredentials.get( 'ResManAccountId' );
        requestBody         = requestBody + '&PropertyID=' + PropertyId;
        
        Http httpPro = new Http();
        
        HttpRequest request = new HttpRequest();
        request.setEndPoint( strCredentials.get( 'ResManAPIUrl' ) + 'Leasing/GetProspectSources' );
        request.setBody( requestBody );
        request.setMethod( 'POST' );
        request.setHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
        request.setTimeout( 120000 );
        
        if (!Test.isRunningTest()) {
            HTTPResponse res = httpPro.send(request);
            resultProspectSource = res.getBody();       
        } else {
            resultProspectSource = '{"ProspectSources":[{"Name":"Apartment Finder Magazine","ID":"15b23c6c-226d-4a65-802a-d2d9fa6d9f4c"},{"Name":"Apartment Guide - Plano","ID":"471ba812-ee78-4091-b96f-ada5e3eb1fe3"},{"Name":"Apartment Guide Frisco","ID":"8b0907e0-caa1-41dc-b726-d65dbb78f116"},{"Name":"Apartment Home Living","ID":"4a548d5d-e53b-45f4-8b72-255e6ff94807"},{"Name":"ApartmentFinder.com","ID":"161c86d9-d2a7-4b51-aa94-809a19ce2ea6"},{"Name":"ApartmentGuide.com","ID":"dd4d8c75-fc41-4906-b648-a751f7d9da8a"},{"Name":"Apartments.com","ID":"e696e99e-a4bb-4cbd-a8cd-55b094ca4111"},{"Name":"Billboard Advertisement","ID":"46373789-6c1a-415b-b04f-05c466e2a0ed"},{"Name":"Brochure/Flyer","ID":"9e540a55-f668-4e26-a373-6a8b53c4dfc6"},{"Name":"Company Transfer","ID":"c41c3b38-7143-4899-9290-372f7deb36a4"},{"Name":"Craigs List","ID":"f447023d-3b3e-4c8e-9b79-7cc051dfc40c"},{"Name":"Drive By","ID":"e3906ffe-370b-4f59-a47f-b2ab2dd8be80"},{"Name":"Flyer By Property","ID":"e284d455-e2d6-4eb0-b091-4ea6b32e7ee2"},{"Name":"For Rent","ID":"1ab1d0ce-7592-409c-83c1-c878fab476f9"},{"Name":"For Rent Magazine","ID":"eead8b7a-be49-4364-8c0f-e6fc5514f8d5"},{"Name":"ForRent.com","ID":"9726b1ce-3302-4937-a14c-1622ba4300ba"},{"Name":"Google Places","ID":"f6a4eef4-c490-44b1-a8be-a68d1f2ddd6e"},{"Name":"Internet","ID":"ba22feef-095a-4d0f-9145-71e54e33a8c5"},{"Name":"Jonah","ID":"ee9d7685-548d-4a80-a7c1-a9726097c4b3"},{"Name":"Local Merchant","ID":"942c7b83-5345-4cf2-9334-64ff3786c0bd"},{"Name":"Locator","ID":"389d0ed9-0e0b-4262-81c8-fa6e9c8afa6f"},{"Name":"My New Place","ID":"3002861c-cd17-4fd2-b81e-240cb0f06631"},{"Name":"Newspaper","ID":"b5f721cc-4e7f-4533-9853-71103b40aad8"},{"Name":"Other","ID":"6e48b445-cec9-4a53-ae0a-db32064b57f6"},{"Name":"Outside Marketing","ID":"645c0c57-86f5-4cea-b98e-b99245459694"},{"Name":"Personal Marketing","ID":"3a633343-cb31-49b9-8aeb-26f0ee4abc60"},{"Name":"Preferred Employee Program","ID":"3b39a04f-6688-47d7-8091-b679ec8871b0"},{"Name":"Property Referral","ID":"1a3acfb8-cf8d-4941-866f-1558a913b5bb"},{"Name":"Property Website","ID":"365d0881-5a5e-4a81-83e9-6b4ead3b438d"},{"Name":"Rent.com","ID":"033a002e-6c92-461a-8780-5fe897b298e7"},{"Name":"Resident Referral","ID":"7dc146d6-20e3-4b24-8027-379509fa563a"},{"Name":"Second or Follow-Up Visit","ID":"af93a745-744d-4860-86b8-efef8ad2df3c"},{"Name":"Social Media Site","ID":"ded1616d-6f83-4379-a21d-7be5f09c2df4"},{"Name":"Telephone Arrival","ID":"a4d4f106-11de-48ad-8978-296080543c41"},{"Name":"The Apartment Guide","ID":"dc8c2ff1-f436-4b73-bf86-990fde41761a"},{"Name":"Word of Mouth","ID":"af338722-8248-4109-bf09-7e2a8415aa69"},{"Name":"Yellow Pages","ID":"1cb48f4a-5034-48e8-8cc0-d125432f3b90"}],"MethodName":"GetProspectSources","Status":"Success","AccountID":400,"PropertyID":"b342e58c-f5ba-4c63-b050-cf44439bb37"}';
        }
        
        parseProspectSources( PropertyId, resultProspectSource );
        
    }
    
    void parseProspectSources( String PropertyId, String resultProspectSource ) {
        
        Map<String, String> TransactionResources          = new Map<String, String>();
        if( null != resultProspectSource ) {
            Map<String, Object> jsonObjectProspectSourcess     = ( Map<String, Object> ) JSON.deserializeUntyped( resultProspectSource );
            List<Object>jsonObjectProspectSourcessDetails        = ( List<Object> )jsonObjectProspectSourcess.get( 'ProspectSources' );
            String ResManStatus                  = ( String ) jsonObjectProspectSourcess.get( 'Status' );
            
            if( 'Success' == ResManStatus ) {
                
                for( Object ProspectSources_temp : jsonObjectProspectSourcessDetails ) {
                    
                    Map<String, Object > ProspectSources = ( Map<String, Object >  ) ProspectSources_temp;
                    String NameOfSource = (String)ProspectSources.get( 'Name' );
                    TransactionResources.put( NameOfSource.toLowerCase() , (String)ProspectSources.get( 'ID' ) );
                }
                TransactionResourcesPerProperty.put( PropertyId , TransactionResources );
            }
        }
    }
    
    public void GetLostProspectReasons( String AccountId, Map<String, String> strCredentials ) {
        
        String requestBody       = 'IntegrationPartnerID=' + strCredentials.get( 'ResManIntegrationPartner' );
        requestBody         = requestBody + '&ApiKey=' + strCredentials.get( 'ResManAPIKey' );
        requestBody         = requestBody + '&AccountID=' + strCredentials.get( 'ResManAccountId' );
        
        Http httpPro = new Http();
        
        HttpRequest request = new HttpRequest();
        request.setEndPoint( strCredentials.get( 'ResManAPIUrl' ) + 'Leasing/GetLostProspectReasons' );
        request.setBody( requestBody );
        request.setMethod( 'POST' );
        request.setHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
        request.setTimeout( 120000 );
        
        if (!Test.isRunningTest()) {
            HTTPResponse res = httpPro.send(request);
            resultLostReason = res.getBody();       
        } else {
            resultLostReason = '{"LostProspectReasons":[{"Name":"Aggressive breed","ID":"ec1c3dc1-c1b1-45d6-9745-e92fead6b2e2"},{"Name":"Criminal background","ID":"453512e5-0b0a-47b4-80ca-defadde4949e"},{"Name":"Floor Plan not available","ID":"418836fa-ea2d-487c-9a9c-f4a20ed3eb94"},{"Name":"Leased at competitor","ID":"5719787c-67a5-43f9-96bd-500afb1eb603"},{"Name":"No longer moving","ID":"f0375b91-4dfa-4098-8f1a-2d5302ecd2c6"},{"Name":"Occupancy Limits","ID":"721df02b-d324-4afb-be1d-bb76d5e1cc1e"},{"Name":"Out of Price Range","ID":"f7e38e25-2069-427d-ab59-c1d0dd2785e7"},{"Name":"Relocated out of area","ID":"5850db94-8371-4bdf-8b8e-fcd36b681582"},{"Name":"Rented House","ID":"8deffc16-b002-4906-bca7-9f7dfc1522e1"},{"Name":"Section 8","ID":"9b714cb4-6f4b-4b5b-b3cf-aa60391ae4e1"}],"MethodName":"GetLostProspectReasons","Status":"Success","AccountID":400}';
        }
        
        parseLostProspectResponse( AccountId, resultLostReason );
    }
    
    void parseLostProspectResponse( String AccountId, String resultLostReason ) {
        
        if( null != resultLostReason ) {
            Map<String, Object> jsonObjectLostProspects         = ( Map<String, Object> ) JSON.deserializeUntyped( resultLostReason );
            List<Object>jsonObjectLostProspectsDetails          = ( List<Object> )jsonObjectLostProspects.get( 'LostProspectReasons' );
            String ResManStatus                    = ( String ) jsonObjectLostProspects.get( 'Status' );
            
            if( 'Success' == ResManStatus ) {
                
                for( Object LostProspect_temp : jsonObjectLostProspectsDetails ) {
                    
                    Map<String, Object > LostProspect = ( Map<String, Object >  ) LostProspect_temp;
                    LostProspects.put( (String)LostProspect.get( 'Name' ) , (String)LostProspect.get( 'ID' ) );
                }
                LostProspectsPerAccount.put( AccountId , LostProspects );
            }
        }
    }
    
    public void parseGuestCardResponse( String strGuestCardResponse, String CaseNumber ) {
        
        if( null != strGuestCardResponse ) {
            arrCases.clear();
            
            Dom.Document doc = new Dom.Document();
            doc.load( strGuestCardResponse );
            Dom.XMLNode EnvelopeRootNode = doc.getRootElement();
            
            for( Dom.XMLNode child2 : EnvelopeRootNode.getChildElements() ) {
                
                if( 'Status' == child2.getName() ) {
                    arrCases.put( 'Status' , child2.getText() );
                }
                if( 'ErrorDescription' == child2.getName() ) {
                    arrCases.put( 'ErrorDescription' , child2.getText() );
                }
                
                if( 'Response' == child2.getName() ) {
                    for( Dom.XMLNode child2_1 : child2.getChildElements() ) {
                        
                        if( 'LeadManagement' == child2_1.getName() ) {
                            for( Dom.XMLNode child2_2 : child2_1.getChildElements() ) {
                                
                                if( 'Prospects' == child2_2.getName() ) {
                                    for( Dom.XMLNode child3 : child2_2.getChildElements() ) {
                                        
                                        if( 'Prospect' == child3.getName() ) {
                                            for( Dom.XMLNode child4 : child3.getChildElements() ) {
                                                
                                                if( 'Customers' == child4.getName() ) {
                                                    for( Dom.XMLNode child5 : child4.getChildElements() ) {
                                                        
                                                        if( 'Customer' == child5.getName() ) {
                                                            for( Dom.XMLNode child7 : child5.getChildElements() ) {
                                                                
                                                                if( 'Identification' == child7.getName() ) {
                                                                    if( 'ProspectID' == child7.getAttributeValue('IDType', '') ) {
                                                                        arrCases.put( 'ProspectID' , child7.getAttributeValue('IDValue', '') );
                                                                    }
                                                                    if( 'PersonID' == child7.getAttributeValue('IDType', '') ) {
                                                                        arrCases.put( 'PersonID' , child7.getAttributeValue('IDValue', '') );
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                Set<String> IsEventAdded = new Set<String>();
                                                if( 'Events' == child4.getName() ) {
                                                    for( Dom.XMLNode child4_1 : child4.getChildElements() ) {
                                                        Map<String, String>updatedEvent = new Map<String, String>();
                                                        
                                                        if( 'Event' == child4_1.getName() ) {
                                                            updatedEvent.put( 'CaseNumber' , CaseNumber );
                                                            updatedEvent.put( 'EventDate', child4_1.getAttributeValue('EventDate', '') );
                                                            updatedEvent.put( 'EventType', child4_1.getAttributeValue('EventType', '') );
                                                            for( Dom.XMLNode child4_2 : child4_1.getChildElements() ) {
                                                                if( 'EventID' == child4_2.getName() ) {
                                                                    if( !IsEventAdded.contains(child4_2.getAttributeValue('IDValue', '')) ) {
                                                                        updatedEvent.put( 'EventId', child4_2.getAttributeValue('IDValue', '') );
                                                                    } else {
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        updatedEvents.add( updatedEvent );
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}