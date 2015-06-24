public class RMPullFloorPlansResponseController {
    public Map<String, Map<String, String>> FloorPlansBasicInfo = new Map<String, Map<String, String>>();
    public Set<String> FloorPlanCodes = new Set<String>();
    public Map<String, Map<String, Map<String, String>>> DepositInfo = new Map<String, Map<String, Map<String, String>>>();
    
    public void parseFloorPlanResponse( XmlStreamReader reader ) {
        
        boolean isSafeToGetNextXmlElement = true;
        String FloorPlanCode, RoomType, DepositType, AmountType, ValueRange, Description, PercentRefundable, PortionRefundable; 
        boolean isName = false;
        Set<String> basicValidElements 	= new Set<String>{ 'Name','UnitCount', 'UnitsAvailable', 'Count' };
        Set<String> InvalidElements 	= new Set<String>{ 'ResMan', 'Response', 'PhysicalProperty', 'Property', 'Floorplan', 'Room', 'Deposit', 'Amount', 'Identification', 'SquareFeet', 'MarketRent', 'EffectiveRent', 'ValueRange', 'Description', 'PercentRefundable', 'PortionRefundable' };
        Map<String, String> tempFloorPlanInfo = new Map<String, String>();
        
        
       	while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {  
                String strElementName = reader.getLocalName();
                
                if( InvalidElements.contains(strElementName) ) {
                    if( 'Identification' == strElementName ) {
                        if( null != FloorPlanCode ) {
                            Map<String, String> temp = new Map<String, String>();
                            for( String key : tempFloorPlanInfo.keySet() ) {
                                temp.put( key, tempFloorPlanInfo.get(key) );
                            }
                            FloorPlansBasicInfo.put( FloorPlanCode, temp );
                            tempFloorPlanInfo.clear();
                        } 
                       	isName = false;
                        FloorPlanCode = reader.getAttributeValue( null, 'IDValue' );
                        FloorPlanCodes.add( FloorPlanCode );
                    } else if( 'Room' == strElementName ) {
                        RoomType = reader.getAttributeValue( null, 'RoomType' );
                    } else if( 'SquareFeet' == strElementName ) {
                        tempFloorPlanInfo.put( 'SquareFeetAvg', reader.getAttributeValue( null, 'Avg' ) );
                        tempFloorPlanInfo.put( 'SquareFeetMin', reader.getAttributeValue( null, 'Min' ) );
                        tempFloorPlanInfo.put( 'SquareFeetMax', reader.getAttributeValue( null, 'Max' ) );
                    } else if( 'MarketRent' == strElementName ) {
                        tempFloorPlanInfo.put( 'MarketRentMin', reader.getAttributeValue( null, 'Min' ) );
                        tempFloorPlanInfo.put( 'MarketRentMax', reader.getAttributeValue( null, 'Max' ) );
                    } else if( 'EffectiveRent' == strElementName ) {
                        tempFloorPlanInfo.put( 'EffectiveRentAvg', reader.getAttributeValue( null, 'Avg' ) );
                        tempFloorPlanInfo.put( 'EffectiveRentMin', reader.getAttributeValue( null, 'Min' ) );
                        tempFloorPlanInfo.put( 'EffectiveRentMax', reader.getAttributeValue( null, 'Max' ) );
                    } else if( 'Deposit' == strElementName ) {
                        DepositType = reader.getAttributeValue( null, 'DepositType' );
                    } else if( 'Amount' == strElementName ) {
                    	AmountType = reader.getAttributeValue( null, 'AmountType' );
                    } else if( 'ValueRange' == strElementName ) {
                    	ValueRange = reader.getAttributeValue( null, 'Exact' );
                    } else if( 'Description' == strElementName ) {
                        Description = parseResponseElement(reader);
                    } else if( 'PercentRefundable' == strElementName ) {
                        PercentRefundable = parseResponseElement(reader);
                    } else if( 'PortionRefundable' == strElementName ) {
                        PortionRefundable = parseResponseElement(reader);
                        
                        Map<String, String> tempDepositMap = new Map<String, String>();
                        tempDepositMap.put( AmountType, ValueRange );
                        tempDepositMap.put( 'Description', Description );
                        tempDepositMap.put( 'PercentRefundable', PercentRefundable );
                        tempDepositMap.put( 'PortionRefundable', PortionRefundable );
                        
                        Map<String, Map<String, String>> tempDepositInfo = new Map<String, Map<String, String>>();
                        if( !DepositInfo.containsKey( FloorPlanCode ) ) {
                            tempDepositInfo.put( DepositType, tempDepositMap ); 
                            DepositInfo.put( FloorPlanCode, tempDepositInfo );                            
                        } else {
                            tempDepositInfo.putAll( DepositInfo.get(FloorPlanCode) );
                            tempDepositInfo.put( DepositType, tempDepositMap ); 
                            DepositInfo.put( FloorPlanCode, tempDepositInfo );                            
                        }    
                    }
                    
                    reader.next();
                    continue;
                } else if( basicValidElements.contains(strElementName) ) {
                    if( 'Count' == strElementName ) {
                        tempFloorPlanInfo.put( RoomType, parseResponseElement(reader) );
                        RoomType = null;
                    } else if( 'Name' == strElementName ) {
                        if( false == isName ) {
                            tempFloorPlanInfo.put( strElementName, parseResponseElement(reader) );
                            isName = true;
                        } else {
                            String t = parseResponseElement(reader); 
                        }
                         
                    } else {
                        tempFloorPlanInfo.put( strElementName, parseResponseElement(reader) );
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
        
        if( null != FloorPlanCode && !tempFloorPlanInfo.isEmpty() ) {
            
            FloorPlansBasicInfo.put( FloorPlanCode, tempFloorPlanInfo );
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