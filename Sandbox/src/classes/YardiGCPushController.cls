public with sharing class YardiGCPushController {

    public YardiGCPushWsdltoApexController.ItfILSGuestCardSoap yvn; 
    public YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn20;

    final String strInterfaceEntity;
    final String strInterfaceLicense;
    public String strPropertiesXml;
    public String responseXml;
    public String strYardiAgentsSourcesResults;

    public Integer count 					= 0;
    public boolean isShowProUser            = false;

    public LIST<Appointment__c> NeedToUpdateApp	= new List<Appointment__c>();
    public LIST<Case> NeedToUpdateCases     	= new List<Case>();
    public List<Case> Cases	 					= new List<Case>();
    public Set<String> PropertyCodes     		= new Set<String>();
    
    public Map<String, String> hours                    						= new Map<String, String>();
    public Map<String, String> search_results           						= new Map<String, String>();
    public Map<String, List<String>> ResultsPerProperty 						= new Map<String, List<String>>();
    public Map<String, List<String>> SourcesPerProperty 						= new Map<String, List<String>>();
    public Map<String, List<String>> AgentsPerProperty 							= new Map<String, List<String>>();
    public Map<String, Map<String, String>> IntegrationsCredentialsPerAccount  	= new Map<String, Map<String, String>>();
    public Map<String, String> IntegrationsCredentials					    	= new Map<String, String>();
    
    public YardiGCPushController() { 

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

        Set<String> CustPropIds 										= new Set<String>();
        Map<String, String> PropertiesPerAccount 						= new Map<String, String>();
        Map<String, Map<String, String>> WaitListUnitPerFpPerProperty 	= new Map<String, Map<String, String>>();
        
        if( !Cases.isEmpty() ) {
            for( Case cs : Cases ) { 
                if( ! CustPropIds.contains( cs.Cust_Prop_id__c ) ) {
                    if( null != cs.Property_of_Interest__r.Group_Membership__c  ) {
                        PropertiesPerAccount.put( cs.Cust_Prop_id__c, cs.Property_of_Interest__r.Group_Membership__c  );
                    } else {
                        PropertiesPerAccount.put( cs.Cust_Prop_id__c, cs.AccountId );
                    }
                    CustPropIds.add( cs.Cust_Prop_id__c );
                }
            }
        }

        for( String CustPropId : CustPropIds ) {
            if( PropertiesPerAccount.containsKey( CustPropId ) && IntegrationsCredentialsPerAccount.containsKey( PropertiesPerAccount.get( CustPropId ) ) ) {
                this.GetYardiAgentsSourcesResults_Login( IntegrationsCredentialsPerAccount.get( PropertiesPerAccount.get( CustPropId ) ), CustPropId );  
            }
        }
        
        List<Unit__c> Waitlist = new List<Unit__c>();
        if( !Test.isRunningTest() ) {
            Waitlist = [SELECT Id, Floor_Plan__r.Floorplan_ID__c, Unit_ID__c, Property__c, Property__r.Customer_Prop_ID__c FROM Unit__c WHERE Floor_Plan__r.Is_Waitlist__c = true AND Is_Waitlist__c = true AND Floor_Plan__r.Floorplan_ID__c != NULL AND Unit_ID__c != NULL AND Property__r.Customer_Prop_ID__c IN : CustPropIds ];
        } else {
            Waitlist = [SELECT Id, Floor_Plan__r.Floorplan_ID__c, Unit_ID__c, Property__c, Property__r.Customer_Prop_ID__c FROM Unit__c ];
        }
        
        if( !Waitlist.isEmpty() ) {
            for( Unit__c unit:Waitlist ) {
                if( !WaitListUnitPerFpPerProperty.containsKey( unit.Property__r.Customer_Prop_ID__c ) ) {
                    Map<String,String> WaitListUnitPerFp = new Map<String, String>();
                    WaitListUnitPerFp.put( unit.Floor_Plan__r.Floorplan_ID__c , unit.Unit_ID__c );
                    WaitListUnitPerFpPerProperty.put( unit.Property__r.Customer_Prop_ID__c , WaitListUnitPerFp );
                }
            }
        }

        if( !Cases.isEmpty() ) {
            for( Case cs : Cases ) {
                System.debug( cs.CaseNumber );
                if( null != cs.Property_of_Interest__r.Group_Membership__c ) {
                    if( IntegrationsCredentialsPerAccount.containsKey( cs.Property_of_Interest__r.Group_Membership__c )  )
                        IntegrationsCredentials = IntegrationsCredentialsPerAccount.get( cs.Property_of_Interest__r.Group_Membership__c );
                } else {
                    if( IntegrationsCredentialsPerAccount.containsKey( cs.AccountId ) ) 
                        IntegrationsCredentials = IntegrationsCredentialsPerAccount.get( cs.AccountId );
                }

                try {

                    System.debug('IntegrationsCredentials - ' + IntegrationsCredentials);
                    List<Appointment__c> AppointmentPerCase	= new List<Appointment__c>();
                    if( !IntegrationsCredentials.isEmpty() ) {
                        if( '4' == IntegrationsCredentials.get( 'YardiVersionNumber' ) )  {
                            
                            yvn = new YardiGCPushWsdltoApexController.ItfILSGuestCardSoap();
                            yvn.endpoint_x = IntegrationsCredentials.get( 'YardiAPIUrl' );
                            yvn.timeout_x = 120000; 
                            
                            Dom.Document doc         			= new Dom.Document();
                            Dom.XmlNode LeadManagementNode   	= doc.createRootElement( 'LeadManagement', null, null );
                            LeadManagementNode.setNamespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
                            
                            Dom.XmlNode Prospects       		= LeadManagementNode.addChildElement( 'Prospects', null, null );
                            Dom.XmlNode Prospect         		= Prospects.addChildElement( 'Prospect', null, null );
                            Dom.XmlNode Customers       		= Prospect.addChildElement( 'Customers', null, null );
                            Dom.XmlNode Customer         		= Customers.addChildElement( 'Customer', null, null );
                            Customer.setAttribute( 'Type', 'prospect' );
                            
                            Dom.XmlNode Identification0   		= Customer.addChildElement( 'Identification', null, null);
                            Identification0.setAttribute( 'IDValue', cs.CaseNumber );
                            Identification0.setAttribute( 'IDType', 'ThirdPartyID' );
                            Identification0.setAttribute( 'OrganizationName', 'AnyoneHome' );
                            
                            if( null != cs.Cust_Prop_id__c ) {
                                Dom.XmlNode Identification1   		= Customer.addChildElement( 'Identification', null, null);
                                Identification1.setAttribute( 'IDValue', cs.Cust_Prop_id__c );
                                Identification1.setAttribute( 'IDType', 'PropertyID' );
                                Identification1.setAttribute( 'OrganizationName', 'Yardi' );
                            }
                            
                            if( null != cs.Yardi_Guest_Card_ID__c ) {
                                Dom.XmlNode Identification2   		= Customer.addChildElement( 'Identification', null, null);
                                Identification2.setAttribute( 'IDValue', cs.Yardi_Guest_Card_ID__c );
                                Identification2.setAttribute( 'IDType', 'ProspectID' );
                                Identification2.setAttribute( 'OrganizationName', 'Yardi' );
                            }
                            
                            Dom.XmlNode Name         			= Customer.addChildElement( 'Name', null, null);
                            Dom.XmlNode CustomerFirstName   	= Name.addChildElement( 'FirstName', null, null);
                            Dom.XmlNode CustomerLastName     	= Name.addChildElement( 'LastName', null, null);
                            
                            Dom.XmlNode Address       			= Customer.addChildElement( 'Address', null, null);
                            Address.setAttribute('AddressType', 'current' );
                            Dom.XmlNode AddressLine1       		= Address.addChildElement( 'AddressLine1', null, null);
                            Dom.XmlNode AddressLine2       		= Address.addChildElement( 'AddressLine2', null, null);
                            Dom.XmlNode City             		= Address.addChildElement( 'City', null, null);
                            Dom.XmlNode State           		= Address.addChildElement( 'State', null, null);
                            Dom.XmlNode PostalCode         		= Address.addChildElement( 'PostalCode', null, null);
                            
                            Dom.XmlNode Phone0         			= Customer.addChildElement( 'Phone', null, null);
                            Phone0.setAttribute('PhoneType', 'home' );
                            Dom.XmlNode PhoneNumber0     		= Phone0.addChildElement( 'PhoneNumber', null, null);
                            
                            Dom.XmlNode Phone1         			= Customer.addChildElement( 'Phone', null, null);
                            Phone1.setAttribute('PhoneType', 'cell' );
                            Dom.XmlNode PhoneNumber1     		= Phone1.addChildElement( 'PhoneNumber', null, null);
                            
                            Dom.XmlNode Email         			= Customer.addChildElement( 'Email', null, null);
                            Dom.XmlNode Lease         			= Customer.addChildElement( 'Lease', null, null);
                            Dom.XmlNode ExpectedMoveInDate   	= Lease.addChildElement( 'ExpectedMoveInDate', null, null );
                            
                            Dom.XmlNode CustomerPreferences 	= Prospect.addChildElement( 'CustomerPreferences', null, null );
                            
                            Dom.XmlNode TargetMoveInDate     	= CustomerPreferences.addChildElement( 'TargetMoveInDate', null, null);
                            Dom.XmlNode DesiredUnit       		= CustomerPreferences.addChildElement( 'DesiredUnit', null, null);
                            Dom.XmlNode MarketingName     		= DesiredUnit.addChildElement( 'MarketingName', null, null);  
                            
                            Dom.XmlNode DesiredRent       		= CustomerPreferences.addChildElement( 'DesiredRent', null, null);
                            Dom.XmlNode DesiredNumBedrooms  	= CustomerPreferences.addChildElement( 'DesiredNumBedrooms', null, null);
                            
                            Dom.XmlNode DesiredLeaseTerms   	= CustomerPreferences.addChildElement( 'DesiredLeaseTerms', null, null);
                            Dom.XmlNode Comment       			= CustomerPreferences.addChildElement( 'Comment', null, null);
                            
                            Dom.XmlNode Events         			= Prospect.addChildElement( 'Events', null, null );
                            Dom.XmlNode Event         			= Events.addChildElement( 'Event', null, null );
                            Dom.XmlNode EventID       			= Event.addChildElement( 'EventID', null, null);
                            EventID.setAttribute( 'IDValue', '0');
                            
                            Dom.XmlNode Agent         			= Event.addChildElement( 'Agent', null, null);
                            Dom.XmlNode AgentName       		= Agent.addChildElement( 'AgentName', null, null );
                            Dom.XmlNode AgentFirstName     		= AgentName.addChildElement( 'FirstName', null, null );
                            AgentFirstName.addTextNode('AnyoneHome');
                            
                            Dom.XmlNode AgentLastName     		= AgentName.addChildElement( 'LastName', null, null );
                            AgentLastName.addTextNode('AnyoneHome');
                            
                            Dom.XmlNode EventReasons     		= Event.addChildElement( 'EventReasons', null, null);
                            
                            Dom.XmlNode FirstContact    	 	= Event.addChildElement( 'FirstContact', null, null);
                            
                            Dom.XmlNode Comments           		= Event.addChildElement( 'Comments', null, null);
                            Dom.XmlNode TransactionSource   	= Event.addChildElement( 'TransactionSource', null, null);
                            
                            if( null != cs.ContactNameAPI__c ) {
                                List<String> ContactNameAPI = cs.ContactNameAPI__c.split(' ', 2);
                                CustomerFirstName.addTextNode( ContactNameAPI[0] );
                                
                                if( 2 == ContactNameAPI.size() ) {
                                    CustomerLastName.addTextNode( ContactNameAPI[1] );
                                }
                            }
                            if( null != cs.Address_Line_1__c ) {
                                AddressLine1.addTextNode( cs.Address_Line_1__c );
                            }
                            AddressLine2.addTextNode( 'NA' );
                            if ( null != cs.City__c ) {
                                City.addTextNode( cs.City__c );
                            }
                            
                            if ( null != cs.State__c ) {
                                State.addTextNode( cs.State__c  );  
                            }
                            if ( null != cs.Zip_Code__c )  {
                                PostalCode.addTextNode( cs.Zip_Code__c );
                            }                            
                            if ( null != cs.ContactPhoneAPI__c ) {
                                PhoneNumber0.addTextNode( cs.ContactPhoneAPI__c );
                            }
                            if ( null != cs.Contact_Mobile_Email_template__c ) {
                                Phone1.setAttribute( 'PhoneType', 'cell' );
                                PhoneNumber1.addTextNode( cs.Contact_Mobile_Email_template__c );
                            }
                            if ( null != cs.Contact_Email_Email_template__c ) {
                                Email.addTextNode( cs.Contact_Email_Email_template__c );
                            }
                            
                            if ( null != cs.Move_in_Date__c ) {
                                ExpectedMoveInDate.addTextNode( String.valueOf( cs.Move_in_Date__c ) );
                            } else {
                                
                                ExpectedMoveInDate.addTextNode( DateTime.now().format('yyyy-MM-dd') );
                            }
                            if ( null != cs.Move_in_Date__c ) {
                                TargetMoveInDate.addTextNode( String.valueOf( cs.Move_in_Date__c ) );
                            } else {
                                TargetMoveInDate.addTextNode( DateTime.now().format('yyyy-MM-dd') );
                            }

                            Unit__c unit = new Unit__c();
                            if( null != cs.Unit_of_Interest__r.Unit_ID__c ) {
                                unit.Unit_ID__c = cs.Unit_of_Interest__r.Unit_ID__c;
                            } else {
                                if( null != cs.Floor_Plan_of_Interest__c ) {
                                    List<Unit__c> waitListunit = [ SELECT Unit_ID__c FROM Unit__c WHERE Floor_Plan__r.Floorplan_ID__c = :cs.Floor_Plan_of_Interest__r.Floorplan_ID__c AND unit_ID__c != NULL AND Is_Waitlist__c = true ];
                                    if( ! waitListunit.isEmpty() && 'YES' == IntegrationsCredentials.get( 'SendWaitlist' ) )
                                        unit.Unit_ID__c = waitListunit.get(0).Unit_ID__c;
                                } else if( 'YES' == IntegrationsCredentials.get( 'SendWaitlist' ) && WaitListUnitPerFpPerProperty.containsKey( cs.Property_of_Interest__r.Customer_Prop_ID__c ) ) {
                                    Set<String> WaitlistFpOfProperty = WaitListUnitPerFpPerProperty.get( cs.Property_of_Interest__r.Customer_Prop_ID__c ).keySet();
                                    for( String WalitlistFloorplan :WaitlistFpOfProperty ) {
                                        unit.Unit_ID__c = WaitListUnitPerFpPerProperty.get( cs.Property_of_Interest__r.Customer_Prop_ID__c ).get( WalitlistFloorplan );
                                    }
                                }
                            }
                            
                            if( null != unit.Unit_ID__c )
                                MarketingName.addTextNode( unit.Unit_ID__c );
                            
                            if ( null != cs.Desired_Rent_Range_End__c ) {
                                if ( null != cs.Desired_Rent_Start__c ) {
                                    DesiredRent.setAttribute( 'Max', String.valueOf( cs.Desired_Rent_Range_End__c ) );
                                    DesiredRent.setAttribute( 'Min', String.valueOf( cs.Desired_Rent_Start__c ) );
                                } else {
                                    DesiredRent.setAttribute( 'Max', String.valueOf( cs.Desired_Rent_Range_End__c ) );
                                    DesiredRent.setAttribute( 'Min', '0' );
                                }
                            } else if ( null != cs.Desired_Rent_Start__c ) {
                                DesiredRent.setAttribute( 'Exact', String.valueOf( cs.Desired_Rent_Start__c ) );
                            }
                            
                            if ( null != cs.Bed_Count_Pref__c ) {
                                DesiredNumBedrooms.setAttribute( 'Exact', String.valueOf( cs.Bed_Count_Pref__c ) );
                            } else  {
                                DesiredNumBedrooms.setAttribute( 'Exact', '0' );
                            }
                            if ( null != cs.Desired_Lease_length__c ) {
                                DesiredLeaseTerms.addTextNode( String.valueOf( cs.Desired_Lease_length__c ) );
                            }
                            if ( null != cs.Notes__c ) {
                                Comment.addTextNode( cs.Notes__c );
                            }
                            
                            if ( null != cs.Date_Time_Sent_Via_Workflow__c ) {
                                
                                DateTime sentViaWorkFlow       = cs.Date_Time_Sent_Via_Workflow__c;
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
                            
                            String strEventTypeAttribute = 'Email';
                            if ( null != cs.Origin ) {
                                strEventTypeAttribute = cs.Origin;
                                if( 'Phone' == cs.Origin ) 
                                    strEventTypeAttribute = 'CallFromProspect';
                                if( 'Email' == cs.Origin )
                                    strEventTypeAttribute = 'Email';
                                if( 'Voicemail' == cs.Origin )
                                    strEventTypeAttribute = 'Other';
                            }
                            
                            Event.setAttribute( 'EventType', strEventTypeAttribute );
                            
                            if( ResultsPerProperty.containsKey( cs.Cust_Prop_id__c ) && !ResultsPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                EventReasons.addTextNode( ResultsPerProperty.get( cs.Cust_Prop_id__c ).get(0) );
                            }
                            
                            String EventSource;
                            if( SourcesPerProperty.containsKey( cs.Cust_Prop_id__c ) && !SourcesPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                EventSource = SourcesPerProperty.get( cs.Cust_Prop_id__c ).get(0);
                                if( null != cs.Ad_Source_Type__c ) {
                                    for( String Source :SourcesPerProperty.get( cs.Cust_Prop_id__c ) ){
                                        if( Source == cs.Ad_Source_Type__c ){
                                            EventSource = cs.Ad_Source_Type__c;
                                            break;
                                        } 
                                    }
                                } 
                                TransactionSource.addTextNode( EventSource );
                            }
                            
                            if( !cs.Is_First_Contact_Entered__c ) {
                                FirstContact.addTextNode( 'true' );
                            } else {
                                FirstContact.addTextNode( 'false' );
                            }
                            
                            List<Appointment__c> AllAppointments 	= new List<Appointment__c>();
                            List<Appointment__c> appointment_shows 	= new List<Appointment__c>();
                            List<Appointment__c> appointments 		= new List<Appointment__c>();
                            
                            if( ! Test.isRunningTest() ) {
                                AllAppointments = [SELECT Id, Unit__c,  Agent_Full_Name__c, Contact__r.Prospect_ID__c, Contact__r.FirstName, Contact__r.LastName, Appointment_Date__c, Unit__r.Unit_ID__c, NoFrom__c, Name,Contact__r.Status__c, Invite_Status__c FROM Appointment__c WHERE Case__c = : cs.Id AND Is_Event_Synced__c = false AND Unit__r.Unit_ID__c != NULL AND Contact__r.Status__c IN ( 'Showing Completed', 'Showing Set' ) AND Invite_Status__c IN ( 'Accepted', 'Invited', 'Canceled', 'Rejected' )];
                            } else {
                                AllAppointments = [ SELECT Id, Unit__c,  Agent_Full_Name__c, Contact__r.Prospect_ID__c, Contact__r.FirstName, Contact__r.LastName, Appointment_Date__c, Unit__r.Unit_ID__c, NoFrom__c, Name, Contact__r.Status__c, Invite_Status__c FROM Appointment__c];
                            }
                            
                            for( Appointment__c Appointment :AllAppointments ) {
                                if( !Test.isRunningTest() ) {
                                    if( Appointment.Contact__r.Status__c == 'Showing Completed' && Appointment.Invite_Status__c == 'Accepted' ) {
                                        appointment_shows.add( Appointment );
                                    } else if( Appointment.Contact__r.Status__c == 'Showing Set' && ( Appointment.Invite_Status__c == 'Invited' || Appointment.Invite_Status__c == 'Canceled' || Appointment.Invite_Status__c == 'Rejected' )  ) {
                                        appointments.add( Appointment );
                                    }
                                } else {
                                    appointment_shows.add( Appointment );
                                    appointments.add( Appointment );
                                }
                            }
                            
                            Boolean IsShowEvent = false;
                            if( false == appointment_shows.isEmpty() ) {
                                for( Appointment__c shows : appointment_shows ) {
                                    
                                    
                                    IsShowEvent = true;
                                    Dom.XmlNode Event1 = Events.addChildElement( 'Event', null, null );
                                    Event1.setAttribute( 'EventType', 'Show' );
                                    String EventDate1 = String.valueOf( ( null != shows.Appointment_Date__c ? shows.Appointment_Date__c : date.today() ) ) + 'T' + hours.get( String.valueOf( shows.NoFrom__c ) );
                                    
                                    if( true == cs.Is_First_Contact_Entered__c ){
                                        Events.removeChild( Event );
                                    }
                                    Event1.setAttribute( 'EventDate', EventDate1 );
                                    
                                    Dom.XmlNode EventID1 = Event1.addChildElement( 'EventID', null, null );
                                    EventID1.setAttribute( 'IDValue', '' );
                                    EventID1.setAttribute( 'IDType', shows.Unit__r.Unit_ID__c );
                                    
                                    Dom.XmlNode Agent1 = Event1.addChildElement( 'Agent', null, null );
                                    Dom.XmlNode AgentName1 = Agent1.addChildElement( 'AgentName', null, null );
                                    Dom.XmlNode FirstName1 = AgentName1.addChildElement( 'FirstName', null, null );   
                                    Dom.XmlNode LastName1 = AgentName1.addChildElement( 'LastName', null, null );   
                                    FirstName1.addTextNode( 'AnyoneHome' );
                                    LastName1.addTextNode( 'AnyoneHome' );
                                    
                                    Dom.XmlNode EventReasons1 = Event1.addChildElement( 'EventReasons', null, null );
                                    if( ResultsPerProperty.containsKey( cs.Cust_Prop_id__c ) && !ResultsPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                        EventReasons1.addTextNode( ResultsPerProperty.get( cs.Cust_Prop_id__c ).get(0) );
                                    }
                                    
                                    Dom.XmlNode FirstContact1 = Event1.addChildElement( 'FirstContact', null, null );
                                    FirstContact1.addTextNode( 'false' );
                                    
                                    Dom.XmlNode Comments1 = Event1.addChildElement( 'Comments', null, null );
                                    String strComments1 = 'AH ' + String.valueOf( shows.Appointment_Date__c ) + ' - Showing agent is ' + String.valueOf( shows.Agent_Full_Name__c );
                                    Comments1.addTextNode( strComments1 );
                                    
                                    Dom.XmlNode TransactionSource1 = Event1.addChildElement( 'TransactionSource', null, null );
                                    if( null != cs.Ad_Source_Type__c && null != EventSource ) {
                                        TransactionSource1.addTextNode( EventSource );
                                    }
                                    
                                    AppointmentPerCase.add( shows );
                                }
                                
                            }
                            
                            Boolean IsInviteAppEvent = false;
                            if( false == appointments.isEmpty() ) {
                                for( Appointment__c app : appointments ) {
                                    
                                    if( app.Invite_Status__c == 'Invited' ) {
                                        IsInviteAppEvent = true;
                                        Dom.XmlNode Event1 = Events.addChildElement( 'Event', null, null );
                                        Event1.setAttribute( 'EventType', 'Appointment' );
                                        String EventDate1 = String.valueOf( app.Appointment_Date__c ) + 'T' + hours.get( String.valueOf( app.NoFrom__c ) );
                                        
                                        Event1.setAttribute( 'EventDate', EventDate1 );
                                        if( true == cs.Is_First_Contact_Entered__c && false == IsShowEvent ){
                                            Events.removeChild( Event );
                                        }
                                        
                                        Event1.setAttribute( 'EventDate', EventDate1 );
                                        
                                        Dom.XmlNode EventID1 = Event1.addChildElement( 'EventID', null, null );
                                        
                                        Event1.setAttribute( 'EventDate', EventDate1 );
                                        EventID1.setAttribute( 'IDValue', '' );
                                        
                                        EventID1.setAttribute( 'IDType', app.Unit__r.Unit_ID__c );
                                        
                                        Dom.XmlNode Agent1 = Event1.addChildElement( 'Agent', null, null );
                                        Dom.XmlNode AgentName1 = Agent1.addChildElement( 'AgentName', null, null );
                                        Dom.XmlNode FirstName1 = AgentName1.addChildElement( 'FirstName', null, null );   
                                        Dom.XmlNode LastName1 = AgentName1.addChildElement( 'LastName', null, null );   
                                        FirstName1.addTextNode( app.Contact__r.FirstName );
                                        LastName1.addTextNode( app.Contact__r.LastName );
                                        
                                        Dom.XmlNode EventReasons1 = Event1.addChildElement( 'EventReasons', null, null );
                                        if( ResultsPerProperty.containsKey( cs.Cust_Prop_id__c ) && !ResultsPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                            EventReasons1.addTextNode( ResultsPerProperty.get( cs.Cust_Prop_id__c ).get(0) );
                                        }
                                        
                                        Dom.XmlNode FirstContact1 = Event1.addChildElement( 'FirstContact', null, null );
                                        FirstContact1.addTextNode( 'false' );
                                        
                                        Dom.XmlNode Comments1 = Event1.addChildElement( 'Comments', null, null );
                                        String strComments1 = 'AH ' + String.valueOf( app.Appointment_Date__c ) + ' - Showing agent is ' + String.valueOf( app.Agent_Full_Name__c );
                                        Comments1.addTextNode( strComments1 );
                                        
                                        Dom.XmlNode TransactionSource1 = Event1.addChildElement( 'TransactionSource', null, null );
                                        if( null != cs.Ad_Source_Type__c ) {
                                            TransactionSource1.addTextNode( String.valueOf( cs.Ad_Source_Type__c ) );
                                        }
                                        AppointmentPerCase.add( app );
                                    }
                                    
                                    String EventDate1 = String.valueOf( app.Appointment_Date__c ) + 'T' + hours.get( String.valueOf( app.NoFrom__c ) );
                                    if( 'Canceled' == app.Invite_Status__c || 'Rejected' == app.Invite_Status__c ) {
                                        Dom.XmlNode Event2 = Events.addChildElement( 'Event', null, null );
                                        Event2.setAttribute( 'EventType', 'CancelAppointment' );
                                        Event2.setAttribute( 'EventDate', EventDate1 );
                                        
                                        if( true == cs.Is_First_Contact_Entered__c && false == IsShowEvent && false == IsInviteAppEvent ){
                                            Events.removeChild( Event );
                                        }
                                        Event2.setAttribute( 'EventDate', EventDate1 );
                                        
                                        Dom.XmlNode EventID2 = Event2.addChildElement( 'EventID', null, null );
                                        
                                        EventID2.setAttribute( 'IDValue', '' );
                                        EventID2.setAttribute( 'IDType', app.Unit__r.Unit_ID__c );
                                        
                                        Dom.XmlNode Agent2 = Event2.addChildElement( 'Agent', null, null );
                                        Dom.XmlNode AgentName2 = Agent2.addChildElement( 'AgentName', null, null );
                                        Dom.XmlNode FirstName2 = AgentName2.addChildElement( 'FirstName', null, null );   
                                        Dom.XmlNode LastName2 = AgentName2.addChildElement( 'LastName', null, null );   
                                        FirstName2.addTextNode( app.Contact__r.FirstName );
                                        LastName2.addTextNode( app.Contact__r.LastName );
                                        
                                        Dom.XmlNode EventReasons2 = Event2.addChildElement( 'EventReasons', null, null );
                                        if( ResultsPerProperty.containsKey( cs.Cust_Prop_id__c ) && !ResultsPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                            EventReasons2.addTextNode( ResultsPerProperty.get( cs.Cust_Prop_id__c ).get(0) );
                                        }
                                        
                                        Dom.XmlNode FirstContact2 = Event2.addChildElement( 'FirstContact', null, null );
                                        FirstContact2.addTextNode( 'false' );
                                        
                                        Dom.XmlNode Comments2 = Event2.addChildElement( 'Comments', null, null );
                                        String strComments2 = 'AH ' + String.valueOf( app.Appointment_Date__c ) + ' - Showing agent is ' + String.valueOf( app.Agent_Full_Name__c );
                                        Comments2.addTextNode( strComments2 );
                                        
                                        Dom.XmlNode TransactionSource2 = Event2.addChildElement( 'TransactionSource', null, null );
                                        if( null != cs.Ad_Source_Type__c ) {
                                            TransactionSource2.addTextNode( String.valueOf( cs.Ad_Source_Type__c ) );
                                        }
                                        AppointmentPerCase.add( app );
                                    }
                                    
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
                            if( ! Test.isRunningTest() ) {
                                YardiGCPushWsdltoApexController.XmlDoc_element requestXML = new YardiGCPushWsdltoApexController.XmlDoc_element();
                                requestXML.anyElement   = xmlstr;                               
                                responseXml             = yvn.ImportYardiGuest_Login( IntegrationsCredentials.get( 'YardiUserName' ), IntegrationsCredentials.get( 'YardiPassword' ), IntegrationsCredentials.get( 'YardiServerName' ), IntegrationsCredentials.get( 'YardiDBName' ), IntegrationsCredentials.get( 'YardiPlatform' ), IntegrationsCredentials.get( 'YardiInterfaceEntity' ), IntegrationsCredentials.get( 'YardiInterfaceLicense' ), requestXML );
                            }  else {
                                responseXml = '<ImportYardiGuest_LoginResult><Messages xmlns=""><Message messageType="Error">Invalid or missing ResultName.</Message><Message messageType="Error">00593122:First Contact Event Failed to Post</Message></Messages></ImportYardiGuest_LoginResult>';
                            }
                            
                        } else if( '2' == IntegrationsCredentials.get( 'YardiVersionNumber' ) ) {
                            
                            yvn20 								= new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
                            yvn20.endpoint_x 					= IntegrationsCredentials.get( 'YardiAPIUrl' );
                            yvn20.timeout_x 					= 120000;
                            
                            Dom.Document doc                 	= new Dom.Document();
                            Dom.XmlNode LeadManagementNode    	= doc.createRootElement( 'LeadManagement', null, null );
                            Dom.XmlNode Prospects             	= LeadManagementNode.addChildElement( 'Prospects', null, null );
                            Dom.XmlNode Prospect             	= Prospects.addChildElement( 'Prospect', null, null );
                            Dom.XmlNode TransactionData      	= Prospect.addChildElement( 'TransactionData', null, null );
                            Dom.XmlNode Identification        	= TransactionData.addChildElement( 'Identification', null, null );
                            Identification.setAttribute( 'IDType', 'prospect' );
                            Identification.setAttribute( 'IDScopeType', 'sender' );
                            Identification.setAttribute( 'IDRank', 'other' );
                            
                            Dom.XmlNode IDValue             = Identification.addChildElement( 'IDValue', null, null );
                            if( null != cs.CaseNumber ) {
                                IDValue.addTextNode( cs.CaseNumber );                                 
                            }
                            
                            Dom.XmlNode OrganizationName       	= Identification.addChildElement( 'OrganizationName', null, null );
                            OrganizationName.addTextNode( 'Anyone Home' );
                            
                            Dom.XmlNode OriginatingLeadSource   = TransactionData.addChildElement( 'OriginatingLeadSource', null, null );
                            Dom.XmlNode OriginatingLeadChannel  = TransactionData.addChildElement( 'OriginatingLeadChannel', null, null );
                            OriginatingLeadChannel.addTextNode( 'Other' );
                            
                            Dom.XmlNode Customers         		= Prospect.addChildElement( 'Customers', null, null );
                            Dom.XmlNode Customer         		= Customers.addChildElement( 'MITS:Customer', null, null );
                            Customer.setNameSpace( 'MITS', 'http://my-company.com/namespace' );
                            Customer.setAttribute( 'Type', 'prospect' );
                            
                            Dom.XmlNode CustomerID         		= Customer.addChildElement( 'MITS:CustomerID', null, null );
                            Dom.XmlNode Property           		= Customer.addChildElement( 'MITS:Property', null, null );
                            Dom.XmlNode PrimaryID        		= Property.addChildElement( 'MITS:PrimaryID', null, null );
                            PrimaryID.addTextNode( cs.Cust_Prop_id__c );
                            
                            Dom.XmlNode MarketingName       	= Property.addChildElement( 'MITS:MarketingName', null, null );
                            Dom.XmlNode Name             		= Customer.addChildElement( 'MITS:Name', null, null );
                            Dom.XmlNode CustomerFirstName     	= Name.addChildElement( 'MITS:FirstName', null, null );
                            Dom.XmlNode CustomerLastName       	= Name.addChildElement( 'MITS:LastName', null, null );
                            
                            if( null != cs.ContactNameAPI__c ) {
                                List<String> ContactNameAPI = cs.ContactNameAPI__c.split(' ', 2);
                                CustomerFirstName.addTextNode( ContactNameAPI[0] );
                                
                                if( 2 == ContactNameAPI.size() ) {
                                    CustomerLastName.addTextNode( ContactNameAPI[1] );
                                }
                            }
                            
                            Dom.XmlNode Address           	= Customer.addChildElement( 'MITS:Address', null, null );
                            Address.setAttribute( 'Type', 'property' );
                            
                            Dom.XmlNode Address1           		= Address.addChildElement( 'MITS:Address1', null, null );
                            Dom.XmlNode Address2           		= Address.addChildElement( 'MITS:Address2', null, null );
                            Dom.XmlNode City             		= Address.addChildElement( 'MITS:City', null, null );
                            Dom.XmlNode State             		= Address.addChildElement( 'MITS:State', null, null );
                            Dom.XmlNode PostalCode         		= Address.addChildElement( 'MITS:PostalCode', null, null );
                            
                            if( null != cs.Address_Line_1__c ) {
                                Address1.addTextNode( cs.Address_Line_1__c );
                            }
                            Address2.addTextNode( 'NA' );
                            if ( null != cs.City__c ) {
                                City.addTextNode( cs.City__c );
                            }
                            if ( null != cs.State__c ) {
                                State.addTextNode( cs.State__c  );  
                            }
                            if ( null != cs.Zip_Code__c )  {
                                PostalCode.addTextNode( cs.Zip_Code__c );
                            }
                            
                            Dom.XmlNode Email     = Address.addChildElement( 'MITS:Email', null, null );
                            
                            if ( null != cs.Contact_Email_Email_template__c ) {
                                Email.addTextNode( cs.Contact_Email_Email_template__c );
                            }
                            
                            Dom.XmlNode Phone0     = Customer.addChildElement( 'MITS:Phone', null, null );
                            Phone0.setAttribute( 'Type', 'home' );                            
                            Dom.XmlNode PhoneNumber0 = Phone0.addChildElement( 'MITS:PhoneNumber', null, null );
                            
                            if ( null != cs.ContactPhoneAPI__c ) {
                                PhoneNumber0.addTextNode( cs.ContactPhoneAPI__c );
                            }
                            
                            Dom.XmlNode CustomerPreferences = Prospect.addChildElement( 'CustomerPreferences', null, null );
                            CustomerPreferences.setNameSpace( 'MITS', 'http://my-company.com/namespace' );
                            Dom.XmlNode TargetMoveInDate   = CustomerPreferences.addChildElement( 'TargetMoveInDate', null, null );
                            
                            if ( null != cs.Move_in_Date__c ) {
                                TargetMoveInDate.addTextNode( String.valueOf( cs.Move_in_Date__c ) );
                            } else {
                                TargetMoveInDate.addTextNode( DateTime.now().format('yyyy-MM-dd') );
                            }
                            
                            String FloorPlanIdSetPerCase;
                            System.debug('FP Waitlist - ' + IntegrationsCredentials.get( 'SendWaitlist' ));
                            Dom.XmlNode DesiredFloorplan     = CustomerPreferences.addChildElement( 'DesiredFloorplan', null, null );
                            if( null != cs.Cust_Prop_id__c &&  false == cs.Multi_Family_Case__c) {
                                DesiredFloorplan.addTextNode( String.valueOf( cs.Cust_Prop_id__c ) );
                            } else {
                                Floor_Plan__c floorplan = new Floor_Plan__c();
                                if( null != cs.Floor_Plan_of_Interest__r.Floorplan_ID__c ) {
                                    FloorPlanIdSetPerCase 		= cs.Floor_Plan_of_Interest__r.Floorplan_ID__c;
                                    floorplan.Floorplan_ID__c 	= FloorPlanIdSetPerCase;
                                } else if( 'YES' == IntegrationsCredentials.get( 'SendWaitlist' ) && WaitListUnitPerFpPerProperty.containsKey( cs.Property_of_Interest__r.Customer_Prop_ID__c ) ) {
                                    Set<String> WaitlistFpOfProperty = WaitListUnitPerFpPerProperty.get( cs.Property_of_Interest__r.Customer_Prop_ID__c ).keySet();
                                    for( String WalitlistFloorplan :WaitlistFpOfProperty ) {
                                        FloorPlanIdSetPerCase 		= WalitlistFloorplan;
                                        floorplan.Floorplan_ID__c 	= FloorPlanIdSetPerCase;
                                    }
                                }
                                DesiredFloorplan.addTextNode( ( null != String.valueOf( floorplan.Floorplan_ID__c) ? String.valueOf( floorplan.Floorplan_ID__c) : '' )  );
                            }
                            
                            if( 'YES' == IntegrationsCredentials.get( 'SendWaitlist' ) && true == cs.Multi_Family_Case__c ) {
                                
                                Dom.XmlNode DesiredUnit      = CustomerPreferences.addChildElement( 'DesiredUnit', null, null );
                                Dom.XmlNode Information      = DesiredUnit.addChildElement( 'MITS:Information', null, null );
                                Dom.XmlNode UnitID           = Information.addChildElement( 'MITS:UnitID', null, null );
                                
                                Unit__c unit = new Unit__c();
                                if( null != cs.Unit_of_Interest__r.Unit_ID__c ) {
                                    unit.Unit_ID__c = cs.Unit_of_Interest__r.Unit_ID__c;
                                } else if( null != FloorPlanIdSetPerCase &&  WaitListUnitPerFpPerProperty.containsKey( cs.Property_of_Interest__r.Customer_Prop_ID__c ) && WaitListUnitPerFpPerProperty.get( cs.Property_of_Interest__r.Customer_Prop_ID__c ).containsKey( FloorPlanIdSetPerCase ) ) {
                                    unit.Unit_ID__c = WaitListUnitPerFpPerProperty.get( cs.Property_of_Interest__r.Customer_Prop_ID__c ).get( FloorPlanIdSetPerCase );
                                } else {
                                    List<Unit__c> waitListunit = [ SELECT Unit_ID__c FROM Unit__c WHERE Floor_Plan__r.Floorplan_ID__c = :cs.Floor_Plan_of_Interest__r.Floorplan_ID__c AND unit_ID__c != NULL AND Is_Waitlist__c = true ];
                                    if( ! waitListunit.isEmpty() )
                                        unit.Unit_ID__c = waitListunit.get(0).Unit_ID__c;
                                }
                                
                                if( null != unit.Unit_ID__c ) {
                                    UnitID.addTextNode( unit.Unit_ID__c );
                                }
                                
                                Dom.XmlNode PropertyPrimaryID   = DesiredUnit.addChildElement( 'MITS:PropertyPrimaryID', null, null );
                                if( null != cs.Cust_Prop_id__c) {
                                    PropertyPrimaryID.addTextNode( cs.Cust_Prop_id__c );
                                }
                                
                                Dom.XmlNode UnitMarketingName    = DesiredUnit.addChildElement( 'MITS:MarketingName', null, null );
                                if( null != unit.Unit_ID__c  ) {
                                    UnitMarketingName.addTextNode( unit.Unit_ID__c );
                                }
                            } 
                            
                            Dom.XmlNode DesiredRent  = CustomerPreferences.addChildElement( 'DesiredRent', null, null );
                            
                            if( null != cs.Desired_Rent_Start__c && null != cs.Desired_Rent_Range_End__c ) {
                                DesiredRent.setAttribute( 'Exact', String.valueOf(cs.Desired_Rent_Range_End__c )) ; 
                            } else if( null == cs.Desired_Rent_Start__c && null != cs.Desired_Rent_Range_End__c ) {
                                DesiredRent.setAttribute( 'Exact', String.valueOf( cs.Desired_Rent_Range_End__c ) );  
                                
                            } else if( null != cs.Desired_Rent_Start__c && null == cs.Desired_Rent_Range_End__c ) {
                                DesiredRent.setAttribute( 'Exact', String.valueOf(cs.Desired_Rent_Start__c ) );                                           
                            } else {
                                DesiredRent.setAttribute( 'Exact', '0' ); 
                            }
                            
                            if ( null != cs.Bed_Count_Pref__c ) {
                                Dom.XmlNode DesiredNumBedrooms   = CustomerPreferences.addChildElement( 'DesiredNumBedrooms', null, null );
                                DesiredNumBedrooms.setAttribute( 'Exact', String.valueOf( cs.Bed_Count_Pref__c ) );
                            } 
                            
                            Dom.XmlNode Comment       			= CustomerPreferences.addChildElement( 'Comment', null, null );
                            Dom.XmlNode Events         			= Prospect.addChildElement( 'Events', null, null );
                            Dom.XmlNode Event         			= Events.addChildElement( 'Event', null, null );
                            if ( null != cs.Date_Time_Sent_Via_Workflow__c ) {
                                DateTime sentViaWorkFlow     	= cs.Date_Time_Sent_Via_Workflow__c;
                                String sentViaWorkFlowDate   	= String.valueOf( sentViaWorkFlow.format('yyyy-MM-dd') );
                                String sentViaWorkFlowTime   	= String.valueOf( sentViaWorkFlow.format('HH:mm:ss') );
                                String sentViaWorkFlowDateTime  = sentViaWorkFlowDate + 'T' + sentViaWorkFlowTime;
                                Event.setAttribute( 'EventDate', String.valueOf( sentViaWorkFlowDateTime ) );
                            } else {
                                String currentDate     			= String.valueOf( DateTime.now().format('yyyy-MM-dd') );
                                String currentTime     			= String.valueOf( DateTime.now().format('HH:mm:ss') );
                                String currentDateTime   		= currentDate + 'T' + currentTime;
                                Event.setAttribute( 'EventDate', currentDateTime );
                            }
                            
                            String strEventTypeAttribute = 'EmailFromProspect';
                            if ( null != cs.Origin ) {
                                strEventTypeAttribute = cs.Origin;
                                
                                if( 'Phone' == cs.Origin ) 
                                    strEventTypeAttribute = 'CallFromProspect';
                                if( 'Email' == cs.Origin )
                                    strEventTypeAttribute = 'EmailFromProspect';
                                if( 'Voicemail ' == cs.Origin )
                                    strEventTypeAttribute = 'Other';
                                
                            }
                            
                            Event.setAttribute( 'EventType', strEventTypeAttribute );
                            
                            Dom.XmlNode Agent           		= Event.addChildElement( 'Agent', null, null );
                            Dom.XmlNode AgentName         		= Agent.addChildElement( 'AgentName', null, null );
                            Dom.XmlNode AgentFirstName     		= AgentName.addChildElement( 'FirstName', null, null );
                            AgentFirstName.addTextNode( 'Anyone Home' );
                            
                            Dom.XmlNode AgentLastName     		= AgentName.addChildElement( 'LastName', null, null );
                            AgentLastName.addTextNode( 'Anyone Home' );
                            
                            String strEventReason;
                            Dom.XmlNode EventReasons =  Event.addChildElement( 'EventReasons', null, null );
                            if( ResultsPerProperty.containsKey( cs.Cust_Prop_id__c ) && !ResultsPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                strEventReason = ResultsPerProperty.get( cs.Cust_Prop_id__c ).get(0);
                            }
                            
                            if( null != strEventReason )
                                EventReasons.addTextNode( strEventReason );
                            
                            if( SourcesPerProperty.containsKey( cs.Cust_Prop_id__c ) && !SourcesPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                String EventSource = SourcesPerProperty.get( cs.Cust_Prop_id__c ).get(0);
                                if( null != cs.Ad_Source_Type__c ) {
                                    for( String Source :SourcesPerProperty.get( cs.Cust_Prop_id__c ) ){
                                        if( Source == cs.Ad_Source_Type__c ){
                                            EventSource = cs.Ad_Source_Type__c;
                                            break;
                                        } 
                                    }
                                } 
                                OriginatingLeadSource.addTextNode( EventSource );
                            }
                            
                            Dom.XmlNode FirstContact   = Event.addChildElement( 'FirstContact', null, null );
                            
                            if( null !=  cs.Yardi_Guest_Card_ID__c ) {
                                CustomerID.addTextNode( cs.Yardi_Guest_Card_ID__c );
                            }
                            
                            if( false == cs.Is_First_Contact_Entered__c ) {
                                FirstContact.addTextNode( 'true' );
                            } else {
                                FirstContact.addTextNode( 'false' );
                            }
                            
                            Dom.XmlNode Comments    = Event.addChildElement( 'Comments', null, null );
                            Comments.addTextNode( 'First contact' );
                            
                            List<Appointment__c> AllAppointments 	= new List<Appointment__c>();
                            List<Appointment__c> appointment_shows 	= new List<Appointment__c>();
                            List<Appointment__c> appointments 		= new List<Appointment__c>();
                            
                            if( ! Test.isRunningTest() ) {
                                AllAppointments = [SELECT Id, Unit__c,  Agent_Full_Name__c, Contact__r.Prospect_ID__c, Contact__r.FirstName, Contact__r.LastName, Appointment_Date__c, Unit__r.Unit_ID__c, NoFrom__c, Name,Contact__r.Status__c, Invite_Status__c FROM Appointment__c WHERE Case__c = : cs.Id AND Is_Event_Synced__c = false AND Unit__r.Unit_ID__c != NULL AND Contact__r.Status__c IN ( 'Showing Completed', 'Showing Set' ) AND Invite_Status__c IN ( 'Accepted', 'Invited', 'Canceled', 'Rejected' )];
                            } else {
                                AllAppointments = [ SELECT Id, Unit__c,  Agent_Full_Name__c, Contact__r.Prospect_ID__c, Contact__r.FirstName, Contact__r.LastName, Appointment_Date__c, Unit__r.Unit_ID__c, NoFrom__c, Name, Contact__r.Status__c, Invite_Status__c FROM Appointment__c];
                            }
                            
                            for( Appointment__c Appointment :AllAppointments ) {
                                if( !Test.isRunningTest() ) {
                                    if( Appointment.Contact__r.Status__c == 'Showing Completed' && Appointment.Invite_Status__c == 'Accepted' ) {
                                        appointment_shows.add( Appointment );
                                    } else if( Appointment.Contact__r.Status__c == 'Showing Set' && ( Appointment.Invite_Status__c == 'Invited' || Appointment.Invite_Status__c == 'Canceled' || Appointment.Invite_Status__c == 'Rejected' )  ) {
                                        appointments.add( Appointment );
                                    }
                                } else {
                                    appointment_shows.add( Appointment );
                                    appointments.add( Appointment );
                                }
                            }
                            
                            Boolean IsShowEvent = false;
                            if( false == appointment_shows.isEmpty() ) {
                                for( Appointment__c shows : appointment_shows){
                                    
                                    IsShowEvent = true;
                                    Dom.XmlNode Event1 = Events.addChildElement( 'Event', null, null );
                                    Event1.setAttribute( 'EventType', 'Show' );
                                    String EventDate1 = String.valueOf( ( null != shows.Appointment_Date__c ? shows.Appointment_Date__c : date.today() ) ) + 'T' + hours.get( String.valueOf( shows.NoFrom__c ) );
                                    
                                    if( true == cs.Is_First_Contact_Entered__c ){
                                        Events.removeChild( Event );
                                    }
                                    Event1.setAttribute( 'EventDate', EventDate1 );
                                    
                                    Dom.XmlNode EventID = Event1.addChildElement( 'EventID', null, null );
                                    Dom.XmlNode Identification1 = EventID.addChildElement( 'Identification', null, null );
                                    Identification1.setAttribute( 'IDScopeType', 'sender' );
                                    Identification1.setAttribute( 'IDRank', 'other' );
                                    Identification1.setAttribute( 'IDType', 'unit' );
                                    Dom.XmlNode IDValue1 = Identification1.addChildElement( 'IDValue', null, null );
                                    IDValue1.addTextNode(  shows.Unit__r.Unit_ID__c );
                                    
                                    Dom.XmlNode Agent1 = Event1.addChildElement( 'Agent', null, null );
                                    Dom.XmlNode AgentName1 = Agent1.addChildElement( 'AgentName', null, null );
                                    Dom.XmlNode FirstName1 = AgentName1.addChildElement( 'FirstName', null, null );   
                                    Dom.XmlNode LastName1 = AgentName1.addChildElement( 'LastName', null, null );   
                                    FirstName1.addTextNode( shows.Contact__r.FirstName );
                                    LastName1.addTextNode( shows.Contact__r.LastName );
                                    
                                    String strEventReasons1;
                                    Dom.XmlNode EventReasons1 = Event1.addChildElement( 'EventReasons', null, null );
                                    if( ResultsPerProperty.containsKey( cs.Cust_Prop_id__c ) && !ResultsPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                        strEventReasons1 = ResultsPerProperty.get( cs.Cust_Prop_id__c ).get(0);
                                    }
                                    if( null != strEventReasons1 )
                                        EventReasons.addTextNode( strEventReasons1 );
                                    
                                    Dom.XmlNode FirstContact1 = Event1.addChildElement( 'FirstContact', null, null );
                                    FirstContact1.addTextNode( 'false' );
                                    
                                    //Internal Comments
                                    Dom.XmlNode Comments1 = Event1.addChildElement( 'Comments', null, null );
                                    Comments1.addTextNode( '' );
                                    AppointmentPerCase.add( shows );
                                }
                            }
                            
                            Boolean IsInviteAppEvent = false;
                            if( false == appointments.isEmpty() ) {
                                for( Appointment__c app : appointments ){
                                    if( app.Invite_Status__c == 'Invited' ) {
                                        IsInviteAppEvent = true;
                                        Dom.XmlNode Event1 = Events.addChildElement( 'Event', null, null );
                                        Event1.setAttribute( 'EventType', 'Appointment' );
                                        String EventDate1 = String.valueOf( ( null != app.Appointment_Date__c ? app.Appointment_Date__c : date.today() ) ) + 'T' + hours.get( String.valueOf( app.NoFrom__c ) );
                                        
                                        if( true == cs.Is_First_Contact_Entered__c && false == IsShowEvent ) {
                                            Events.removeChild( Event );
                                        }
                                        Event1.setAttribute( 'EventDate', EventDate1 );
                                        
                                        Dom.XmlNode EventID = Event1.addChildElement( 'EventID', null, null );
                                        Dom.XmlNode Identification1 = EventID.addChildElement( 'Identification', null, null );
                                        Identification1.setAttribute( 'IDScopeType', 'sender' );
                                        Identification1.setAttribute( 'IDRank', 'other' );
                                        Identification1.setAttribute( 'IDType', 'unit' );
                                        Dom.XmlNode IDValue1 = Identification1.addChildElement( 'IDValue', null, null );
                                        IDValue1.addTextNode(  app.Unit__r.Unit_ID__c );
                                        Dom.XmlNode Agent1 = Event1.addChildElement( 'Agent', null, null );
                                        Dom.XmlNode AgentName1 = Agent1.addChildElement( 'AgentName', null, null );
                                        Dom.XmlNode FirstName1 = AgentName1.addChildElement( 'FirstName', null, null );   
                                        Dom.XmlNode LastName1 = AgentName1.addChildElement( 'LastName', null, null );   
                                        FirstName1.addTextNode( app.Contact__r.FirstName );
                                        LastName1.addTextNode( app.Contact__r.LastName );
                                        
                                        String strEventReasons1;
                                        Dom.XmlNode EventReasons1 = Event1.addChildElement( 'EventReasons', null, null );
                                        if( ResultsPerProperty.containsKey( cs.Cust_Prop_id__c ) && !ResultsPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                            strEventReasons1 = ResultsPerProperty.get( cs.Cust_Prop_id__c ).get(0);
                                        }
                                        if( null != strEventReasons1 )
                                            EventReasons.addTextNode( strEventReasons1 );
                                        
                                        
                                        Dom.XmlNode FirstContact1 = Event1.addChildElement( 'FirstContact', null, null );
                                        FirstContact1.addTextNode( 'false' );
                                        
                                        //Internal Comments
                                        Dom.XmlNode Comments1 = Event1.addChildElement( 'Comments', null, null );
                                        Comments1.addTextNode( '' );
                                        Dom.XmlNode TransactionSource1 = Event1.addChildElement( 'TransactionSource', null, null );
                                        if( null != cs.Ad_Source_Type__c ) {
                                            TransactionSource1.addTextNode( String.valueOf( cs.Ad_Source_Type__c ) );
                                        }
                                        AppointmentPerCase.add( app );
                                    }
                                    
                                    String EventDate1 = String.valueOf( app.Appointment_Date__c ) + 'T' + hours.get( String.valueOf( app.NoFrom__c ) );
                                    if( 'Canceled' == app.Invite_Status__c || 'Rejected' == app.Invite_Status__c ) {
                                        
                                        Dom.XmlNode Event2 = Events.addChildElement( 'Event', null, null );
                                        Event2.setAttribute( 'EventType', 'CancelAppointment' );
                                        
                                        if( true == cs.Is_First_Contact_Entered__c && false == IsShowEvent && false == IsInviteAppEvent ){
                                            Events.removeChild( Event );
                                        }
                                        
                                        Event2.setAttribute( 'EventDate', EventDate1 );
                                        Dom.XmlNode EventID2 = Event2.addChildElement( 'EventID', null, null );
                                        
                                        EventID2.setAttribute( 'IDValue', '' );
                                        EventID2.setAttribute( 'IDType', app.Unit__r.Unit_ID__c );
                                        
                                        Dom.XmlNode Agent2 = Event2.addChildElement( 'Agent', null, null );
                                        Dom.XmlNode AgentName2 = Agent2.addChildElement( 'AgentName', null, null );
                                        Dom.XmlNode FirstName2 = AgentName2.addChildElement( 'FirstName', null, null );   
                                        Dom.XmlNode LastName2 = AgentName2.addChildElement( 'LastName', null, null );   
                                        FirstName2.addTextNode( app.Contact__r.FirstName );
                                        LastName2.addTextNode( app.Contact__r.LastName );
                                        
                                        String strEventReasons2;
                                        Dom.XmlNode EventReasons2 = Event2.addChildElement( 'EventReasons', null, null );
                                        if( ResultsPerProperty.containsKey( cs.Cust_Prop_id__c ) && !ResultsPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                            strEventReasons2 = ResultsPerProperty.get( cs.Cust_Prop_id__c ).get(0);
                                        }
                                        
                                        if( null != strEventReasons2 )
                                            EventReasons2.addTextNode(strEventReasons2);
                                        
                                        Dom.XmlNode FirstContact2 = Event2.addChildElement( 'FirstContact', null, null );
                                        FirstContact2.addTextNode( 'false' );
                                        
                                        Dom.XmlNode Comments2 = Event2.addChildElement( 'Comments', null, null );
                                        String strComments2 = 'AH ' + String.valueOf( app.Appointment_Date__c ) + ' - Showing agent is ' + String.valueOf( app.Agent_Full_Name__c );
                                        Comments2.addTextNode( strComments2 );
                                        
                                        Dom.XmlNode TransactionSource2 = Event2.addChildElement( 'TransactionSource', null, null );
                                        if( null != cs.Ad_Source_Type__c ) {
                                            TransactionSource2.addTextNode( String.valueOf( cs.Ad_Source_Type__c ) );
                                        }
                                        AppointmentPerCase.add( app );
                                    }
                                }
                            }
                            
                            String xmlstr = doc.toXmlString();
                            
                            xmlstr = xmlstr.replace('<?xml version="1.0" encoding="UTF-8"?>', '');
                            xmlstr = xmlstr.replace('<Comments />', '<Comments></Comments>');
                            xmlstr = xmlstr.replace('<MITS:CustomerID />', '<MITS:CustomerID></MITS:CustomerID>');
                            xmlstr = xmlstr.replace('<DesiredLeaseTerms />', '<DesiredLeaseTerms></DesiredLeaseTerms>');
                            xmlstr = xmlstr.replace('<PhoneNumber/>', '<PhoneNumber></PhoneNumber>');
                            xmlstr = xmlstr.replace('<DesiredRent/>', '');
                            xmlstr = xmlstr.replace('<MITS:Email/>', '<MITS:Email></MITS:Email>');
                            xmlstr = xmlstr.replaceAll('/(^[\r\n]*|[\r\n]+)[\\s\t]*[\r\n]/', '\n' );
                            
                            System.debug('xmlstr' + xmlstr);
                            if( !Test.isRunningTest() ) {
                                YardiGC20PushWsdltoApexController.XmlDocument_element requestXML = new YardiGC20PushWsdltoApexController.XmlDocument_element();
                                requestXML.anyElement  = xmlstr;
                                responseXml      = yvn20.ImportYardiGuest_Login( IntegrationsCredentials.get( 'YardiUserName' ), IntegrationsCredentials.get( 'YardiPassword' ), IntegrationsCredentials.get( 'YardiServerName' ), IntegrationsCredentials.get( 'YardiDBName' ), IntegrationsCredentials.get( 'YardiPlatform' ), IntegrationsCredentials.get( 'YardiInterfaceEntity' ), IntegrationsCredentials.get( 'YardiInterfaceLicense' ), requestXML );
                            } else {
                                responseXml = '<ImportYardiGuest_LoginResult><Messages xmlns=""><Message messageType="Error">Invalid or missing ResultName.</Message><Message messageType="Error">00593122:First Contact Event Failed to Post</Message></Messages></ImportYardiGuest_LoginResult>';
                            }
                        }
                        
                        System.debug('responseXml ->' + responseXml);
                        if( null != responseXml ) {
                            YardiGCPushResponseController g = new YardiGCPushResponseController();                              
                            YardiGCPushResponseController.GuestCard GuestCard = g.parseGuestCards(new XmlStreamReader(responseXml));
                            
                            System.debug( 'GuestCard.Message -> ' + GuestCard.Message );
                            
                            if( '' != GuestCard.Message && false == GuestCard.IsFailed ) {
                                cs.GC_Entered__c = true;
                                cs.Is_First_Contact_Entered__c = true;
                                cs.Integration_Failed__c = false;  
                                cs.Yardi_Guest_Card_ID__c = GuestCard.Message.substring(GuestCard.Message.lastIndexOf(' ')+1);
                                if( !AppointmentPerCase.isEmpty() ){
                                    for(Appointment__c app:AppointmentPerCase ) {
                                        app.Is_Event_Synced__c = true;
                                        NeedToUpdateApp.add( app );
                                    }
                                }
                            } else {
                                cs.Is_First_Contact_Entered__c = false;
                                cs.Integration_Failed__c = true;  
                            }
                            
                            if( GuestCard.Message.length() == 0 || null == GuestCard.Message ){
                                cs.integration_fail_success_message__c = GuestCard.Message = 'No response from server. Unable to update in SFDC record.';     
                            } else if( GuestCard.Message.length() > 255 ){
                                cs.integration_fail_success_message__c = (GuestCard.Message).substring(0,254);
                            } else {
                                cs.integration_fail_success_message__c = GuestCard.Message;
                            }
                            
                            NeedToUpdateCases.add(cs);
                        }
                    }
                } catch( Exception E ) {
                    Case CaseWithError = new Case();
                    CaseWithError.Id = cs.Id;
                    String strMessage = 'SFDC: ' + e.getMessage() + ' ' + e.getStackTraceString();
                    CaseWithError.integration_fail_success_message__c = ( strMessage.length() > 255 ) ? strMessage.substring(0,254) : strMessage;
                    CaseWithError.Integration_Failed__c = true;
                    
                    System.debug( CaseWithError.integration_fail_success_message__c );
                    System.debug( CaseWithError.Integration_Failed__c );
                    NeedToUpdateCases.add( CaseWithError );
                }
                
            }
        }
		if( !NeedToUpdateApp.isEmpty() ){
            update NeedToUpdateApp;
        }
        return NeedToUpdateCases;
    }

    public void GetYardiAgentsSourcesResults_Login( Map<String, String> strCredentials, String YardiPropertyId ) {
        
        List<String> Results             = new List<String>();
        List<String> Sources             = new List<String>();
        List<String> Agents              = new List<String>();
        if( ! Test.isRunningTest() ) {
            
            if( '4' == strCredentials.get( 'YardiVersionNumber' ) ) {
                yvn 							= new YardiGCPushWsdltoApexController.ItfILSGuestCardSoap();
                yvn.endpoint_x 					= strCredentials.get( 'YardiAPIUrl' );
                strYardiAgentsSourcesResults 	= yvn.GetYardiAgentsSourcesResults_Login( strCredentials.get( 'YardiUserName' ), strCredentials.get( 'YardiPassword' ), strCredentials.get( 'YardiServerName' ), strCredentials.get( 'YardiDBName' ), strCredentials.get( 'YardiPlatform' ), YardiPropertyId, strCredentials.get( 'YardiInterfaceEntity' ),strCredentials.get( 'YardiInterfaceLicense' ) );
            } else if( '2' == strCredentials.get( 'YardiVersionNumber' ) ){
                yvn20 							= new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
                yvn20.endpoint_x 				= strCredentials.get( 'YardiAPIUrl' );
                strYardiAgentsSourcesResults 	= yvn20.GetYardiAgentsSourcesResults_Login(  strCredentials.get( 'YardiUserName' ), strCredentials.get( 'YardiPassword' ), strCredentials.get( 'YardiServerName' ), strCredentials.get( 'YardiDBName' ), strCredentials.get( 'YardiPlatform' ), YardiPropertyId, strCredentials.get( 'YardiInterfaceEntity' ),strCredentials.get( 'YardiInterfaceLicense' ) );
            }
        } else {
           strYardiAgentsSourcesResults = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <GetYardiAgentsSourcesResults_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20"> <GetYardiAgentsSourcesResults_LoginResult> <Properties xsi:noNamespaceSchemaLocation="" xmlns=""> <Property> <PropertyCode>10alme</PropertyCode> <PropertyRequiredFields> <Agents> <AgentName>Rover</AgentName> <AgentName InactiveDate="2014-03-02">New Site Setup</AgentName> <AgentName>Property Solutions</AgentName> <AgentName>Rent Cafe</AgentName> <AgentName>Z Do Not Use</AgentName> <AgentName>Vanessa Leimback</AgentName> <AgentName>Carrie Otto</AgentName> <AgentName>Madison Young</AgentName> <AgentName>Jessica Sneed</AgentName> <AgentName>Anyone Home</AgentName> <AgentName>Anyone Home Anyone Home</AgentName> </Agents> <Sources> <SourceName>Apt. Guide Mag</SourceName> <SourceName>Apt. Showcase</SourceName> <SourceName>Locator</SourceName> <SourceName>Non-Res Ref</SourceName> <SourceName>ParaRentar Mag</SourceName> <SourceName>Yellow Pages</SourceName> <SourceName>Apts. 24/7</SourceName> <SourceName>Apts.com Nwsp</SourceName> <SourceName>Competitor Ref</SourceName> <SourceName>Corp. Housing</SourceName> <SourceName>Echo Mag</SourceName> <SourceName>For Rent Mag.</SourceName> <SourceName>Home Builder</SourceName> <SourceName>New Mkt Svcs</SourceName> <SourceName>Off Site Mktg</SourceName> <SourceName>PB Bell Ref</SourceName> <SourceName>RE Agent</SourceName> <SourceName>Resident Ref</SourceName> <SourceName>Tuc Nwsp</SourceName> <SourceName>Y Mas</SourceName> <SourceName>Drive By</SourceName> <SourceName>For Rent Online</SourceName> <SourceName>ParaRentar Online</SourceName> <SourceName>Rent.com</SourceName> <SourceName>The Independent</SourceName> <SourceName>Winter Visitor</SourceName> <SourceName>Apt. Guide Online</SourceName> <SourceName>Aptfinders.com</SourceName> <SourceName>Apts.com Mag</SourceName> <SourceName>Apts.com Online</SourceName> <SourceName>Move.com</SourceName> <SourceName>Craigs List</SourceName> <SourceName>Nurse/Intern Housing.com</SourceName> <SourceName>mynewplace.com</SourceName> <SourceName>New Site Set Up</SourceName> <SourceName>Corp Mkting</SourceName> <SourceName>Property Solutions</SourceName> <SourceName>Realtor.com</SourceName> <SourceName>luxe List</SourceName> <SourceName>Google</SourceName> <SourceName>RENTCafe</SourceName> <SourceName>PB Bell Transfer</SourceName> <SourceName>Former Resident Ref</SourceName> <SourceName>Zillow.com</SourceName> <SourceName>RentMineOnline.com</SourceName> <SourceName>RentAdvisors</SourceName> <SourceName>Linked</SourceName> <SourceName>Facebook</SourceName> <SourceName>PBBell.com</SourceName> <SourceName>AptRatings</SourceName> <SourceName>AptSearch.com</SourceName> <SourceName>Yelp</SourceName> <SourceName>Banner</SourceName> <SourceName>Hotpads.com</SourceName> <SourceName>Rentbits.com</SourceName> <SourceName>Trulia.com</SourceName> <SourceName>Pref Employer</SourceName> <SourceName>Community Website</SourceName> <SourceName>Apartment List</SourceName> <SourceName>Employee Network</SourceName> <SourceName>Local First</SourceName> <SourceName>E-Blast</SourceName> <SourceName>Mobile Website</SourceName> <SourceName>Google Ads</SourceName> <SourceName>Google Plus</SourceName> <SourceName>AZ Central Print</SourceName> <SourceName>Print Editorial</SourceName> <SourceName>AZ Central Online</SourceName> <SourceName>TV/Radio Ad</SourceName> <SourceName>Internet Other</SourceName> </Sources> <Results> <Result>Residency, Criminal &amp; Financia</Result> <Result>Community Amenities</Result> <Result>Community Location</Result> <Result>Community Price</Result> <Result>Community Apartment Size</Result> <Result>Financial Reasons</Result> <Result>Job Transfer</Result> <Result>Marital / Roommate</Result> <Result>Criminal</Result> <Result>Employment</Result> <Result>Financial</Result> <Result>Criminal &amp; Employment</Result> <Result>Criminal &amp; Financial</Result> <Result>Employment &amp; Financial</Result> <Result>Criminal, Financial &amp; Employme</Result> <Result>Show - Rented</Result> <Result>Show - Did Not Rent</Result> <Result>Show - Not Qualified</Result> <Result>Site Unseen - Rented</Result> <Result>Phone Call - Made Appt.</Result> <Result>Phone Call - No Appt.</Result> <Result>Residency</Result> <Result>Residency &amp; Employment</Result> <Result>Residency &amp; Criminal</Result> <Result>Residency, Criminal &amp; Employme</Result> <Result>Email/Internet - Made Appt.</Result> <Result>Email/Internet - No Appt.</Result> <Result>Phone Call - Not Qualified</Result> <Result>Entered Twice</Result> <Result>Email/Internet - Not Qualified</Result> <Result>Cancel Transfer</Result> <Result>Did Not Meet Conditional Appro</Result> <Result>General Correspondence</Result> <Result>Thank You Letter</Result> <Result>Return Visit</Result> <Result>Reassign to Waitlist</Result> <Result>Walk In - No Show</Result> <Result>Did not Appear for Move In</Result> <Result>No Availability for Waitlist</Result> <Result>Health</Result> <Result>Residency &amp; Financial</Result> </Results> </PropertyRequiredFields> </Property> </Properties> </GetYardiAgentsSourcesResults_LoginResult> </GetYardiAgentsSourcesResults_LoginResponse> </soap:Body> </soap:Envelope>';
        }
        
        System.debug('strYardiAgentsSourcesResults - ' + strYardiAgentsSourcesResults);
        if( null != strYardiAgentsSourcesResults ) {
            Dom.Document doc = new Dom.Document();
            doc.load(strYardiAgentsSourcesResults);
            Dom.XMLNode EnvelopeRootNode = doc.getRootElement();
            
            for( Dom.XMLNode child : EnvelopeRootNode.getChildElements() ) {
                
                if( 'Body' == child.getName() ) {
                    for( Dom.XMLNode child2 : child.getChildElements() ) {
                        
                        if( 'GetYardiAgentsSourcesResults_LoginResponse' == child2.getName() ) {
                            for( Dom.XMLNode child3 : child2.getChildElements() ) {
                                
                                if( 'GetYardiAgentsSourcesResults_LoginResult' == child3.getName() ) {
                                    for( Dom.XMLNode child4 : child3.getChildElements() ) {
                                        
                                        if( 'Properties' == child4.getName() ) {
                                            for( Dom.XMLNode child5 : child4.getChildElements() ) {
                                                
                                                if( 'Property' == child5.getName() ) {
                                                    for( Dom.XMLNode child6 : child5.getChildElements() ) {
                                                        
                                                        if( 'PropertyRequiredFields' == child6.getName() ) {
                                                            for( Dom.XMLNode child7 : child6.getChildElements() ) {
                                                                String PropertyRequiredFieldsChildsName = child7.getName();
                                                                
                                                                for( Dom.XMLNode child8 : child7.getChildElements() ) {
                                                                    if( 'Agents' == PropertyRequiredFieldsChildsName )
                                                                        Agents.add( child8.getText() );
                                                                    
                                                                    if( 'Sources' == PropertyRequiredFieldsChildsName ) 
                                                                        Sources.add( child8.getText() );
                                                                    
                                                                    if( 'Results' == PropertyRequiredFieldsChildsName ) 
                                                                        Results.add( child8.getText() );
                                                                    
                                                                }

                                                                ResultsPerProperty.put( YardiPropertyId, Results );
                                                                SourcesPerProperty.put( YardiPropertyId, Sources );
                                                                AgentsPerProperty.put( YardiPropertyId, Agents );
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
    }
}