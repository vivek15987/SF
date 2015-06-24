public class PopCardIntegrationController {
    
    public List<Case> arrobjCases = new List<Case>();
    CommonFunctions cf = new CommonFunctions();
    
    public String strXMLString;
    public String removedspecialcharacterstring ;
    
    public void pushPopCards() {
        List<Case> arrfetchedCases = new List<Case>();
        
        Datetime PreviousDay      = DateTime.now().addDays(-1);
        String PreviousDayDate          = String.valueOf( PreviousDay.format('yyyy-MM-dd') );
        String PreviousDayTime          = String.valueOf( DateTime.now().format('HH:mm:ss') );
        String PreviousDayDateTime      = PreviousDayDate + 'T' + PreviousDayTime + '.000z';
        
        String strSql = ' SELECT Ad_Source_Type__c, Bath_Count_Pref__c, Bed_Count_Pref__c, Created_Date_and_Time__c, CreatedDate, Desired_Rent_Range_End__c, Desired_Rent_Start__c, Email_Content__c, Id, CaseNumber, Move_in_Date__c, Of_Occupants__c, Origin, Pet_Count_Other__c, Pop_Card_Entered_in_PMS__c, Property_Name__c, Property_of_Interest__c, Subject, Yardi_Pop_Card_Id__c, Ad_Source2__r.Email__c, Ad_Source2__r.Source_Type__c, Contact.Email, Contact.FirstName, Contact.LastName, Contact.MailingCity, Contact.MailingCountry, Contact.MailingState, Contact.MailingStreet, Contact.MailingPostalCode, Contact.OtherPhone, Contact.Phone, Contact.Id, Notes__c, Contact.MobilePhone FROM Case WHERE Property_of_Interest__r.Enable_PopCard_Integration__c = TRUE AND Shop_Source__c = FALSE AND Pop_Card_Entered_in_PMS__c = FALSE AND Guest_Card_Status__c = \'Sent via Workflow\' AND Yardi_Pop_Card_Id__c = NULL AND IC_Call_Answered_by_AH__c = TRUE AND PC_Integration_Failed__c = FALSE AND PC_Integration_Fail_Success_Message__c = NULL AND CreatedDate >= ' + PreviousDayDateTime + ' LIMIT 50';
        
        System.debug('strSql - ' + strSql);
        arrfetchedCases = ( List<Case> )Database.query( strSql );
        
        for( Case objCase: arrfetchedCases ) {
            if( null != objCase.Yardi_Pop_Card_Id__c || false == objCase.Pop_Card_Entered_in_PMS__c ) {
                try {
                    Dom.Document doc = new Dom.Document();
                    
                    Dom.XmlNode trafficNode = doc.createRootElement( 'traffic', null, null );
                    trafficNode.setNamespace( 'xsd', 'http://www.w3.org/2001/XMLSchema' );
                    trafficNode.setNamespace( 'xsi', 'http://www.w3.org/2001/XMLSchema-instance' );
                    
                    if( null != objCase.Created_Date_and_Time__c ) {
                        DateTime CreatedDateTime    = objCase.Created_Date_and_Time__c;
                        String CreatedDate     		= String.valueOf( CreatedDateTime.format('yyyy-MM-dd') );
                        String CreatedTime    	 	= String.valueOf( CreatedDateTime.format('HH:mm:ss') );
                        String CreatedDateAndTime 	= CreatedDate + 'T' + CreatedTime;
                        
                        trafficNode.setAttribute( 'contactdatetime', CreatedDateAndTime );
                    } else {
                        trafficNode.setAttribute( 'contactdatetime', '' );
                    }
                    
                    if( null != objCase.CreatedDate ) {
                        DateTime CreatedDateTime    = objCase.CreatedDate;
                        String CreatedDate     		= String.valueOf( CreatedDateTime.format('yyyy-MM-dd') );
                        String CreatedTime     		= String.valueOf( CreatedDateTime.format('HH:mm:ss') );
                        String CreatedDateAndTime 	= CreatedDate + 'T' + CreatedTime;
                        
                        trafficNode.setAttribute( 'transactiondatetime', CreatedDateAndTime ); 
                    } else {
                        trafficNode.setAttribute( 'transactiondatetime', '' );
                    }
                    
                    Dom.XmlNode trafficsource   = trafficNode.addChildElement( 'trafficsource', null, null );
                    Dom.XmlNode vendorid   = trafficsource.addChildElement( 'vendorid', null, null );
                    
                    vendorid.addTextNode( '5b42d7bb-7202-4d00-abd6-0c6ea8109650' );
                    
                    Dom.XmlNode emailaddress = trafficsource.addChildElement( 'emailaddress', null, null );
                    if( null != objCase.Contact.Email ){
                        emailaddress.addTextNode( objCase.Contact.Email );
                    } else {
                        emailaddress.addTextNode( '' );
                    }
                    
                    Dom.XmlNode phonenumber	= trafficsource.addChildElement( 'phonenumber', null, null );
                    if( null != objCase.Contact.Phone ){
                        phonenumber.addTextNode( objCase.Contact.Phone );
                    } else if( null != objCase.Contact.MobilePhone ){
                        phonenumber.addTextNode( objCase.Contact.MobilePhone );
                    } else {
                        phonenumber.addTextNode( '' );
                    }
                    
                    Dom.XmlNode sourcename 	= trafficsource.addChildElement( 'sourcename', null, null );
                    if( null != objCase.Ad_Source_Type__c ){
                        sourcename.addTextNode( objCase.Ad_Source_Type__c );
                    } else {
                        sourcename.addTextNode( '' );
                    }
                    
                    Dom.XmlNode sourceid 	= trafficsource.addChildElement( 'sourceid', null, null );
                    sourceid.addtextNode( '' );
                    
                    Dom.XmlNode propertyid 		= trafficsource.addChildElement( 'propertyid', null, null );
                    Dom.XmlNode propertyname 	= trafficsource.addChildElement( 'propertyname', null, null );
                    
                    if( null != objCase.Property_Name__c && null != objCase.Property_of_Interest__c ) {
                        propertyid.addTextNode( objCase.Property_of_Interest__c );
                        propertyname.addTextNode( objCase.Property_Name__c );
                        
                    } else {
                        propertyid.addTextNode( '' );
                        propertyname.addTextNode( '' );
                        
                    }
                    
                    Dom.XmlNode prospect = trafficNode.addChildElement( 'prospect', null, null );
                    
                    Dom.XmlNode firstname = prospect.addChildElement( 'firstname', null, null );
                    if( null != objCase.Contact.FirstName ) {
                        firstname.addTextNode( objCase.Contact.FirstName );
                    } else {
                        firstname.addTextNode( '' );
                    }
                    
                    Dom.XmlNode middlename = prospect.addChildElement( 'middlename', null, null );
                    
                    Dom.XmlNode lastname = prospect.addChildElement( 'lastname', null, null );
                    if( null != objCase.Contact.LastName ) {
                        lastname.addTextNode( objCase.Contact.LastName );
                    } else {
                        lastname.addTextNode( '' );
                    }
                    
                    Dom.XmlNode streetaddress1 = prospect.addChildElement( 'streetaddress1', null, null );
                    if( null != objCase.Contact.MailingStreet ) {
                        streetaddress1.addTextNode( objCase.Contact.MailingStreet );
                    } else {
                        streetaddress1.addTextNode( '' );
                    }
                    
                    Dom.XmlNode streetaddress2 = prospect.addChildElement( 'streetaddress2', null, null );
                    
                    Dom.XmlNode city = prospect.addChildElement( 'city', null, null );
                    if( null != objCase.Contact.MailingCity ) {
                        city.addTextNode( objCase.Contact.MailingCity );
                    } else {
                        city.addTextNode( '' );
                    }
                    
                    Dom.XmlNode state = prospect.addChildElement( 'state', null, null );
                    if( null != objCase.Contact.MailingState ) {
                        state.addTextNode( objCase.Contact.MailingState );
                    } else {
                        state.addTextNode( '' );
                    }
                    
                    Dom.XmlNode zipcode = prospect.addChildElement( 'zipcode', null, null );
                    if( null != objCase.Contact.MailingPostalCode ) {
                        zipcode.addTextNode( objCase.Contact.MailingPostalCode );
                    } else {
                        zipcode.addTextNode( '' );
                    }
                    
                    Dom.XmlNode daytimephone = prospect.addChildElement( 'daytimephone', null, null );
                    if( null != objCase.Contact.Phone ) {
                        daytimephone.addTextNode( objCase.Contact.Phone );
                    } else if( null != objCase.Contact.MobilePhone ){
                        daytimephone.addTextNode( objCase.Contact.MobilePhone );
                    } else {
                        daytimephone.addTextNode( '' );
                    }
                    
                    Dom.XmlNode eveningphone = prospect.addChildElement( 'eveningphone', null, null );
                    eveningphone.addTextNode( '' );
                    
                    Dom.XmlNode cellphone = prospect.addChildElement( 'cellphone', null, null );
                    cellphone.addTextNode( '' );
                    
                    Dom.XmlNode otherphone = prospect.addChildElement( 'otherphone', null, null );
                    if( null != objCase.Contact.OtherPhone ) {
                        otherphone.addTextNode( objCase.Contact.OtherPhone );
                    } else {
                        otherphone.addTextNode( '' );
                    }
                    
                    Dom.XmlNode prospectemailaddress = prospect.addChildElement( 'emailaddress', null, null );
                    if( null != objCase.Contact.Email ) {
                        prospectemailaddress.addTextNode( objCase.Contact.Email );
                    } else {
                        prospectemailaddress.addTextNode( '' );
                    }            
                    
                    Dom.XmlNode comments = prospect.addChildElement( 'comments', null, null );
                    if( null != objCase.Notes__c ) {
                        
                        removedspecialcharacterstring = cf.RemovingSpecialCharacters(objCase.Notes__c);
                        comments.addTextNode( removedspecialcharacterstring );                       
                    } else {
                        comments.addTextNode( '' );
                    }
                    
                    Dom.XmlNode prospectpreferences   = trafficNode.addChildElement( 'prospectpreferences', null, null );
                    
                    Dom.XmlNode pricerangemin = prospectpreferences.addChildElement( 'pricerangemin', null, null );
                    if( null != objCase.Desired_Rent_Start__c ) {
                        pricerangemin.addTextNode( String.valueOf( objCase.Desired_Rent_Start__c ) );
                    } else {
                        pricerangemin.addTextNode( '' );
                    }
                    
                    Dom.XmlNode pricerangemax = prospectpreferences.addChildElement( 'pricerangemax', null, null );
                    if( null != objCase.Desired_Rent_Range_End__c ) {
                        pricerangemax.addTextNode( String.valueOf( objCase.Desired_Rent_Range_End__c ) );
                    } else {
                        pricerangemax.addTextNode( '' );
                    }
                    
                    Dom.XmlNode numberofoccupants = prospectpreferences.addChildElement( 'numberofoccupants', null, null );
                    if( null != objCase.Of_Occupants__c ) {
                        numberofoccupants.addTextNode( String.valueOf( objCase.Of_Occupants__c ) );
                    } else {
                        numberofoccupants.addTextNode( '' );
                    }
                    
                    Dom.XmlNode pets = prospectpreferences.addChildElement( 'pets', null, null );
                    if( null != objCase.Pet_Count_Other__c ) {
                        pets.addTextNode( String.valueOf( objCase.Pet_Count_Other__c ) );
                    } else {
                        pets.addTextNode( '' );
                    }
                    
                    Dom.XmlNode dateneeded = prospectpreferences.addChildElement( 'dateneeded', null, null );
                    if( null != objCase.Move_in_Date__c ) {
                        dateneeded.addTextNode( String.valueOf( objCase.Move_in_Date__c ) );
                    } else {
                        dateneeded.addTextNode( '' );
                    }
                    String contactId = objCase.Contact.Id;
                    if( null != contactId )
                        contactId = contactId.substring( 0, 15 );
                    
                    List<Appointment__c> Appointment = new List<Appointment__c>();
                    
                    Appointment = [  SELECT 
                                   Appointment_Date__c, Contact_ID__c, From__c, To__c
                                   FROM
                                   Appointment__c
                                   WHERE
                                   case__r.CaseNumber =: objCase.CaseNumber AND Contact_ID__c =: contactId AND Invite_Status__c IN ( 'Accepted', 'Invited' )
                                   ORDER BY
                                   Appointment_Date__c DESC, From__c, To__c
                                   LIMIT 1];
                    
                    Dom.XmlNode appointmentdate = prospectpreferences.addChildElement( 'appointmentdate', null, null );
                    Dom.XmlNode appointmenttime = prospectpreferences.addChildElement( 'appointmenttime', null, null );
                    
                    if( !Appointment.isEmpty() && null != Appointment[0].Appointment_Date__c ) {
                        appointmentdate.addTextNode( String.valueOf( Appointment[0].Appointment_Date__c ) );
                    } else {
                        appointmentdate.addTextNode( '' );
                    }
                    
                    if( !Appointment.isEmpty() && null != Appointment[0].From__c ) {
                        appointmenttime.addTextNode( ConvertStrToTime( Appointment[0].From__c ) );
                    } else {
                        appointmenttime.addTextNode( '' );
                    }
                    
                    Dom.XmlNode numberofbedsdesired = prospectpreferences.addChildElement( 'numberofbedsdesired', null, null );
                    if( null != objCase.Bed_Count_Pref__c ) {
                        numberofbedsdesired.addTextNode( String.valueOf( objCase.Bed_Count_Pref__c ) );
                    } else {
                        numberofbedsdesired.addTextNode( '' );
                    }
                    
                    Dom.XmlNode numberofbathsdesired = prospectpreferences.addChildElement( 'numberofbathsdesired', null, null );
                    if( null != objCase.Bath_Count_Pref__c ) {
                        numberofbathsdesired.addTextNode( String.valueOf( objCase.Bath_Count_Pref__c ) );
                    } else {
                        numberofbathsdesired.addTextNode( '' );
                    }
                    
                    if( 'Email' == objCase.Origin ) {
                        Dom.XmlNode EmailNode   = trafficNode.addChildElement( 'Email', null, null );
                        
                        Dom.XmlNode fromEmail   = EmailNode.addChildElement( 'from', null, null );
                        if( null != objCase.Ad_Source2__r.Email__c ) {
                            fromEmail.addTextNode( objCase.Ad_Source2__r.Email__c );
                        } else {
                            fromEmail.addTextNode( '' );
                        }
                        
                        Dom.XmlNode toEmail   = EmailNode.addChildElement( 'to', null, null );
                        if( null != objCase.Ad_Source2__r.Source_Type__c ) {
                            toEmail.addTextNode( objCase.Ad_Source2__r.Source_Type__c );
                        } else {
                            toEmail.addTextNode( '' );
                        }
                        
                        Dom.XmlNode Emailsubject   = EmailNode.addChildElement( 'subject', null, null );
                        if( null != objCase.Subject ) {
                            Emailsubject.addTextNode( objCase.Subject );
                        } else {
                            Emailsubject.addTextNode( '' );
                        }
                        
                        Dom.XmlNode Emailbody   = EmailNode.addChildElement( 'body', null, null );
                        if( null != objCase.Email_Content__c ) {
                            Emailbody.addTextNode( objCase.Email_Content__c );
                        } else {
                            Emailbody.addTextNode( '' );
                        }
                    }
                    
                    strXMLString = doc.toXmlString();
                    strXMLString = strXMLString.replace('<?xml version="1.0" encoding="UTF-8"?>', '');
                    strXMLString = strXMLString.replaceAll('/(^[\r\n]*|[\r\n]+)[\\s\t]*[\r\n]/', '\n' );
                    
                    System.debug('strXMLString - ' + strXMLString );
                    
                    if( null != strXMlString ) {
                        String responseString = this.insertTraffic( strXMlString );
                        
                        if( test.isRunningTest() ) {
                            responseString = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <InsertTrafficResponse xmlns="http://tempuri.org/PopCardInterfaceWebservice/Service1"> <GeneralResponse xmlns="PopCardInterface"> <ResponseStatus>Valid</ResponseStatus> <ErrorString></ErrorString> <TrackingID>1e3e1ab3-fdf8-4d31-bdff-539d2b6449fb</TrackingID> </GeneralResponse> </InsertTrafficResponse> </soap:Body> </soap:Envelope>';
                        }
                        
                        if( !String.isEmpty(responseString) ) {
                            Map<String, String> responseElements = new Map<String, String>();
                            responseElements = this.parsePopCardResponse(new XmlStreamReader( responseString ) ); 
                            
                            System.debug( responseElements );
                            
                            objCase.PC_Integration_Failed__c = TRUE;
                            objCase.Pop_Card_Entered_in_PMS__c = FALSE;
                            objCase.PC_Integration_Fail_Success_Message__c = 'Invalid Response';
                            
                            if( !responseElements.isEmpty() ) {
                                if( 'Valid' == responseElements.get('ResponseStatus') ) {
                                    objCase.Pop_Card_Entered_in_PMS__c = TRUE;
                                    objCase.PC_Integration_Fail_Success_Message__c = responseElements.get( 'ResponseStatus' );
                                    objCase.Yardi_Pop_Card_Id__c = responseElements.get( 'TrackingID' );
                                    objCase.PC_Integration_Failed__c = FALSE;
                                    
                                } else {
                                    objCase.PC_Integration_Fail_Success_Message__c = responseElements.get( 'ErrorString' );
                                    objCase.PC_Integration_Failed__c = TRUE;
                                    objCase.Pop_Card_Entered_in_PMS__c = FALSE;
                                    System.debug( 'Failed to integrate with Yardi Server' );
                                }
                            }
                            
                            arrobjCases.add( objCase );
                        }
                    } 
                } catch( Exception e ) {
                    System.debug( e.getMessage() );
                    System.debug( e.getStackTraceString() );
                    System.debug( objCase.CaseNumber ); 
                }
            }   
        }
        
        System.debug( arrfetchedCases.size() );
    }   
    
    public string ConvertStrToTime( String strtime ){
        
        string newtime;
        List<String>ListTime 	= strtime.Substring( 0, strTime.length()-5 ).split( ':' );
        String Hour 			= String.valueOf( ListTime.get(0) );
        String Min 				= String.valueOf( ListTime.get(1) );
        
        if( strTime.contains( 'p' ) ) {
            Integer IntHour 			= Integer.valueOf( ListTime.get(0) );
            IntHour += 12;
            return( IntHour + ':' + Min + ':00' );
        } else{
            if( Hour.Length()==1 ) 
                Hour = '0' + Hour;
            
            return( Hour + ':' + Min + ':00' );    
        }
        
    }
    
    public String insertTraffic( String strXMLString ) {
        String responseXMLString;
        
        System.debug('strXMLString : ' + strXMLString);
        
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( 'http://interface.webservices.popcard.ltsolutions.com/service.asmx/InsertTraffic' );
        request.setMethod( 'POST' );
        request.setHeader( 'Content-Type', 'application/x-www-form-urlencoded' );
        request.setTimeout(120000);
        request.setBody( 'strRequestXML=' + strXMLString );
        
        Http http 				= new Http();
        if( !test.isRunningTest() ) {
            HTTPResponse response 	= http.send( request );
            responseXMLString 		= response.getBody();
            
            system.debug('response'+response);
        }
        
        System.Debug( responseXMLString );
        
        return responseXMlString;
    }   
    
    public Map<String, String> parsePopCardResponse(XmlStreamReader reader) {
        boolean isSafeToGetNextXmlElement = true;
        Map<String, String> responseElements = new Map<String, String>();
        responseElements.put( 'TrackingID', '' );
        responseElements.put( 'ResponseStatus', '' );
        responseElements.put( 'ErrorString', '' );
        
        Set<String> validElements = new Set<String>{ 'TrackingID', 'ResponseStatus', 'ErrorString' };
            
            while(isSafeToGetNextXmlElement) {               
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    String ElementName = reader.getLocalName();
                    if ( validElements.contains( ElementName ) ) {
                        responseElements.put( ElementName, parseResponse(reader) );
                    }
                }
                
                if (reader.hasNext()) {
                    reader.next();
                } else {
                    isSafeToGetNextXmlElement = false;
                    break;
                }
            }
        return responseElements;
    }
    
    public String parseResponse( XmlStreamReader reader) {
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
}