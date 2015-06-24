public class RMPullUnitsResponseController {
    public Map<String, Map<String, String>> UnitsBasicInfo = new Map<String, Map<String, String>>();
    public Set<String> UnitCodes = new Set<String>();
    public Map<String, Map<String, Map<String, String>>> DepositInfo = new Map<String, Map<String, Map<String, String>>>();
    public Map<String, Map<String, String>> OfferTerms = new Map<String, Map<String, String>>();
    
    public void parseUnitResponse( XmlStreamReader reader ) {
        
        boolean isSafeToGetNextXmlElement = true;
        String UnitCode, RoomType, DepositType, AmountType, ValueRange, Description, PercentRefundable, PortionRefundable, EffectiveRent; 
        Boolean isValidIdentification = true;
        
        Set<String> basicValidElements 	= new Set<String>{ 'MarketingName','UnitType', 'UnitBedrooms', 'UnitBathrooms', 'MinSquareFeet', 'MaxSquareFeet', 'MarketRent', 'UnitEconomicStatus', 'UnitOccupancyStatus', 'UnitLeasedStatus', 'FloorplanName', 'BuildingName', 'AddressLine1', 'AddressLine2', 'City', 'State', 'PostalCode', 'FloorLevel', 'VacancyClass' };
        Set<String> InvalidElements 	= new Set<String>{ 'PhysicalProperty', 'Property', 'ILS_Unit', 'Identification', 'Units', 'Unit', 'Address', 'MITS-OfferTerm', 'Term', 'EffectiveRent', 'Deposit', 'Amount', 'ValueRange', 'Description', 'PercentRefundable', 'PortionRefundable', 'Availability', 'VacateDate', 'MadeReadyDate' };
        
        Map<String, String> tempUnitInfo = new Map<String, String>();
        Map<String, String> tempOfferTermInfo =  new Map<String, String>();
        
       	while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {  
                String strElementName = reader.getLocalName();
                
                if( InvalidElements.contains(strElementName) ) {
                    if( 'Identification' == strElementName ) {
                        if( false == isValidIdentification ) {
                            if( null != UnitCode ) {
                                Map<String, String> temp = new Map<String, String>();
                                for( String key : tempUnitInfo.keySet() ) {
                                    temp.put( key, tempUnitInfo.get(key) );
                                }
                                
                                UnitsBasicInfo.put( UnitCode, temp );
                                tempUnitInfo.clear();
                                
                                Map<String, String> temp2 = new Map<String, String>();
                                for( String key: tempOfferTermInfo.keySet() ) {
                                    temp2.put( key, tempOfferTermInfo.get(key) );
                                }
                                
                                OfferTerms.put( UnitCode, temp2 );
                                tempOfferTermInfo.clear();
                            }
                            
                            UnitCode = reader.getAttributeValue( null, 'IDValue' );
                            UnitCodes.add( UnitCode );
                            isValidIdentification = true;
                        } else {
                            isValidIdentification = false;
                        }
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
                        if( !DepositInfo.containsKey( UnitCode ) ) {
                            tempDepositInfo.put( DepositType, tempDepositMap ); 
                            DepositInfo.put( UnitCode, tempDepositInfo );                            
                        } else {
                            tempDepositInfo.putAll( DepositInfo.get(UnitCode) );
                            tempDepositInfo.put( DepositType, tempDepositMap ); 
                            DepositInfo.put( UnitCode, tempDepositInfo );                            
                        }    
                    } else if ( 'VacateDate' == strElementName ) {
                        String VacateDate = reader.getAttributeValue( null, 'Month' ) + '/' +reader.getAttributeValue( null, 'Day' ) + '/' + reader.getAttributeValue( null, 'Year' );
                    	tempUnitInfo.put( strElementName, VacateDate );
                    } else if ( 'MadeReadyDate' == strElementName ) {
                        String MadeReadyDate = reader.getAttributeValue( null, 'Month' ) + '/' +reader.getAttributeValue( null, 'Day' ) + '/' + reader.getAttributeValue( null, 'Year' );
                    	tempUnitInfo.put( strElementName, MadeReadyDate );
                    } else if ( 'EffectiveRent' == strElementName ) {
                        if( 0 < reader.getAttributeCount() ) {
                            tempUnitInfo.put( 'EffectiveRentAvg', reader.getAttributeValue( null, 'Avg' ) );
                            tempUnitInfo.put( 'EffectiveRentMin', reader.getAttributeValue( null, 'Min' ) );
                            tempUnitInfo.put( 'EffectiveRentMax', reader.getAttributeValue( null, 'Max' ) );
                        } else {
                            EffectiveRent = parseResponseElement(reader);
                        }
                    } else if ( 'Term' == strElementName ) {
                        tempOfferTermInfo.put( parseResponseElement(reader), EffectiveRent );
					}            
                    
                    reader.next();
                    continue;
                } else if( basicValidElements.contains(strElementName) ) {
                    tempUnitInfo.put( strElementName, parseResponseElement(reader) );
                }
            } 
            
            if (reader.hasNext() ) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        
        if( null != UnitCode && !tempUnitInfo.isEmpty() ) {
            UnitsBasicInfo.put( UnitCode, tempUnitInfo );
            OfferTerms.put( UnitCode, tempOfferTermInfo );
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