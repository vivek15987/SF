public class YardiGCPushResponseController {
    // Create a class ServiceRequestForProcessing for processing
    public class GuestCard {
        Public String Message = '';
        Public Boolean IsFailed = false;
    }

    public GuestCard parseGuestCards(XmlStreamReader reader) {
        
        GuestCard gc = new GuestCard();        
        boolean isSafeToGetNextXmlElement = true;
        
        while(isSafeToGetNextXmlElement) {               
           if (reader.getEventType() == XmlTag.START_ELEMENT) {  
               if ('Message' == reader.getLocalName()) {
                   
                   if( 'Error' == reader.getAttributeValue( NULL, 'messageType') ) {
                       gc.IsFailed  = true;
                   } 
               	   gc.Message = gc.Message + ' ' + parseGuestCard(reader);
               }
            }
          
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        
        return gc;
    }
    
    public String parseGuestCard( XmlStreamReader reader) {
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
                isSafeToGetNextXmlElement1 = false; break;
            }
        }         
        
        return XMLElementValue;
    }    
}