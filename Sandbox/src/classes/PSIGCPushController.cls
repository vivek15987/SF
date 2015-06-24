public with sharing class PSIGCPushController {
    
    public String responseJSON;
    public String strLeadPickLists;
    
    public List<Case> Cases 										= new List<Case>();
    public List<Case> NeedtoUpdateCases								= new List<Case>();
    public Map<String, List<String>> strPropertySources 			= new Map<String, List<String>>();
    public Map<String, Map<String, String>> IntegrationsCredentialsPerAccount = new Map<String, Map<String, String>>();
    
    public PSIGCPushController() {
    }
    
    public List<Case> pushGuestCards() {
        
        Set<String>PSIAccountIds = new Set<String>();
        Set<String>PSIPropIds = new Set<String>();
        Map<String, Map<String, String>> WaitListUnitAndFpPerProperty 	= new Map<String, Map<String, String>>();
        
        for( Case cs : Cases ) {
            if( ! PSIAccountIds.contains( cs.AccountId ) )
                PSIAccountIds.add( cs.AccountId );
            
            if( !PSIPropIds.contains( cs.Property_of_Interest__r.PSI_Prop_ID__c ) )
                PSIPropIds.add( cs.Property_of_Interest__r.PSI_Prop_ID__c );
        }
        
        for( String PSIAccountId :PSIAccountIds ) {
            if( IntegrationsCredentialsPerAccount.containsKey( PSIAccountId ) )
                this.getLeadPickLists( IntegrationsCredentialsPerAccount.get( PSIAccountId ).get( 'PSIUserName' ), IntegrationsCredentialsPerAccount.get( PSIAccountId ).get( 'PSIPassword' ), '', IntegrationsCredentialsPerAccount.get( PSIAccountId ).get( 'PSIAPIUrl' ) );
        }
        
        List<Unit__c> Waitlist = new List<Unit__c>();
        if( !Test.isRunningTest() ) {
            Waitlist = [SELECT Id, Floor_Plan__r.PSI_Floor_Plan_ID__c, PSI_Unit_ID__c , Property__c, Property__r.PSI_Prop_ID__c FROM Unit__c WHERE Floor_Plan__r.Is_Waitlist__c = true AND Is_Waitlist__c = true AND Floor_Plan__r.PSI_Floor_Plan_ID__c != NULL AND PSI_Unit_ID__c  != NULL AND Property__r.PSI_Prop_ID__c  IN :PSIPropIds  ];
        } else {
            Waitlist = [SELECT Id, Floor_Plan__r.PSI_Floor_Plan_ID__c, PSI_Unit_ID__c , Property__c, Property__r.PSI_Prop_ID__c FROM Unit__c ];
        }
        
        if( !Waitlist.isEmpty() ) {
            for( Unit__c unit:Waitlist ) {
                if( false == WaitListUnitAndFpPerProperty.containsKey( unit.Property__c ) ) {
                    Map<String, String> WaitlistUnitPerFp = new Map<String, String>();
                    WaitlistUnitPerFp.put( unit.Floor_Plan__r.PSI_Floor_Plan_ID__c  , unit.PSI_Unit_ID__c  );
                    WaitListUnitAndFpPerProperty.put( unit.Property__c , WaitlistUnitPerFp );
                }
            }
        }
        
        for( Case cs : Cases ) {
            if( IntegrationsCredentialsPerAccount.containsKey( cs.AccountId ) ){
                try {
                    JSONGenerator JSONrequest = JSON.createGenerator(true); 
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName('auth');
                    JSONrequest.writeStartObject();
                    JSONrequest.writeStringField( 'type', 'basic');
                    JSONrequest.writeStringField( 'password', IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'PSIPassword' ) );
                    JSONrequest.writeStringField( 'username', IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'PSIUserName' ) );
                    JSONrequest.writeEndObject();
                    JSONrequest.writeStringField( 'requestId' , String.valueOf( Math.abs( Math.mod( Crypto.getRandomInteger(), 1000 ) ) ) );   
                    JSONrequest.writeFieldName('method');
                    JSONrequest.writeStartObject();
                    JSONrequest.writeStringField( 'name', 'sendMitsLeads');
                    JSONrequest.writeFieldName( 'params' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeStringField( 'propertyId', cs.Property_of_Interest__r.PSI_Prop_ID__c  );
                    JSONrequest.writeFieldName( 'Prospects' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( 'Prospect' );
                    JSONrequest.writeStartArray();
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( 'TransactionData' );
                    JSONrequest.writeStartObject();
                    String Source = '';
                    if( null != cs.Ad_Source_Type__c && !strPropertySources.isEmpty() && strPropertySources.containsKey( cs.Property_of_Interest__r.PSI_Prop_ID__c ) ) {
                        Source = strPropertySources.get( cs.Property_of_Interest__r.PSI_Prop_ID__c ).get(0);
                        
                        for( String str : strPropertySources.get( cs.Property_of_Interest__r.PSI_Prop_ID__c ) ) {
                            if( str == cs.Ad_Source_Type__c ) {
                                Source = cs.Ad_Source_Type__c;
                                break;
                            }
                        }
                    }
                    JSONrequest.writeStringField( 'OriginatingLeadSource', Source );
                    JSONrequest.writeEndObject();
                    
                    String currentDateTime;
                    if( null != cs.CreatedDate ) {
                        DateTime strCreated     = cs.CreatedDate;
                        String strCreatedDate   = String.valueOf( strCreated.format('yyyy-MM-dd') );
                        String strCreatedTime   = String.valueOf( strCreated.format('HH:mm:ss') );
                        String strCreatedDateTime = strCreatedDate + 'T' + strCreatedTime;
                        JSONrequest.writeStringField( 'LastUpdateDate', strCreatedDateTime );
                    }
                    
                    JSONrequest.writeFieldName( 'Customers' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( 'Customer' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( 'Name' );
                    JSONrequest.writeStartObject();
                    if( null != cs.ContactNameAPI__c ) {
                        List<String> ContactNameAPI = cs.ContactNameAPI__c.split(' ', 2);
                        JSONrequest.writeStringField( 'FirstName', ContactNameAPI[0] );
                        
                        if( 2 == ContactNameAPI.size() ) {
                            JSONrequest.writeStringField( 'LastName', ContactNameAPI[1] );
                        } else {
                            JSONrequest.writeStringField( 'LastName', '' );
                        }
                    } else {
                        JSONrequest.writeStringField( 'FirstName', '' );
                        JSONrequest.writeStringField( 'LastName', '' );
                    }  
                    JSONrequest.writeEndObject();
                    JSONrequest.writeFieldName( 'Phone' );
                    JSONrequest.writeStartArray();
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( '@attributes' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeStringField( 'PhoneType', 'personal' );
                    JSONrequest.writeEndObject();
                    if ( null != cs.ContactPhoneAPI__c ) {
                        JSONrequest.writeStringField( 'PhoneNumber', cs.ContactPhoneAPI__c  );
                    } else {
                        JSONrequest.writeStringField( 'PhoneNumber', '' );
                    }
                    
                    JSONrequest.writeEndObject();
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( '@attributes' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeStringField( 'PhoneType', 'cell' );
                    JSONrequest.writeEndObject();
                    
                    if ( null != cs.Contact_Mobile_Email_template__c ) {
                        JSONrequest.writeStringField( 'PhoneNumber', cs.Contact_Mobile_Email_template__c  );
                    } else {
                        JSONrequest.writeStringField( 'PhoneNumber', '' );
                    }	
                    JSONrequest.writeEndObject();
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( '@attributes' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeStringField( 'PhoneType', 'office' );
                    JSONrequest.writeEndObject();
                    JSONrequest.writeStringField( 'PhoneNumber', '' );
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndArray();
                    if ( null != cs.Contact_Email_Email_template__c ) {
                        JSONrequest.writeStringField( 'Email', cs.Contact_Email_Email_template__c );
                    } else {
                        JSONrequest.writeStringField( 'Email', '' );
                    }
                    
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndObject();
                    JSONrequest.writeFieldName( 'CustomerPreferences' );
                    JSONrequest.writeStartObject();
                    if ( null != cs.Move_in_Date__c ) { 
                        JSONrequest.writeStringField( 'TargetMoveInDate', String.valueOf( cs.Move_in_Date__c ) );
                    } else {
                        JSONrequest.writeStringField( 'TargetMoveInDate', '' );
                    }
                    
                    String FloorPlanIDPerCase;
                    if( null != cs.Property_of_Interest__r.PSI_Prop_ID__c &&  false == cs.Multi_Family_Case__c  ) {
                        JSONrequest.writeStringField( 'DesiredFloorplan', cs.Property_of_Interest__r.PSI_Prop_ID__c );
                    } else {
                        Floor_Plan__c floorplan = new Floor_Plan__c();
                        if( null != cs.Floor_Plan_of_Interest__r.PSI_Floor_Plan_ID__c  ) {
                            FloorPlanIDPerCase = cs.Floor_Plan_of_Interest__r.PSI_Floor_Plan_ID__c;
                            floorplan.PSI_Floor_Plan_ID__c = FloorPlanIDPerCase;
                        } else {
                            if( true == WaitListUnitAndFpPerProperty.containsKey( cs.Property_of_Interest__c ) ) {
                                Set<String> WaitListFloorplans		= WaitListUnitAndFpPerProperty.get( cs.Property_of_Interest__c ).keySet();
                                for( String WaitListFloorplan : WaitListFloorplans )   {
                                    FloorPlanIDPerCase = WaitListFloorplan;
                                }
                                floorplan.PSI_Floor_Plan_ID__c 	= FloorPlanIDPerCase;
                            }
                        }
                        JSONrequest.writeStringField( 'DesiredFloorplan', ( null != String.valueOf( floorplan.PSI_Floor_Plan_ID__c) ? String.valueOf( floorplan.PSI_Floor_Plan_ID__c) : '' ) );
                    }
                    
                    if( true == cs.Multi_Family_Case__c ) {
                        Unit__c unit = new Unit__c();
                        
                        if( null != cs.Unit_of_Interest__c && null != cs.Unit_of_Interest__r.PSI_Unit_ID__c ) {
                            unit.PSI_Unit_ID__c 	= cs.Unit_of_Interest__r.PSI_Unit_ID__c;
                            unit.Name 				= cs.Unit_of_Interest__r.Name;
                            unit.Floor_Plan__c 		= cs.Unit_of_Interest__r.Floor_Plan__c;
                            unit.Bedrooms__c 		= cs.Unit_of_Interest__r.Bedrooms__c;
                            unit.Bathrooms__c 		= cs.Unit_of_Interest__r.Bathrooms__c;
                            unit.Square_Feet__c 	= cs.Unit_of_Interest__r.Square_Feet__c;
                            unit.Market_Rent__c 	= cs.Unit_of_Interest__r.Market_Rent__c;
                            unit.Maximum_Rent__c 	= cs.Unit_of_Interest__r.Maximum_Rent__c;  
                            
                        } else if( null != FloorPlanIDPerCase ) {
                            
                            //Need to remove this SOQL by creating Map of FPId,Unit object.
                            
                            List<Unit__c> WaitListUnits = [ SELECT Id, Name, PSI_Unit_ID__c, Floor_Plan__c, Bedrooms__c, Bathrooms__c, Square_Feet__c, Maximum_Rent__c, Market_Rent__c FROM Unit__c WHERE Property__c = :cs.Property_of_Interest__c AND Floor_Plan__r.PSI_Floor_Plan_ID__c = : FloorPlanIDPerCase AND PSI_Unit_ID__c != null AND Is_Waitlist__c = true ];
                            if( false == WaitListUnits.isEmpty() ) {
                                unit.PSI_Unit_ID__c 	= WaitListUnits[0].PSI_Unit_ID__c;
                                unit.Name 				= WaitListUnits[0].Name;
                                unit.Floor_Plan__c 		= WaitListUnits[0].Floor_Plan__c;
                                unit.Bedrooms__c 		= WaitListUnits[0].Bedrooms__c;
                                unit.Bathrooms__c 		= WaitListUnits[0].Bathrooms__c;
                                unit.Square_Feet__c 	= WaitListUnits[0].Square_Feet__c;
                                unit.Market_Rent__c 	= WaitListUnits[0].Market_Rent__c;
                                unit.Maximum_Rent__c 	= WaitListUnits[0].Maximum_Rent__c;
                            }
                        }
                        JSONrequest.writeFieldName( 'DesiredUnit' );
                        JSONrequest.writeStartObject();
                        JSONrequest.writeFieldName( 'Identification' );
                        JSONrequest.writeStartObject();
                        JSONrequest.writeFieldName( '@attributes' );
                        JSONrequest.writeStartObject();
                        JSONrequest.writeStringField( 'IDRank', '' );
                        JSONrequest.writeStringField( 'IDScopeType', '' );
                        JSONrequest.writeStringField( 'IDType', '' );
                        
                        JSONrequest.writeEndObject();
                        JSONrequest.writeStringField( 'IDValue', ( null != unit.PSI_Unit_ID__c ? unit.PSI_Unit_ID__c : '' ) );
                        JSONrequest.writeEndObject();
                        JSONrequest.writeStringField( 'MarketingName', ( null != unit.Name ? unit.Name : '' ) );
                        if( null != unit.Floor_Plan__c  ) {
                            JSONrequest.writeStringField( 'UnitType', unit.Floor_Plan__c );    
                        } else {
                            JSONrequest.writeStringField( 'UnitType', '' );    
                        }
                        JSONrequest.writeStringField( 'UnitBedrooms', ( null != String.valueOf( unit.Bedrooms__c ) ? String.valueOf( unit.Bedrooms__c ) : '' ) );
                        JSONrequest.writeStringField( 'UnitBathrooms', ( null != String.valueOf( unit.Bathrooms__c ) ? String.valueOf( unit.Bathrooms__c ) : '' ) );
                        JSONrequest.writeStringField( 'MinSquareFeet', '' );
                        JSONrequest.writeStringField( 'MaxSquareFeet', ( null != unit.Square_Feet__c ? unit.Square_Feet__c : '' ) );
                        JSONrequest.writeStringField( 'UnitRent', ( null != String.valueOf( unit.Maximum_Rent__c ) ? String.valueOf( unit.Maximum_Rent__c ) : '' ) );
                        JSONrequest.writeStringField( 'MarketRent', ( null != String.valueOf( unit.Market_Rent__c ) ? String.valueOf( unit.Market_Rent__c ) : '' ) );
                        JSONrequest.writeStringField( 'NumberOccupants', ( null != String.valueOf( cs.Of_Occupants__c ) ? String.valueOf( cs.Of_Occupants__c ) : '' ) );
                        JSONrequest.writeEndObject();
                    }
                    JSONrequest.writeFieldName( 'DesiredRent' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( '@attributes' );
                    JSONrequest.writeStartObject();
                    if( null != cs.Desired_Rent_Start__c ) {
                        JSONrequest.writeStringField( 'Min', '$' + String.valueOf( cs.Desired_Rent_Start__c ) );
                    } else {
                        JSONrequest.writeStringField( 'Min', '$0.00' );
                    }
                    
                    if( null != cs.Desired_Rent_Range_End__c ) {
                        JSONrequest.writeStringField( 'Max', '$' + String.valueOf( cs.Desired_Rent_Range_End__c )  );
                    } else {
                        JSONrequest.writeStringField( 'Max', '$0.00' );
                    }
                    
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndObject();
                    JSONrequest.writeFieldName( 'DesiredNumBedrooms' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( '@attributes' );
                    JSONrequest.writeStartObject();
                    if( null != cs.Bed_Count_Pref__c ) {
                        JSONrequest.writeStringField( 'Exact', String.valueOf( cs.Bed_Count_Pref__c ) );
                    } else {
                        JSONrequest.writeStringField( 'Exact', '0' );
                    }
                    
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndObject();
                    JSONrequest.writeFieldName( 'DesiredNumBathrooms' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( '@attributes' );
                    JSONrequest.writeStartObject();
                    if( null != cs.Bath_Count_Pref__c ) {
                        JSONrequest.writeStringField( 'Exact', String.valueOf( cs.Bath_Count_Pref__c ) );
                    } else {
                        JSONrequest.writeStringField( 'Exact', '0' );
                    }
                    
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndObject();
                    if( null != cs.Desired_Lease_length__c ) {
                        JSONrequest.writeStringField( 'DesiredLeaseTerms', String.valueOf( cs.Desired_Lease_length__c ) );
                    } else {
                        JSONrequest.writeStringField( 'DesiredLeaseTerms', '' );
                    }
                    
                    if( null != cs.Of_Occupants__c ) {
                        JSONrequest.writeStringField( 'NumberOfOccupants', String.valueOf( cs.Of_Occupants__c ) );
                    } else {
                        JSONrequest.writeStringField( 'NumberOfOccupants', '' );
                    }
                    
                    JSONrequest.writeStringField( 'Comment', '' );
                    JSONrequest.writeEndObject();
                    
                    JSONrequest.writeFieldName( 'Events' );
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( 'Event' );
                    JSONrequest.writeStartArray();
                    JSONrequest.writeStartObject();
                    JSONrequest.writeFieldName( '@attributes' );
                    JSONrequest.writeStartObject();
                    if( null != cs.CreatedDate ) {
                        DateTime strCreated     = cs.CreatedDate;
                        String strCreatedDate   = String.valueOf( strCreated.format('yyyy-MM-dd') );
                        String strCreatedTime   = String.valueOf( strCreated.format('HH:mm:ss') );
                        String strCreatedDateTime = strCreatedDate + 'T' + strCreatedTime;
                        
                        JSONrequest.writeStringField( 'EventDate', strCreatedDateTime );
                    } /*else {
                    	JSONrequest.writeStringField( 'EventDate', currentDateTime );
                    }*/
                    
                    JSONrequest.writeEndObject();
                    JSONrequest.writeFieldName( 'CallData' );
                    JSONrequest.writeStartObject();
                    if( null != cs.ContactPhoneAPI__c ) {
                        String PhoneNumber = cs.ContactPhoneAPI__c.replaceAll( '[^0-9]', '' );
                        if ( PhoneNumber.length() == 10) {
                            JSONrequest.writeStringField( 'CallFrom', PhoneNumber.substring(0,3) + '-' + PhoneNumber.substring(3,6) + '-' + PhoneNumber.substring(6,10) );
                            
                        } else {
                            JSONrequest.writeStringField( 'CallFrom', cs.ContactPhoneAPI__c);
                        } 
                    } else {
                        JSONrequest.writeStringField( 'CallFrom', '' );
                    }
                    if( null != cs.Ad_Source_DNIS__c ) {
                        String RingThrough = String.valueOf( cs.Ad_Source_DNIS__c );
                        String specialChars = '(|)|-';
                        for(integer jj=0; jj<specialChars.split('|').size(); jj++)
                            RingThrough = RingThrough.replace(specialChars.split('|')[jj], '');
                        JSONrequest.writeStringField( 'RingThrough', RingThrough.deleteWhitespace() );
                        //JSONrequest.writeStringField( 'RingThrough', cs.Ad_Source_DNIS__c );
                        System.debug(RingThrough.deleteWhitespace());
                    } else {
                        JSONrequest.writeStringField( 'RingThrough', '' );
                    }
                    
                    JSONrequest.writeStringField( 'CallStatus', 'Answer' );
                    if( null != cs.IC_Call_Duration__c ) {
                        JSONrequest.writeStringField( 'Duration', cs.IC_Call_Duration__c);
                    } else {
                        JSONrequest.writeStringField( 'Duration', '' );
                    }
                    
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndObject();
                    
                    List<Appointment__c> arrobjAppointments = this.findAppointments( cs.CaseNumber ); 
                    if( !arrobjAppointments.isEmpty() ) {
                        for( Appointment__c Appointment : arrobjAppointments ) {
                            JSONrequest.writeStartObject();
                            JSONrequest.writeFieldName( '@attributes' );
                            JSONrequest.writeStartObject();
                            JSONrequest.writeStringField( 'EventType', 'Appointment' );
                            if ( null != cs.Date_Time_Sent_Via_Workflow__c ) {
                                DateTime sentViaWorkFlow     = cs.Date_Time_Sent_Via_Workflow__c;
                                String sentViaWorkFlowDate     = String.valueOf( sentViaWorkFlow.format('yyyy-MM-dd') );
                                String sentViaWorkFlowTime     = String.valueOf( sentViaWorkFlow.format('HH:mm:ss') );
                                String sentViaWorkFlowDateTime  = sentViaWorkFlowDate + 'T' + sentViaWorkFlowTime;
                                
                                JSONrequest.writeStringField( 'EventDate', sentViaWorkFlowDateTime );
                            } else {
                                JSONrequest.writeStringField( 'EventDate', currentDateTime );
                            }
                            if( null != Appointment.Appointment_Date__c ) {
                                JSONrequest.writeStringField( 'AppointmentDate', String.valueOf( Appointment.Appointment_Date__c ) );
                            } else {
                                JSONrequest.writeStringField( 'AppointmentDate', '' );
                            }
                            if( null != Appointment.From__c ) {
                                JSONrequest.writeStringField( 'TimeFrom', convertTime( (String) Appointment.From__c ) );
                            } else {
                                JSONrequest.writeStringField( 'TimeFrom', '' );
                            }
                            if( null != Appointment.To__c ) {
                                JSONrequest.writeStringField( 'TimeTo', convertTime( (String) Appointment.To__c ) );
                            } else {
                                JSONrequest.writeStringField( 'TimeTo', '' );
                            }
                            
                            
                            JSONrequest.writeEndObject();
                            JSONrequest.writeStringField( 'EventReasons', Appointment.Name );
                            JSONrequest.writeStringField( 'Comments', '' );
                            JSONrequest.writeStringField( 'AudioLink', '' );
                            JSONrequest.writeEndObject();
                        }
                    }
                    JSONrequest.writeEndArray();
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndArray();
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndObject();
                    JSONrequest.writeEndObject();
                    
                    System.Debug( JSONrequest.getAsString().replaceAll('\\n', '') );
                    
                    Http httpPro = new Http();
                    HttpRequest httpreq = new HttpRequest();
                    
                    httpreq.setEndPoint( IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'PSIAPIUrl' ) + '/leads' );
                    httpreq.setMethod( 'GET' );
                    httpreq.setHeader( 'Content-Type', 'application/json' );
                    httpreq.setBody( JSONrequest.getAsString() );
                    httpreq.setTimeout( 120000 );
                    
                    if( !Test.isRunningTest() ) {
                        HTTPResponse httpres = httpPro.send(httpreq);
                        responseJSON = httpres.getBody();
                        System.debug( responseJSON );
                    } else {
                        responseJSON = '{ "response":{ "requestId":"898", "result":{ "Prospects":{ "Prospect":[ { "@attributes":{ "node":1, "reference_id":4434271, "applicant_id":4900021, "status":"Success", "message":"Lead inserted successfully." } } ] } } } }';
                    }                         
                    Boolean isIntegrationFailed = true;
                    String strSuccessOrFailMessage;
                    String referenceId;
                    String applicantId;
                    
                    if( null != responseJSON ) {
                        
                        Map<String, Object> JSONdeserializedResponse = (Map<String, Object>) JSON.deserializeUntyped( responseJSON );
                        if( JSONdeserializedResponse.containsKey( 'response' ) ) {
                            JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('response');
                            if( JSONdeserializedResponse.containsKey( 'error' ) ) {
                                JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('error');
                                strSuccessOrFailMessage = ( String ) JSONdeserializedResponse.get( 'message' );
                            } else if( JSONdeserializedResponse.containsKey( 'result' ) ) {
                                JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('result');
                                if( JSONdeserializedResponse.containsKey( 'Prospects' ) ) {
                                    JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('Prospects');
                                    if( JSONdeserializedResponse.containsKey( 'Prospect' ) ) {
                                        List<Object> arrobjProspectList = ( List<Object> ) JSONdeserializedResponse.get('Prospect');
                                        
                                        for( Object objProspect : arrobjProspectList ) {
                                            Map<String, Object> JSONProspect = ( Map<String, Object> ) objProspect;
                                            JSONProspect = ( Map<String, Object> ) JSONProspect.get( '@attributes' );
                                            if( 'Success' == String.valueOf( JSONProspect.get( 'status' ) ) ) {
                                                referenceId = String.valueOf( JSONProspect.get( 'reference_id' ) );
                                                applicantId = String.valueOf( JSONProspect.get( 'applicant_id' ) );
                                                isIntegrationFailed = false;
                                            } 
                                            
                                            strSuccessOrFailMessage = ( String ) JSONProspect.get( 'message' );
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        if( false == isIntegrationFailed ) {
                            cs.GC_Entered__c = true;
                            cs.Integration_Failed__c = false;  
                            cs.Yardi_Guest_Card_ID__c = referenceId;
                        } else {
                            cs.Integration_Failed__c = true;  
                        }
                        
                        if( strSuccessOrFailMessage.length() > 255 ){
                            cs.integration_fail_success_message__c = (strSuccessOrFailMessage).substring(0,254);
                        } else {
                            cs.integration_fail_success_message__c = strSuccessOrFailMessage;
                        }
                        
                        NeedtoUpdateCases.add(cs);
                    }
                } catch(Exception e) {
                    Case CaseWithError = new Case();
                    CaseWithError.Id = cs.Id;
                    String strMessage = 'SFDC: ' + e.getMessage() + ' ' + e.getStackTraceString();
                    CaseWithError.integration_fail_success_message__c = ( strMessage.length() > 255 ) ? strMessage.substring(0,254) : strMessage;
                    CaseWithError.Integration_Failed__c = true;
                    
                    System.debug( CaseWithError.integration_fail_success_message__c );
                    System.debug( CaseWithError.Integration_Failed__c );
                    NeedtoUpdateCases.add( CaseWithError );
                    
                }
            }
        }
        
        return NeedtoUpdateCases;
    }
    
    public void getLeadPickLists( String Username, String Password, String PropertyId, String PSI_API_URL ) {
        
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
        request.setEndPoint( PSI_API_URL + '/leads' );
        request.setMethod( 'POST' );
        request.setHeader( 'Content-Type', 'application/json' );
        request.setBody( JSONrequest.getAsString() );
        request.setTimeout( 120000 );
        if( ! Test.isRunningTest() ) {
            HTTPResponse res = httpPro.send(request);
            strLeadPickLists = res.getBody();            
        } else {
            strLeadPickLists = '{"response":{"requestId":"15","result":{"Property":{"104143":{"@attributes":{"Id":104143},"LeasingAgents":{"LeasingAgent":[{"@attributes":{"name":"AJ Aikin","Id":223447}},{"@attributes":{"name":"A.J Aikin","Id":222411}},{"@attributes":{"name":"Anyone Home Anyone","Id":224486}},{"@attributes":{"name":"April Williams","Id":222412}},{"@attributes":{"name":"Eric Naranjo","Id":222629}},{"@attributes":{"name":"Kyle Anderson","Id":224148}},{"@attributes":{"name":"Kyle Anderson","Id":224227}},{"@attributes":{"name":"Lawanda Dudley","Id":222413}}]},"LeadSources":{"LeadSource":[{"@attributes":{"name":"Apartment Finder","Id":40310,"WebVisible":"true"}},{"@attributes":{"name":"Apartment Guide","Id":40305,"WebVisible":"true"}},{"@attributes":{"name":"ApartmentGuys.com","Id":47211,"WebVisible":"true"}},{"@attributes":{"name":"Apartment Home Living","Id":41886,"WebVisible":"true"}},{"@attributes":{"name":"ApartmentRatings.com","Id":41887,"WebVisible":"true"}},{"@attributes":{"name":"Apartments.com","Id":34461,"WebVisible":"true"}},{"@attributes":{"name":"Bing.com","Id":41888,"WebVisible":"true"}},{"@attributes":{"name":"Coast2Coast Transfer","Id":41891,"WebVisible":"true"}},{"@attributes":{"name":"Craigslist.com","Id":40311,"WebVisible":"true"}},{"@attributes":{"name":"Drive By","Id":34457,"WebVisible":"true"}},{"@attributes":{"name":"Facebook","Id":41894,"WebVisible":"true"}},{"@attributes":{"name":"Former Resident","Id":41895,"WebVisible":"true"}},{"@attributes":{"name":"ForRent","Id":41896,"WebVisible":"true"}},{"@attributes":{"name":"Foursquare","Id":41897,"WebVisible":"true"}},{"@attributes":{"name":"Google","Id":46760,"WebVisible":"true"}},{"@attributes":{"name":"Laramar Community Referral","Id":42233,"WebVisible":"true"}},{"@attributes":{"name":"Lifestyle Brochure","Id":46337,"WebVisible":"true"}},{"@attributes":{"name":"Locator Service","Id":41899,"WebVisible":"true"}},{"@attributes":{"name":"Move.com","Id":34466,"WebVisible":"true"}},{"@attributes":{"name":"MyNewPlace.com","Id":34464,"WebVisible":"true"}},{"@attributes":{"name":"Outreach/Direct Marketing","Id":41900,"WebVisible":"true"}},{"@attributes":{"name":"PEP Marketing","Id":41901,"WebVisible":"true"}},{"@attributes":{"name":"Property Website","Id":41902,"WebVisible":"true"}},{"@attributes":{"name":"Rent.com","Id":34462,"WebVisible":"true"}},{"@attributes":{"name":"Resident Referral","Id":34459,"WebVisible":"true"}},{"@attributes":{"name":"Signs/Banners","Id":41903,"WebVisible":"true"}},{"@attributes":{"name":"Twitter","Id":41905,"WebVisible":"true"}},{"@attributes":{"name":"Vendor/Merchant Referral","Id":41906,"WebVisible":"true"}},{"@attributes":{"name":"Yelp.com","Id":41908,"WebVisible":"true"}},{"@attributes":{"name":"Youtube.com","Id":41909,"WebVisible":"true"}}]}}}}}}';
        }
        
        if( null != strLeadPickLists ) {
            Map<String, Object> JSONdeserializedResponse = (Map<String, Object>) JSON.deserializeUntyped( strLeadPickLists );
            if( JSONdeserializedResponse.containsKey( 'response' ) ) {
                JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('response');
                if( JSONdeserializedResponse.containsKey( 'result' ) ) {
                    JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('result');	
                    if( JSONdeserializedResponse.containsKey( 'Property' ) ) {
                        JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('Property');
                        
                        for( String strKey : JSONdeserializedResponse.keySet() ) {
                            Map<String, Object> JSONPropertyResponse = ( Map<String, Object> ) JSONdeserializedResponse.get( strKey );
                            
                            if( JSONPropertyResponse.containsKey( 'LeadSources' ) ) {
                                JSONPropertyResponse = ( Map<String, Object> ) JSONPropertyResponse.get( 'LeadSources' );
                                
                                if( JSONPropertyResponse.containsKey( 'LeadSource' ) ) {
                                    List<Object> JSONLeadSourcesList = ( List<Object> ) JSONPropertyResponse.get( 'LeadSource' );
                                    
                                    if( !JSONLeadSourcesList.isEmpty() ) {
                                        List<String> LeadSourcesList = new List<String>();
                                        
                                        for( Object objLeadSource : JSONLeadSourcesList ) {
                                            Map<String, Object> LeadSourceElements = ( Map<String, Object> ) objLeadSource;
                                            LeadSourceElements = ( Map<String, Object> ) LeadSourceElements.get( '@attributes' );
                                            LeadSourcesList.add( ( String ) LeadSourceElements.get( 'name' ) );
                                        }
                                        
                                        strPropertySources.put( strKey, LeadSourcesList );
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    public List<Appointment__c> findAppointments( String CaseNumber ) {
        if( !Test.isRunningTest() ){
            return [ SELECT Id, Appointment_Date__c, From__c, To__c, Name FROM Appointment__c WHERE Case__r.CaseNumber =:CaseNumber ];    
        } else {
            return [ SELECT Id, Appointment_Date__c, From__c, To__c, Name FROM Appointment__c];    
        }
    }
    
    public String convertTime( String timestring ) {
        if( timeString.contains( 'p.m.' ) )
            return timeString.length() == 9 ? '0' + timeString.replace( ' p.m.', 'pm' ) : timeString.replace( ' p.m.', 'pm' );
        else 
            return timeString.length() == 9 ? '0' + timeString.replace( ' a.m.', 'am' ) : timeString.replace( ' a.m.', 'am' );
    }
}