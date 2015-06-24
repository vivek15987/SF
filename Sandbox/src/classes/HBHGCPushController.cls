public with sharing class HBHGCPushController {
    
    Public Set<ID> CaseIds 														= new Set<ID>();
    Public Map< Integer, List<Appointment__c>> NeedToupdateAppointmentsPerCase	= new Map< Integer, List<Appointment__c>>();
    Public List<Case> arrobjCases 												= new List<Case>();
    Public Map<Integer, Map<String, String>> arrGuestCardsResponse  			= new Map<Integer, Map<String, String>>();
    Public String strResponse;
    
    public HBHGCPushController() {}
    
    public void pushGuestCards() { 
        
        List<Case> fetchedCases = [SELECT
                                   ( SELECT Id, Appointment_Date__c, From__c, To__c, NoFrom__c, Name, Unit__r.Unit_ID__c FROM Appointments__r WHERE Is_Event_Synced__c = false AND Unit__r.Unit_ID__c != NULL ), CaseNumber, ContactPhoneAPI__c, ContactNameAPI__c, Contact_Mobile_Email_template__c, Contact_Email_Email_template__c, 
                                   Move_in_Date__c, Desired_Rent_Start__c, Desired_Rent_Range_End__c, Bed_Count_Pref__c, Bath_Count_Pref__c,
                                   Desired_Lease_length__c, Date_Time_Sent_Via_Workflow__c, Ad_Source_Type__c, Property_of_Interest__r.HBH_Prop_Id__c, Notes__c,
                                   Origin, Unit_of_Interest__r.Unit_ID__c, Zip_Code__c, State__c, City__c, Address_Line_1__c, Is_First_Contact_Entered__c
                                   FROM 
                                   Case
                                   WHERE 
                                   Id IN: CaseIds];
        
        List<Unit__c> ListUnits = [ SELECT Id, Name, PSI_Unit_ID__c FROM Unit__c WHERE Account__c  IN ( '001f000000lNNQ7' ) AND Property__c = 'a00f0000006pgCt' ];
        for( Unit__c unit:  ListUnits ){
            for( Unit__c unit1:  ListUnits ){
                if( unit.PSI_Unit_ID__c == unit1.PSI_Unit_ID__c ){
             		System.debug('Duplicate ' + unit.PSI_Unit_ID__c);       
                }
            }
        }
        
        for( Case cs : fetchedCases ) {
            
            try {
                Dom.Document doc         			= new Dom.Document();
                Dom.XmlNode LeadManagementNode   	= doc.createRootElement( 'LeadManagement', null, null );
                LeadManagementNode.setNamespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
                Dom.XmlNode Prospects       		= LeadManagementNode.addChildElement( 'Prospects', null, null );                
                
                Dom.XmlNode Prospect         		= Prospects.addChildElement( 'Prospect', null, null );
                Dom.XmlNode Customers       		= Prospect.addChildElement( 'Customers', null, null );
                Dom.XmlNode Customer         		= Customers.addChildElement( 'Customer', null, null );
                Customer.setAttribute( 'Type', 'prospect' );
                
                Dom.XmlNode Identification0   		= Customer.addChildElement( 'Identification', null, null);
                Identification0.setAttribute( 'IDValue', '' );
                Identification0.setAttribute( 'IDType', 'ThirdPartyID' );
                Identification0.setAttribute( 'OrganizationName', 'AnyoneHome' );
                
                /*Dom.XmlNode Identification1   		= Customer.addChildElement( 'Identification', null, null);
                Identification1.setAttribute( 'IDValue', '' );
                Identification1.setAttribute( 'IDType', 'PropertyID' );
                Identification1.setAttribute( 'OrganizationName', 'AnyoneHome' );*/
                
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
                Dom.XmlNode DesiredNumBathrooms  	= CustomerPreferences.addChildElement( 'DesiredNumBathrooms', null, null);
                
                Dom.XmlNode DesiredLeaseTerms   	= CustomerPreferences.addChildElement( 'DesiredLeaseTerms', null, null);
                Dom.XmlNode Comment       			= CustomerPreferences.addChildElement( 'Comment', null, null);
                
                Dom.XmlNode Events         			= Prospect.addChildElement( 'Events', null, null );
                Dom.XmlNode Event         			= Events.addChildElement( 'Event', null, null );
                Dom.XmlNode EventID       			= Event.addChildElement( 'EventID', null, null);
                EventID.setAttribute( 'IDValue', cs.CaseNumber );
                
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
                
                Identification0.setAttribute( 'IDValue', cs.CaseNumber );                                 
                
                //Identification1.setAttribute( 'IDValue', cs.Property_of_Interest__r.HBH_Prop_Id__c );
                
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
                
                if( null != cs.Unit_of_Interest__r.Unit_ID__c ) {
                    MarketingName.addTextNode( cs.Unit_of_Interest__r.Unit_ID__c );
                }   
                
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
                    DesiredNumBedrooms.setAttribute( 'Exact', String.valueOf( Integer.ValueOf( cs.Bed_Count_Pref__c ) ) );
                } else  {
                    DesiredNumBedrooms.setAttribute( 'Exact', '0' );
                }
                
                if ( null != cs.Bath_Count_Pref__c ) {
                    DesiredNumBathrooms .setAttribute( 'Exact', String.valueOf( Integer.ValueOf( cs.Bath_Count_Pref__c ) ) );
                } else  {
                    DesiredNumBathrooms.setAttribute( 'Exact', '0' );
                }
                
                if ( null != cs.Desired_Lease_length__c ) {
                    DesiredLeaseTerms.addTextNode( String.valueOf( cs.Desired_Lease_length__c ) );
                }
                if ( null != cs.Notes__c ) {
                    Comment.addTextNode( cs.Notes__c );
                }
                
                if ( null != cs.Date_Time_Sent_Via_Workflow__c ) {
                    DateTime sentViaWorkFlow       		= cs.Date_Time_Sent_Via_Workflow__c;
                    String sentViaWorkFlowDate       	= String.valueOf( sentViaWorkFlow.format('yyyy-MM-dd') );
                    String sentViaWorkFlowTime       	= String.valueOf( sentViaWorkFlow.format('HH:mm:ss') );
                    String sentViaWorkFlowDateTime  	= sentViaWorkFlowDate + 'T' + sentViaWorkFlowTime;
                    Event.setAttribute( 'EventDate', String.valueOf( sentViaWorkFlowDateTime ) );
                } else {
                    String currentDate           		= String.valueOf( DateTime.now().format('yyyy-MM-dd') );
                    String currentTime           		= String.valueOf( DateTime.now().format('HH:mm:ss') );
                    String currentDateTime       		= currentDate + 'T' + currentTime;
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
                
                EventReasons.addTextNode( '' );
                
                if( null != cs.Ad_Source_Type__c ) {
                    TransactionSource.addTextNode( cs.Ad_Source_Type__c );
                } 
                
                if( true == cs.Is_First_Contact_Entered__c )
                    FirstContact.addTextNode( 'false' );
                else
                    FirstContact.addTextNode( 'true' );
                
                //Appointments
                if( !cs.Appointments__r.isEmpty() ) {
                    List<Appointment__c> NeedToupdateAppointments = new List<Appointment__c>();
                    for( Appointment__c appointment: cs.Appointments__r ){
                        
                        Dom.XmlNode AppointmentEvent = Events.addChildElement( 'Event', null, null );
                        AppointmentEvent.setAttribute( 'EventType', 'Appointment' );
                        CommonFunctions CF = new CommonFunctions();
                        String AppEventDate = CF.StringToTimeConversion( String.valueOf( appointment.Appointment_Date__c ), appointment.From__c );

                        if( true == cs.Is_First_Contact_Entered__c ){
                            Events.removeChild( Event );
                        }
                        AppointmentEvent.setAttribute( 'EventDate', AppEventDate );
                        
                        Dom.XmlNode AppointmentEventID = AppointmentEvent.addChildElement( 'EventID', null, null );
                        AppointmentEventID.setAttribute( 'IDValue', appointment.Name );
                        AppointmentEventID.setAttribute( 'IDType', appointment.Unit__r.Unit_ID__c );
                        
                        Dom.XmlNode AppointmentAgent = AppointmentEvent.addChildElement( 'Agent', null, null );
                        Dom.XmlNode AppointmentAgentName = AppointmentAgent.addChildElement( 'AgentName', null, null );
                        Dom.XmlNode AppointmentFirstName = AppointmentAgentName.addChildElement( 'FirstName', null, null );   
                        Dom.XmlNode AppointmentLastName = AppointmentAgentName.addChildElement( 'LastName', null, null );   
                        AppointmentFirstName.addTextNode( 'AnyoneHome' );
                        AppointmentLastName.addTextNode( 'AnyoneHome' );
                        
                        Dom.XmlNode AppointmentEventReasons = AppointmentEvent.addChildElement( 'EventReasons', null, null );
                        
                        
                        Dom.XmlNode AppointmentFirstContact = AppointmentEvent.addChildElement( 'FirstContact', null, null );
                        AppointmentFirstContact.addTextNode( 'false' );
                        
                        Dom.XmlNode AppointmentComments = AppointmentEvent.addChildElement( 'Comments', null, null );
                        
                        Dom.XmlNode AppointmentTransactionSource = AppointmentEvent.addChildElement( 'TransactionSource', null, null );
                        if( null != cs.Ad_Source_Type__c ) { 
                            AppointmentTransactionSource.addTextNode( cs.Ad_Source_Type__c );
                        }
                        
                        appointment.Is_Event_Synced__c = true;
                        NeedToupdateAppointments.add( appointment );
                    }
                    NeedToupdateAppointmentsPerCase.put( Integer.valueOf( cs.CaseNumber ) , NeedToupdateAppointments );
                }

                System.debug( 'Request XML - ' + doc.toXMLString() );
                String responseXMLString = this.pushXML( doc );
                
                if( null != responseXMLString ) {
                    this.parseGCXMLResponse( responseXMLString );
                }
                
            } catch( Exception e ) {
                System.debug( e.getMessage() );
                System.debug( e.getStackTraceString() );
                System.debug( cs.CaseNumber );
                String strMessage = 'SFDC: ' + e.getMessage() + ' ' + e.getStackTraceString(); 
                arrGuestCardsResponse.put( Integer.valueOf(cs.CaseNumber), new Map<String, String>{ 'Status' => 'Error', 'Message' => ( strMessage.length() > 255 ) ? strMessage.substring(0,254) : strMessage } );
            }    
        }        
    }

    public void parseGCXMLResponse( String responseXMLString ) {
        Dom.Document doc = new Dom.Document();
        doc.load( responseXMLString );
        Dom.XMLNode LeadManagementResponseNode = doc.getRootElement();
        
        for( Dom.XMLNode child2 : LeadManagementResponseNode.getChildElements() ) {
            if( 'Result' == child2.getName() ) {
                for( Dom.XMLNode child2_1 : child2.getChildElements() ) {
                    if( 'Prospects' == child2_1.getName() ) {
                        for( Dom.XMLNode child2_2 : child2_1.getChildElements() ) {
                            if( 'Prospect' == child2_2.getName() ) {
                                String ThirdPartyID = child2_2.getAttributeValue('ThirdPartyID', '');
                                String RentalStatId = child2_2.getAttributeValue('RentalStatId', '');
                                String Status 		= child2_2.getAttributeValue('Status', '');
                                String Message      = child2_2.getAttributeValue( 'Message', '' );
                                arrGuestCardsResponse.put( Integer.valueOf(ThirdPartyID), new Map<String, String>{'RentalStatId' => RentalStatId, 'Status' => Status, 'Message' => Message } );
                            }
                        }
                    }
                }
            }
        }
    }
    
    public String pushXML( Dom.Document doc ) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint( 'http://api.havenbrookhomes.com/api/AnyoneHome' );
        request.setMethod( 'POST' );
        request.setTimeout( 120000 );
        request.setHeader( 'Content-Type', 'text/xml' );
        request.setBodyDocument( doc );
        
        String responseXMLString;
        if( !Test.isRunningTest() ) {
            Http http                     = new Http();
            HTTPResponse response         = http.send( request );
            responseXMLString            =  response.getBody();
            strResponse = responseXMLString;
            System.debug( 'Response XML - ' + responseXMLString );
        } else {
            responseXMLString = '<LeadManagementResponse xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <Result Status="Success"> <Prospects> <Prospect ThirdPartyID="831765" RentalStatId="f48d7383-e4e4-e411-80d6-0aad5406f850" Status="Success"> <Event IDValue="0" Status="Success" /> </Prospect> <Prospect ThirdPartyID="831766" RentalStatId="2045e7b0-efe4-e411-80d6-0aad5406f850" Status="Success"> <Event IDValue="0" Status="Success" /> </Prospect> </Prospects> </Result> </LeadManagementResponse>';
        }
        
        return responseXMLString;
        
    }
}