public class YardiGCPullFloorPlanResponseController {
	
    public Set<String> FloorPlanCodes 	= new Set<String>();
     
    public Map<String, Map<String, String>> FloorPlanInfo 					= new Map<String, Map<String, String>>();
    public Map<String, Map<String, Map<String, String>>> FloorPlanRoomInfo	= new Map<String, Map<String, Map<String, String>>>();
    public Map<String, Map<String, Map<String, Map<String, String>>>> FloorPlanDepositInfo	= new Map<String, Map<String, Map<String, Map<String, String>>>>();
    
    public void parsePullFloorPlanResponse20( XmlStreamReader reader ) {
        
        Boolean isSafeToGetNextXmlElement 			= true;
        Boolean isFloorPlanStruture 				= false;
        
        String FloorPlanId, RoomType ,RoomCount, DepositType, AmountType ;
       	
        Map<String, String> FloorPlansElement 		= new Map<String, String>();
		Map<String, Map<String, String>> Rooms		= new Map<String, Map<String, String>>();
        
        Map<String, Map<String, Map<String, String>>> DepositDetail = new Map<String, Map<String, Map<String, String>>>();
        
        while( isSafeToGetNextXmlElement ) {               

            if (reader.getEventType() == XmlTag.START_ELEMENT) {  
               	String strElementName = reader.getLocalName();
               	
               //building floorplan structure
               //if( isFloorPlanStructure(strElementName, isFloorPlanStruture) ) {  
               if ( 'Floorplan' == strElementName || true == isFloorPlanStruture ) {
                    if( 'Floorplan' == strElementName ) {
                      	FloorPlanId = reader.getAttributeValue( null, 'Id' );
                       	FloorPlanCodes.add( FloorPlanId );
                        isFloorPlanStruture = true;
                    	
                    } else if ( 'Room' == strElementName ) {
                        RoomType = reader.getAttributeValue( null, 'Type' );
                        
                    } else if ( 'Count' == strElementName ) {
                       	RoomCount = String.valueOf( parseFloorPlanElement( reader ) );
                        
                    } else if ( 'Comment' == strElementName ) {
                        Map<String, String> temp = new Map<String, String>();
                        temp.put( 'Comment', String.valueOf( parseFloorPlanElement( reader ) ) );
                        temp.put( 'Count', RoomCount );
                        Rooms.put( RoomType, temp );
                        
                    } else if ( 'SquareFeet' == strElementName ) {
                        FloorPlansElement.put( 'SquareFeetMin', String.valueOf( reader.getAttributeValue( null, 'Min' ) ) );
                        FloorPlansElement.put( 'SquareFeetMax', String.valueOf( reader.getAttributeValue( null, 'Max' ) ) );
                        
                    } else if ( 'MarketRent' == strElementName ) {
                       	FloorPlansElement.put( 'MarketRentMin', String.valueOf( reader.getAttributeValue( null, 'Min' ) ) );
                        FloorPlansElement.put( 'MarketRentMax', String.valueOf( reader.getAttributeValue( null, 'Max' ) ) );
                        
                    } else if ( 'EffectiveRent' == strElementName ) {
                        FloorPlansElement.put( 'EffectiveRentMin', String.valueOf( reader.getAttributeValue( null, 'Min' ) ) );
                        FloorPlansElement.put( 'EffectiveRentMax', String.valueOf( reader.getAttributeValue( null, 'Max' ) ) );
                    } else if ( 'Deposit' == strElementName ) {
                        DepositType = reader.getAttributeValue( null, 'type' );
                        
                    } else if ( 'Amount' == strElementName ) { 
                        AmountType = reader.getAttributeValue( null, 'Type' );
                        
                    } else if ( 'Value' == strElementName ) {
                        Map<String, Map<String, String>> temp 	= new Map<String, Map<String, String>>();
                        Map<String, String>	temp2 				= new Map<String, String>();
                        
                        temp2.put( 'Value', String.valueOf( parseFloorPlanElement( reader ) ) );
                        temp.put( AmountType, temp2 );
                        
                       	DepositDetail.put( DepositType, temp );
                        
                    } else if( 'ApplicationFee' == strElementName ) {
                        FloorPlansElement.put( 'ApplicationFee', parseFloorPlanElement( reader ) );
                        
                        Map<String, String> tempFloorPlansElement = new Map<String, String >();
                        tempFloorPlansElement.put( 'Name', FloorPlansElement.get( 'Name' ) );
                        tempFloorPlansElement.put( 'UnitCount', FloorPlansElement.get( 'UnitCount' ) );
                        tempFloorPlansElement.put( 'SquareFeetMin', FloorPlansElement.get( 'SquareFeetMin' ) );
                        tempFloorPlansElement.put( 'SquareFeetMax', FloorPlansElement.get( 'SquareFeetMax' ) );
                        tempFloorPlansElement.put( 'MarketRentMin', FloorPlansElement.get( 'MarketRentMin' ) );
                        tempFloorPlansElement.put( 'MarketRentMax', FloorPlansElement.get( 'MarketRentMax' ) );
                        tempFloorPlansElement.put( 'EffectiveRentMin', FloorPlansElement.get( 'EffectiveRentMin' ) );
                        tempFloorPlansElement.put( 'EffectiveRentMax', FloorPlansElement.get( 'EffectiveRentMax' ) );
                        tempFloorPlansElement.put( 'ProrateType', FloorPlansElement.get( 'ProrateType' ) );
                        tempFloorPlansElement.put( 'LateType', FloorPlansElement.get( 'LateType' ) );
                        tempFloorPlansElement.put( 'LatePercent', FloorPlansElement.get( 'LatePercent' ) );
                        tempFloorPlansElement.put( 'LateMinFee', FloorPlansElement.get( 'LateMinFee' ) );
                        tempFloorPlansElement.put( 'LateFeePerDay', FloorPlansElement.get( 'LateFeePerDay' ) );
                        tempFloorPlansElement.put( 'NonRefundableHoldFee', FloorPlansElement.get( 'NonRefundableHoldFee' ) );
                        tempFloorPlansElement.put( 'AdminFee', FloorPlansElement.get( 'AdminFee' ) );
                        tempFloorPlansElement.put( 'ApplicationFee', FloorPlansElement.get( 'ApplicationFee' ) );
                        if( false == DepositDetail.isEmpty() && true == DepositDetail.containsKey('deposit') ) {
                        	tempFloorPlansElement.put( 'Deposit', DepositDetail.get('deposit').get('Actual').get('Value') );
                        }
                        tempFloorPlansElement.put( 'Bedroom', Rooms.get( 'Bedroom' ).get('Count') );
                        tempFloorPlansElement.put( 'Bathroom', Rooms.get( 'Bathroom' ).get('Count') );
 
                        Map<String, Map<String, String>> tempRooms = new Map<String, Map<String, String>>();
                        
                        for( String Roomtypekey: Rooms.keySet() ) {
                            tempRooms.put( Roomtypekey, Rooms.get(Roomtypekey) );
                        }
                        
                        FloorPlanInfo.put( FloorPlanId, tempFloorPlansElement );
                        FloorPlanRoomInfo.put( FloorPlanId, tempRooms );
                        FloorPlansElement.clear();
                        Rooms.clear();
                        
                        Map<String, Map<String, Map<String, String>>> tempDepositDetails 	= new Map<String, Map<String, Map<String, String>>>();
                        Map<String, Map<String,String>> tempDepositDetails2 				= new Map<String, Map<String,String>>();
                        
                        for( String DepositTypekey: DepositDetail.keySet() ) {
                            for( String AmountTypeKey:DepositDetail.get(DepositTypekey).keySet() ) {
                                tempDepositDetails2.put( AmountTypeKey, DepositDetail.get(DepositTypekey).get(AmountTypeKey) );
                                if( tempDepositDetails.containsKey(DepositTypekey) )
                                	tempDepositDetails2.putAll( tempDepositDetails.get( DepositTypekey ) );
                                tempDepositDetails.put( DepositTypekey, tempDepositDetails2 );
                            }
                        }
						
						FloorPlanDepositInfo.put( FloorPlanId, tempDepositDetails );
                        DepositDetail.clear();
                       	
                    } else { 
                        if( 'Fee' != strElementName ) {
                       		FloorPlansElement.put( strElementName, parseFloorPlanElement( reader ) );
                       }
                    }
                } else if( 'ILS_Unit' == strElementName ) {
                    isFloorPlanStruture = false;                    
                }
                //End of Floor Plan Structure
                
           	}
          
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
    }
    
    public void parsePullFloorPlanResponse40( XmlStreamReader reader ) {
        
        Boolean isSafeToGetNextXmlElement 			= true;
        Boolean isFloorPlanStruture 				= false;
        
        String FloorPlanId, RoomType ,RoomCount, DepositType, AmountType ;
       	
        Map<String, String> FloorPlansElement 		= new Map<String, String>();
		Map<String, Map<String, String>> Rooms		= new Map<String, Map<String, String>>();
        
        Map<String, Map<String, Map<String, String>>> DepositDetail = new Map<String, Map<String, Map<String, String>>>();
        
        while( isSafeToGetNextXmlElement ) {               

            if (reader.getEventType() == XmlTag.START_ELEMENT) {  
               	String strElementName = reader.getLocalName();
               	
               //building floorplan structure
               //if( isFloorPlanStructure(strElementName, isFloorPlanStruture) ) {  
               if ( 'Floorplan' == strElementName || true == isFloorPlanStruture ) {
                   
                   if( 'Floorplan' == strElementName ) {
                      	FloorPlanId = reader.getAttributeValue( null, 'IDValue' );
                       	FloorPlanCodes.add( FloorPlanId );
                        
                        isFloorPlanStruture = true;
                    	
                    } else if ( 'Room' == strElementName ) {
                        RoomType = reader.getAttributeValue( null, 'RoomType' );
                        
                    } else if ( 'Count' == strElementName ) {
                       	RoomCount = String.valueOf( parseFloorPlanElement( reader ) );
                        
                    } else if ( 'Comment' == strElementName ) {
                        Map<String, String> temp = new Map<String, String>();
                        temp.put( 'Comment', String.valueOf( parseFloorPlanElement( reader ) ) );
                        temp.put( 'Count', RoomCount );
                        Rooms.put( RoomType, temp );
                        
                    } else if ( 'SquareFeet' == strElementName ) {
                        FloorPlansElement.put( 'SquareFeetMin', String.valueOf( reader.getAttributeValue( null, 'Min' ) ) );
                        FloorPlansElement.put( 'SquareFeetMax', String.valueOf( reader.getAttributeValue( null, 'Max' ) ) );
                        
                    } else if ( 'MarketRent' == strElementName ) {
                       	FloorPlansElement.put( 'MarketRentMin', String.valueOf( reader.getAttributeValue( null, 'Min' ) ) );
                        FloorPlansElement.put( 'MarketRentMax', String.valueOf( reader.getAttributeValue( null, 'Max' ) ) );
                        
                    } else if ( 'EffectiveRent' == strElementName ) {
                        FloorPlansElement.put( 'EffectiveRentMin', String.valueOf( reader.getAttributeValue( null, 'Min' ) ) );
                        FloorPlansElement.put( 'EffectiveRentMax', String.valueOf( reader.getAttributeValue( null, 'Max' ) ) );
                    } else if ( 'Deposit' == strElementName ) {
                        DepositType = reader.getAttributeValue( null, 'DepositType' );
                        
                    } else if ( 'Amount' == strElementName ) { 
                        AmountType = reader.getAttributeValue( null, 'AmountType' );
                        
                    } else if ( 'ValueRange' == strElementName ) {
                        Map<String, Map<String, String>> temp 	= new Map<String, Map<String, String>>();
                        Map<String, String>	temp2 				= new Map<String, String>();
                        
                        temp2.put( 'Value', reader.getAttributeValue( null, 'Exact' ) );
                        temp.put( AmountType, temp2 );
                        
                       	DepositDetail.put( DepositType, temp );
                        
                    } else if( 'BrokerFee' == strElementName ) {
                        FloorPlansElement.put( 'BrokerFee', parseFloorPlanElement( reader ) );
                        
                        Map<String, String> tempFloorPlansElement = new Map<String, String >();
                        tempFloorPlansElement.put( 'Name', FloorPlansElement.get( 'Name' ) );
                        tempFloorPlansElement.put( 'UnitCount', FloorPlansElement.get( 'UnitCount' ) );
                        tempFloorPlansElement.put( 'SquareFeetMin', FloorPlansElement.get( 'SquareFeetMin' ) );
                        tempFloorPlansElement.put( 'SquareFeetMax', FloorPlansElement.get( 'SquareFeetMax' ) );
                        tempFloorPlansElement.put( 'MarketRentMin', FloorPlansElement.get( 'MarketRentMin' ) );
                        tempFloorPlansElement.put( 'MarketRentMax', FloorPlansElement.get( 'MarketRentMax' ) );
                        tempFloorPlansElement.put( 'EffectiveRentMin', FloorPlansElement.get( 'EffectiveRentMin' ) );
                        tempFloorPlansElement.put( 'EffectiveRentMax', FloorPlansElement.get( 'EffectiveRentMax' ) );
                        tempFloorPlansElement.put( 'ProrateType', FloorPlansElement.get( 'ProrateType' ) );
                        tempFloorPlansElement.put( 'LateType', FloorPlansElement.get( 'LateType' ) );
                        tempFloorPlansElement.put( 'LatePercent', FloorPlansElement.get( 'LatePercent' ) );
                        tempFloorPlansElement.put( 'LateMinFee', FloorPlansElement.get( 'LateMinFee' ) );
                        tempFloorPlansElement.put( 'LateFeePerDay', FloorPlansElement.get( 'LateFeePerDay' ) );
                        tempFloorPlansElement.put( 'NonRefundableHoldFee', FloorPlansElement.get( 'NonRefundableHoldFee' ) );
                        tempFloorPlansElement.put( 'AdminFee', FloorPlansElement.get( 'AdminFee' ) );
                        tempFloorPlansElement.put( 'ApplicationFee', FloorPlansElement.get( 'ApplicationFee' ) );
                        tempFloorPlansElement.put( 'BrokerFee', FloorPlansElement.get( 'BrokerFee' ) );
                        if( false == DepositDetail.isEmpty() && true == DepositDetail.containsKey('deposit') ) {
                        	tempFloorPlansElement.put( 'Deposit', DepositDetail.get('deposit').get('Actual').get('Value') );
                        }
                        tempFloorPlansElement.put( 'Bedroom', Rooms.get( 'Bedroom' ).get('Count') );
                        tempFloorPlansElement.put( 'Bathroom', Rooms.get( 'Bathroom' ).get('Count') );
 
                        Map<String, Map<String, String>> tempRooms = new Map<String, Map<String, String>>();
                        
                        for( String Roomtypekey: Rooms.keySet() ) {
                            tempRooms.put( Roomtypekey, Rooms.get(Roomtypekey) );
                        }
                        
                        FloorPlanInfo.put( FloorPlanId, tempFloorPlansElement );
                        FloorPlanRoomInfo.put( FloorPlanId, tempRooms );
                        FloorPlansElement.clear();
                        Rooms.clear();
                        
                        Map<String, Map<String, Map<String, String>>> tempDepositDetails 	= new Map<String, Map<String, Map<String, String>>>();
                        Map<String, Map<String,String>> tempDepositDetails2 				= new Map<String, Map<String,String>>();
                        
                        for( String DepositTypekey: DepositDetail.keySet() ) {
                            for( String AmountTypeKey:DepositDetail.get(DepositTypekey).keySet() ) {
                                tempDepositDetails2.put( AmountTypeKey, DepositDetail.get(DepositTypekey).get(AmountTypeKey) );
                                if( tempDepositDetails.containsKey(DepositTypekey) )
                                	tempDepositDetails2.putAll( tempDepositDetails.get( DepositTypekey ) );
                                tempDepositDetails.put( DepositTypekey, tempDepositDetails2 );
                            }
                        }
						
						FloorPlanDepositInfo.put( FloorPlanId, tempDepositDetails );
                        DepositDetail.clear();
                       	
                    } else { 
                        if( 'Fee' != strElementName ) {
                       		FloorPlansElement.put( strElementName, parseFloorPlanElement( reader ) );
                       }
                    }
                } else if( 'ILS_Unit' == strElementName ) {
                    isFloorPlanStruture = false;                    
                }
                //End of Floor Plan Structure
                
           	}
          
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
    }
    
    public String parseFloorPlanElement( XmlStreamReader reader) {
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