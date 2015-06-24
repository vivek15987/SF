public class YardiSRResponseController {

    // Create a class ServiceRequestForProcessing for processing
    public class ServiceRequest {
       public String srWorkOrderId;
       public String propId;
       public String srErrorMessage;
       public Boolean srIsFailed;
    }

    public ServiceRequest parseServiceRequestResponse( Dom.Document doc ) {
        ServiceRequest sr = new ServiceRequest();     
        
        Dom.XMLNode Envelope = doc.getRootElement();
		sr.srIsFailed = true;	
        for(Dom.XMLNode child : Envelope.getChildElements() ) {
            if( 'Body' == child.getName() ) {
                for(Dom.XMLNode child1 : child.getChildElements() ) { 
                    if( 'CreateOrEditServiceRequestsResponse' == child1.getName() ) {
                        for(Dom.XMLNode child2 : child1.getChildElements() ) { 
                            if( 'CreateOrEditServiceRequestsResult' == child2.getName() ) {
                                for(Dom.XMLNode child3 : child2.getChildElements() ) { 
                                    if( 'ServiceRequests' == child3.getName() ) {
                                        for(Dom.XMLNode child4 : child3.getChildElements() ) { 
                                            if( 'ServiceRequest' == child4.getName() ) {
                                                for(Dom.XMLNode child5 : child4.getChildElements() ) { 
                                                    if( 'ServiceRequestId' == child5.getName() ) { 
                                                        sr.srWorkOrderId = ( '0' == child5.getText() ) ? null : child5.getText() ;
                                                    } 
                                                    if( 'ErrorMessages' == child5.getName() ) {
                                                        for(Dom.XMLNode child6 : child5.getChildElements() ) { 
                                                            if( 'Error' == child6.getName() ) {
                                                                sr.srErrorMessage = ( null != sr.srErrorMessage )? sr.srErrorMessage +  ' ' + child6.getText() : child6.getText();
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
    
        if( null != sr.srWorkOrderId && String.isEmpty(sr.srErrorMessage) ) {
            sr.srIsFailed = false;	
        }
        return sr;
    }
    
    public ServiceRequest parseServicceRequest(XmlStreamReader reader) {
        
        ServiceRequest sr = new ServiceRequest();        
        
        boolean isSafeToGetNextXmlElement = true;
        
        sr.srIsFailed  = false;
        
        //Outer Loop : This loop will iterate whol XML which we sent from controller
        while(isSafeToGetNextXmlElement) {               
           if (reader.getEventType() == XmlTag.START_ELEMENT) {  
               if ('Error' == reader.getLocalName()) {
               		 sr.srErrorMessage = XMLElementParser(reader);
                     sr.srIsFailed  = true;
               } else if ('ServiceRequestId' == reader.getLocalName()) {
               		 sr.srWorkOrderId = XMLElementParser(reader);
               } else if ('PropertyCode' == reader.getLocalName()) {
               		sr.propId = XMLElementParser(reader);            	        
               } 
               //We can check flag condition for srIsFailed. If false then no need to collect other information.
               
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return sr;
    }
    
    public String XMLElementParser( XmlStreamReader reader) {
        String XMLElementValue;
        
		 boolean isSafeToGetNextXmlElement1 = true;
                   
        //Inner Loop : Iterate tag eventes ( Event Types :  Start , Character , End )
        while(isSafeToGetNextXmlElement1) {
            
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                XMLElementValue = reader.getText();                           	
            }
            
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement1 = false;
                break;
            }
        }         
        
        return XMLElementValue;
    }  
    
      public Set<String> getPropertyCodes( String strPropertiesXml ) {
                
        XmlStreamReader reader = new XmlStreamReader( strPropertiesXml );
        
        boolean isSafeToGetNextXmlElement = true;
        
        Set<String> PropertyCodes = new Set<String>();
        
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
                            PropertyCodes.add( String.valueOf( reader1.getText() ) );                           	
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
        
        return PropertyCodes;
    }     
}