public class RMPullPropertiesResponseController {
    public Map<String, String> PropertiesBasicInfo 	= new Map<String, String>();
    
    public void parsePropertyResponse( XmlStreamReader reader ) {
        
        boolean isSafeToGetNextXmlElement = true;
        String Code, PhoneType, OpenTime, CloseTime, Day; 
        Set<String> basicValidElements 	= new Set<String>{ 'MarketingName', 'WebSite','City', 'State', 'PostalCode', 'Country', 'PhoneNumber', 'Email', 'Latitude', 'Longitude', 'StructureType', 'BuildingCount', 'UnitCount', 'ShortDescription', 'LongDescription', 'ProrateType', 'LateType', 'LatePercent', 'LateMinFee', 'LateFeePerDay', 'NonRefundableHoldFee', 'AdminFee', 'ApplicationFee', 'BrokerFee', 'OpenTime', 'CloseTime', 'Day' };
        Set<String> InvalidElements 	= new Set<String>{ 'ResMan', 'Response', 'PhysicalProperty', 'Property', 'PropertyID', 'Address', 'Phone', 'ILS_Identification', 'Information', 'OfficeHour', 'Parking', 'Services', 'Fee', 'Amenity', 'Building', 'Utility', 'OfficeHour', 'File', 'Amenity' };
                
       	while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {  
                String strElementName = reader.getLocalName();
                
                if( InvalidElements.contains(strElementName) ) {
                    if( 'Phone' == strElementName ) {
                        PhoneType = reader.getAttributeValue( null, 'PhoneType' );
                    } else if( 'Amenity' == strElementName ) {
                        String Amenity = reader.getAttributeValue( null, 'AmenityType' );
                        if( PropertiesBasicInfo.containsKey( strElementName ) ) {
                            Amenity = PropertiesBasicInfo.get( strElementName ) + ', '+ Amenity;
                        } 
                        PropertiesBasicInfo.put( strElementName, Amenity );
                    }
                    reader.next();
                    continue;
                } else if( basicValidElements.contains(strElementName) ) {
                    if( 'PhoneNumber' == strElementName ) {
                        PropertiesBasicInfo.put( PhoneType+strElementName, parseResponseElement(reader) );
                    } else if( 'OpenTime' == strElementName ) {
                        OpenTime 	= parseResponseElement(reader);
                    } else if( 'CloseTime' == strElementName ) {
                        CloseTime 	= parseResponseElement(reader);
                    } else if( 'Day' == strElementName ) {
                        Day 		= parseResponseElement(reader);
                        String strTime = OpenTime + ' - ' + CloseTime;
                        if( PropertiesBasicInfo.containsKey( Day ) ) {
                            strTime = PropertiesBasicInfo.get(Day) + ', ' + strTime; 
                        }
                        PropertiesBasicInfo.put( Day, strTime );
                    } else {
                        PropertiesBasicInfo.put( strElementName, parseResponseElement(reader) );
                    }
                    
                }
            } 
            
            if (reader.hasNext() ) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        
    }
    
    public String parseResponseElement( XmlStreamReader reader) {
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