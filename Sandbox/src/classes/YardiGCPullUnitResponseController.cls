public class YardiGCPullUnitResponseController {

    public String VersionNumber;
    public Set<String>	UnitCodes						= new Set<String>();
    public Map<String, Map<String, String>> UnitInfo	= new Map<String, Map<String, String>>();
    public JSONGenerator JSONResponseFeeds = JSON.createGenerator(true);
   	
    public void parsePullUnitResponse20( XmlStreamReader reader ) {

        VersionNumber = '2';
        boolean isSafeToGetNextXmlElement 			= true;
        Boolean isUnitStruture 						= false;
        
        String UnitId, DepositType, AmountType, Description, PercentRefundable, VacateDate, MadeReadyDate;
        
        
        Map<String, String>	UnitElements			= new Map<String, String>();
        Map<String, Map<String, String>> Deposit	= new Map<String, Map<String, String>>();
        Map<String, Map<String, Map<String, String>>> DepositDetail = new Map<String, Map<String, Map<String, String>>>();
        
        while( isSafeToGetNextXmlElement ) {               
			
            if (reader.getEventType() == XmlTag.START_ELEMENT) {  
               	String strElementName = reader.getLocalName();
                
                if ( 'ILS_Unit' == strElementName || true == isUnitStruture ) {
                	
                    if( 'ILS_Unit' == strElementName ) {
                      	UnitId = reader.getAttributeValue( null, 'Id' );
                       	UnitCodes.add( UnitId );
                        isUnitStruture = true;
                    	
                    } else if ( 'Deposit' == strElementName ) {
                        DepositType = reader.getAttributeValue( null, 'type' );
                        
                    } else if (	'Amount' == strElementName ) {
                        AmountType = reader.getAttributeValue( null, 'Type' );
                        
                    } else if ( 'Value' == strElementName ) {
                        Map<String, Map<String, String>> temp 	= new Map<String, Map<String, String>>();
                        Map<String, String>	temp2 				= new Map<String, String>();
                        
                        temp2.put( 'Value', String.valueOf( parseUnitFloorPlanElement( reader ) ) );
                        temp.put( AmountType, temp2 );
                        
                       	DepositDetail.put( DepositType, temp );
                    } else if ( 'VacateDate' == strElementName ) {
                        VacateDate = reader.getAttributeValue( null, 'Month' ) + '/' +reader.getAttributeValue( null, 'Day' ) + '/' + reader.getAttributeValue( null, 'Year' );
                    
                    } else if ( 'MadeReadyDate' == strElementName ) {
                        MadeReadyDate = reader.getAttributeValue( null, 'Month' ) + '/' +reader.getAttributeValue( null, 'Day' ) + '/' + reader.getAttributeValue( null, 'Year' );
                 
                    } else if ( 'NonRefundableHoldFee' ==  strElementName ) { 
                    	
                        Map<String, String> tempUnitElement = new Map<String, String >();
                        tempUnitElement.put( 'UnitID', UnitElements.get( 'UnitID' ) );
                        tempUnitElement.put( 'UnitType', UnitElements.get( 'UnitType' ) );
                        tempUnitElement.put( 'UnitBedrooms', UnitElements.get( 'UnitBedrooms' ) );
                        tempUnitElement.put( 'UnitBathrooms', UnitElements.get( 'UnitBathrooms' ) );
                        tempUnitElement.put( 'Comment', UnitElements.get( 'Comment' ) );
                        tempUnitElement.put( 'MinSquareFeet', UnitElements.get( 'MinSquareFeet' ) );
                        tempUnitElement.put( 'MaxSquareFeet', UnitElements.get( 'MaxSquareFeet' ) );
                        tempUnitElement.put( 'MarketRent', UnitElements.get( 'MarketRent' ) );
                        tempUnitElement.put( 'UnitOccupancyStatus', UnitElements.get( 'UnitOccupancyStatus' ) );
                        tempUnitElement.put( 'UnitLeasedStatus', UnitElements.get( 'UnitLeasedStatus' ) );
                        tempUnitElement.put( 'VacateDate', VacateDate );
                        tempUnitElement.put( 'MadeReadyDate', MadeReadyDate );
                        tempUnitElement.put( 'VacancyClass', UnitElements.get( 'VacancyClass' ) );
                        tempUnitElement.put( 'Deposit', DepositDetail.get('deposit').get('Actual').get('Value') );
                        UnitInfo.put( UnitId, tempUnitElement );
                        
                        VacateDate = NULL;
                        MadeReadyDate = NULL;
                        
                        UnitElements.clear();
                        
                    } else {
                        if( 'Unit' == strElementName || 'Information' == strElementName || 'Fee' == strElementName || 'Availability' == strElementName || 'Amenity' == strElementName || 'Description' == strElementName ) {
                            reader.next();
                            continue;
                        }	                       
                        UnitElements.put( strElementName, parseUnitFloorPlanElement( reader ) );
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
    
    public void parsePullUnitResponse40( XmlStreamReader reader ) {

        VersionNumber = '4';
        boolean isSafeToGetNextXmlElement 			= true;
        Boolean isUnitStruture 						= false;
        
        String UnitId, DepositType, AmountType, Description, PercentRefundable, VacateDate, MadeReadyDate;
        
        
        Map<String, String>	UnitElements			= new Map<String, String>();
        Map<String, Map<String, String>> Deposit	= new Map<String, Map<String, String>>();
        Map<String, Map<String, Map<String, String>>> DepositDetail = new Map<String, Map<String, Map<String, String>>>();
        
        while( isSafeToGetNextXmlElement ) {               
			
            if (reader.getEventType() == XmlTag.START_ELEMENT) {  
               	String strElementName = reader.getLocalName();
                
                if ( 'ILS_Unit' == strElementName || true == isUnitStruture ) {
                	
                    if( 'ILS_Unit' == strElementName ) {
                      	UnitId = reader.getAttributeValue( null, 'IDValue' );
                       	UnitCodes.add( UnitId );
                        isUnitStruture = true;
                    	
                    } else if ( 'Deposit' == strElementName ) {
                        DepositType = reader.getAttributeValue( null, 'DepositType' );
                        
                    } else if (	'Amount' == strElementName ) {
                        AmountType = reader.getAttributeValue( null, 'AmountType' );
                        
                    } else if ( 'ValueRange' == strElementName ) {
                        Map<String, Map<String, String>> temp 	= new Map<String, Map<String, String>>();
                        Map<String, String>	temp2 				= new Map<String, String>();
                        
                        temp2.put( 'Value', reader.getAttributeValue( null, 'Exact' ) );
                        temp.put( AmountType, temp2 );
                        
                       	DepositDetail.put( DepositType, temp );
                    } else if ( 'VacateDate' == strElementName ) {
                        VacateDate = reader.getAttributeValue( null, 'Month' ) + '/' +reader.getAttributeValue( null, 'Day' ) + '/' + reader.getAttributeValue( null, 'Year' );
                    
                    } else if ( 'MadeReadyDate' == strElementName ) {
                        MadeReadyDate = reader.getAttributeValue( null, 'Month' ) + '/' +reader.getAttributeValue( null, 'Day' ) + '/' + reader.getAttributeValue( null, 'Year' );
                 
                    } else if ( 'NonRefundableHoldFee' ==  strElementName ) { 
                    	
                        Map<String, String> tempUnitElement = new Map<String, String >();
                        tempUnitElement.put( 'UnitID', UnitId );
                        tempUnitElement.put( 'UnitType', UnitElements.get( 'UnitType' ) );
                        tempUnitElement.put( 'UnitBedrooms', UnitElements.get( 'UnitBedrooms' ) );
                        tempUnitElement.put( 'UnitBathrooms', UnitElements.get( 'UnitBathrooms' ) );
                        tempUnitElement.put( 'Comment', UnitElements.get( 'Comment' ) );
                        tempUnitElement.put( 'MinSquareFeet', UnitElements.get( 'MinSquareFeet' ) );
                        tempUnitElement.put( 'MaxSquareFeet', UnitElements.get( 'MaxSquareFeet' ) );
                        tempUnitElement.put( 'MarketRent', UnitElements.get( 'MarketRent' ) );
                        tempUnitElement.put( 'UnitOccupancyStatus', UnitElements.get( 'UnitOccupancyStatus' ) );
                        tempUnitElement.put( 'UnitLeasedStatus', UnitElements.get( 'UnitLeasedStatus' ) );
                        tempUnitElement.put( 'VacateDate', VacateDate );
                        tempUnitElement.put( 'MadeReadyDate', MadeReadyDate );
                        tempUnitElement.put( 'VacancyClass', UnitElements.get( 'VacancyClass' ) );
                        tempUnitElement.put( 'Deposit', DepositDetail.get('deposit').get('Actual').get('Value') );
                        UnitInfo.put( UnitId, tempUnitElement );
                        
                        VacateDate = NULL;
                        MadeReadyDate = NULL;
                        
                        UnitElements.clear();
                        
                    } else {
                        if( 'Unit' == strElementName || 'Units' == strElementName || 'Fee' == strElementName || 'Availability' == strElementName ) {
                            reader.next();
                            continue;
                        }	                       
                        UnitElements.put( strElementName, parseUnitFloorPlanElement( reader ) );
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
    
    public String parseUnitFloorPlanElement( XmlStreamReader reader) {
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
    
    public void parsePullUnitFeedsResponse( Dom.Document doc) {
        
        Dom.XMLNode Envelope = doc.getRootElement();
	
        for(Dom.XMLNode child : Envelope.getChildElements() ) {
            if( 'Body' == child.getName() ) {
                for(Dom.XMLNode child1 : child.getChildElements() ) { 
                    if( 'UnitAvailability_LoginByUnitResponse' == child1.getName() ) {
                        for(Dom.XMLNode child2 : child1.getChildElements() ) { 
                            if( 'UnitAvailability_LoginByUnitResult' == child2.getName() ) {
                                for(Dom.XMLNode child3 : child2.getChildElements() ) { 
                                    if( 'PhysicalProperty' == child3.getName() ) {
                                        for(Dom.XMLNode child4 : child3.getChildElements() ) { 
                                            if( 'Property' == child4.getName() ) {
                                                JSONResponseFeeds.writeStartObject();
                                                
                                                for(Dom.XMLNode child5 : child4.getChildElements() ) { 
                                                    if( 'ILS_Unit' == child5.getName() ) {
                                                        String UnitCode = child5.getAttributeValue( 'IDValue', null );
                                                        UnitCodes.add( UnitCode );
                                                        
                                                        JSONResponseFeeds.writeFieldName(UnitCode);
                                                        JSONResponseFeeds.writeStartArray();
                                                       
                                                        for(Dom.XMLNode child6 : child5.getChildElements() ) { 
                                                            if( 'Pricing' == child6.getName() ) {
                                                                
                                                                for(Dom.XMLNode child7 : child6.getChildElements() ) { 
                                                                    if( 'MITS-OfferTerm' == child7.getName() ) {
                                                                        String StartDate, EndDate, Term, EffectiveRent;
                                                                        JSONResponseFeeds.writeStartObject(); 
                                                                
                                                                        JSONResponseFeeds.writeFieldName( 'LeaseTerm' );
                                                                        JSONResponseFeeds.writeStartObject();
                                                                        for(Dom.XMLNode child8 : child7.getChildElements() ) { 
                                                                            if( 'EffectiveRent' == child8.getName() ) {
                                                                                JSONResponseFeeds.writeStringField('EffectiveRent', child8.getText());
                                                                            }
                                                                            if( 'Term' == child8.getName() ) {
                                                                                JSONResponseFeeds.writeStringField('Term', child8.getText());
                                                                            }
                                                                            if( 'DateRange' == child8.getName() ) {
                                                                                for(Dom.XMLNode child9 : child8.getChildElements() ) { 
                                                                                    if( 'StartDate' == child9.getName() ) {
                                                                                        if( '' != child9.getAttributeValue( 'Month', null )  && '' != child9.getAttributeValue( 'Day', null ) && '' != child9.getAttributeValue( 'Year', null ) ) {
                                                                                            JSONResponseFeeds.writeStringField('StartDate', child9.getAttributeValue( 'Month', null ) + '/' + child9.getAttributeValue( 'Day', null ) + '/' + child9.getAttributeValue( 'Year', null ) );
                                                                                        }
                                                                                    }
                                                                                    if( 'EndDate' == child9.getName() ) {
                                                                                        if( '' != child9.getAttributeValue( 'Month', null )  && '' != child9.getAttributeValue( 'Day', null ) && '' != child9.getAttributeValue( 'Year', null ) ) {
                                                                                            JSONResponseFeeds.writeStringField('EndDate', child9.getAttributeValue( 'Month', null ) + '/' + child9.getAttributeValue( 'Day', null ) + '/' + child9.getAttributeValue( 'Year', null ) );
                                                                                        }
                                                                                    } 
                                                                                }
                                                                            }
                                                                            
                                                                        } 
                                                                        JSONResponseFeeds.writeEndObject();
                                                                        JSONResponseFeeds.writeEndObject();
                                                                    }
                                                                }
                                                                
                                                            }
                                                        }
                                                       	JSONResponseFeeds.writeEndArray();
                                                        
                                                    }
                                                }
                                                JSONResponseFeeds.writeEndObject();
                                                //System.debug( JSONResponseFeeds.getAsString() );
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