public class YardiGCPullPropertiesResponseController {
	public Set<String> PropertyCodes 							= new Set<String>();
    public Map<String, Map<String, String>> PropConfResponse 	= new Map<String, Map<String, String>>();
   
    public void parsePropertyConfigurationsResponse( XmlStreamReader reader ) {
        
        boolean isSafeToGetNextXmlElement = true;
        String Code; 
        
        Map<String, String> PropertiesInfo = new Map<String, String>();
            
        while(isSafeToGetNextXmlElement) {               
           	if (reader.getEventType() == XmlTag.START_ELEMENT) {  
               	String strElementName = reader.getLocalName();
                
               	if ( 'Code' == strElementName || 'MarketingName' == strElementName || 'AddressLine1' == strElementName || 'AddressLine2' == strElementName || 'AddressLine3' == strElementName || 'City' == strElementName || 'State' == strElementName || 'PostalCode' == strElementName ) {
                    
                    if( 'Code' == strElementName ) {
                        Code = parsePropertyConfigurationElement(reader);
                        PropertiesInfo.put( strElementName, Code );
                        PropertyCodes.add( Code );
                        
                    } else if ( 'PostalCode' == strElementName ) {
                        
                        Map<String, String> properties = new Map<String, String >();
                        PropertiesInfo.put( strElementName, parsePropertyConfigurationElement(reader) );
                        
                        Properties.put( 'MarketingName', PropertiesInfo.get( 'MarketingName' ) );
                        Properties.put( 'AddressLine1', PropertiesInfo.get( 'AddressLine1' ) );
                        Properties.put( 'AddressLine2', PropertiesInfo.get( 'AddressLine2' ) );
                        Properties.put( 'AddressLine3', PropertiesInfo.get( 'AddressLine3' ) );
                        Properties.put( 'City', PropertiesInfo.get( 'City' ) );
                        Properties.put( 'State', PropertiesInfo.get( 'State' ) );
                        Properties.put( 'PostalCode', PropertiesInfo.get( 'PostalCode' ) );
                  		
                        PropConfResponse.put( Code, Properties );                      
                        PropertiesInfo.clear();
                        
                    } else {
                        PropertiesInfo.put( strElementName, parsePropertyConfigurationElement(reader) );
                    }
               	}
           		
			}
          
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        
    }
    
    public String parsePropertyConfigurationElement( XmlStreamReader reader) {
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