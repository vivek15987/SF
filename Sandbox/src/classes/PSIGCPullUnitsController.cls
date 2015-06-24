public with sharing class PSIGCPullUnitsController {
    
    public String strUnitAvailability_Login;
    public List<Unit__c> arrobjUnits = new List<Unit__c>();
    public PSIGCPullUnitsController() {}
    
    public Set<ID> AccountIds							= new Set<ID>();
    public Set<ID> PropertyIds 							= new Set<ID>();
    public Set<ID> FloorPlanIds 						= new Set<ID>();
    
    public void PSIGCPullUnits() {
        if( !AccountIds.isEmpty() ) {
            List<Integration__c> searchList = [ SELECT 
                                               Account__c, Name, Grouping__c, PSI_Password__c, PSI_Username__c, PSI_API_URL__c, Deactivate_units_not_returned_in_feed__c,New_LRO_Setting__c,PSI_Integration_Active__c, Get_PSI_Unit_Availability__c, Uses_Yieldstar__c, PSI_Active_Unit_Statues__c, PSI_InActive_Unit_Statues__c, PSI_Active_No_Showings_Unit_Statues__c
                                               FROM
                                               Integration__c
                                               WHERE
                                               Account__c IN : AccountIds
                                               AND PSI_Integration_Active__c = true
                                               AND Get_PSI_Unit_Availability__c != null
                                              ];
            
            Set<String> AccountIds = new Set<String>();
            Set<String> GroupingIds = new Set<String>();
            
            Map<String, Map<String, String>> IntegrationCredentials = new  Map<String, Map<String, String>>();
            
            if( !searchList.isEmpty() ) {
                for( Integration__c I :searchList ) { 
                    if( I.PSI_Integration_Active__c == true && I.Get_PSI_Unit_Availability__c != null ) {
                        Map<String, String> tempIntegrationCredentials = new Map<String, String>();
                        tempIntegrationCredentials.put( 'PSI_Username', I.PSI_Username__c );
                        tempIntegrationCredentials.put( 'PSI_Password', I.PSI_Password__c );
                        tempIntegrationCredentials.put( 'PSI_API_URL', I.PSI_API_URL__c );
                        tempIntegrationCredentials.put( 'DeactiveUnits', ( true == I.Deactivate_units_not_returned_in_feed__c ? 'Yes' : 'No' ) );
                        tempIntegrationCredentials.put( 'Uses_Yieldstar', ( true == I.Uses_Yieldstar__c ? 'Yes' : 'No' ) );
                        tempIntegrationCredentials.put( 'Unit_Status_Active', I.PSI_Active_Unit_Statues__c );
                        tempIntegrationCredentials.put( 'Unit_Status_InActive', I.PSI_InActive_Unit_Statues__c );
                        tempIntegrationCredentials.put( 'Unit_Status_Active_No_Showings', I.PSI_Active_No_Showings_Unit_Statues__c );
                        if( null != I.New_LRO_Setting__c )
                            tempIntegrationCredentials.put( 'New LRO Setting', I.New_LRO_Setting__c );
                        
                        if( null != I.Grouping__c && !GroupingIds.contains( I.Grouping__c ) ) {
                            GroupingIds.add( I.Grouping__c );
                            IntegrationCredentials.put( I.Grouping__c, tempIntegrationCredentials );
                        } else if( !AccountIds.contains( I.Account__c ) ) {
                            AccountIds.add( I.Account__c );
                            IntegrationCredentials.put( I.Account__c, tempIntegrationCredentials );
                        }
                    }
                    
                }
                
                List<Property__c> fetchedProperties = new List<Property__c>();
                
                fetchedProperties = [SELECT 
                                     Id, Name, Account__c, Account__r.Name, PSI_Prop_ID__c, Group_Membership__c, Group_Membership__r.Name,
                                     ( SELECT Id, PSI_Floor_Plan_ID__c FROM Floor_Plans__r WHERE PSI_Floor_Plan_ID__c != NULL AND Id IN :FloorPlanIds )
                                     FROM 
                                     Property__c 
                                     WHERE
                                     Id IN :PropertyIds
                                    ];
                
                
                for( Property__c Property : fetchedProperties ) {
                    
                    try{ 
                        Boolean IsLROPriceActive = false;
                        Boolean IsLROPriceAndAvailabilityActive = false;
                        
                        Map<String, String> strCredentials = new Map<String, String>();
                        if( null != Property.Group_Membership__c && IntegrationCredentials.containsKey( Property.Group_Membership__c ) ) {
                            strCredentials = IntegrationCredentials.get( Property.Group_Membership__c );
                            if( IntegrationCredentials.get( Property.Group_Membership__c ).containsKey( 'New LRO Setting' ) ) {
                                if( 'Price' == IntegrationCredentials.get( Property.Group_Membership__c ).get( 'New LRO Setting' ) ) {
                                    IsLROPriceActive = true;
                                } else if ( 'Price and Availability' == IntegrationCredentials.get( Property.Group_Membership__c ).get( 'New LRO Setting' ) ) {
                                    IsLROPriceActive = true;
                                    IsLROPriceAndAvailabilityActive = true;
                                }
                            }
                        } else if( IntegrationCredentials.containsKey( Property.Account__c ) ) {
                            strCredentials = IntegrationCredentials.get( Property.Account__c );
                        }
                        
                        Boolean isDeactivateUnits = false;
                        List<Unit__c> Units = new List<Unit__c>();
                        Set<Id> arrProcessedUnits = new Set<Id>();
                        
                        if( !strCredentials.isEmpty() ) { 
                            this.getUnitsAvailabilityAndPricing( strCredentials.get( 'PSI_Username' ), strCredentials.get( 'PSI_Password' ), Property.PSI_Prop_ID__c, strCredentials.get( 'PSI_API_URL' ) );
                            
                            if( null != strUnitAvailability_Login ) {
                                if( 'Yes' == strCredentials.get( 'DeactiveUnits' ) )
                                    isDeactivateUnits = true;
                                
                                Map<String, Object> JSONdeserializedResponse = (Map<String, Object>) JSON.deserializeUntyped( strUnitAvailability_Login );
                                
                                if( JSONdeserializedResponse.containsKey( 'response' ) ) {
                                    JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('response');
                                    if( JSONdeserializedResponse.containsKey( 'result' ) ) {
                                        try {
                                            JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('result');
                                        } catch( Exception e ) {
                                            System.debug( e.getMessage() );
                                            System.debug( e.getStackTraceString() );
                                            continue;
                                        }
                                        if( JSONdeserializedResponse.containsKey( 'ILS_Units' ) ) {
                                            JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('ILS_Units');
                                            List<Object> JSONListUnits = ( List<Object> ) JSONdeserializedResponse.get('Unit');
                                            if( 0 < JSONListUnits.size() ) {
                                                if( !Property.Floor_Plans__r.isEmpty() ) {
                                                    Map<String, String> FloorPlanIdCodes 	= new Map<String, String>();
                                                    
                                                    for( Floor_Plan__c floorplan : Property.Floor_Plans__r ) {
                                                        FloorPlanIdCodes.put( floorplan.PSI_Floor_Plan_ID__c, floorplan.Id );
                                                    }
                                                    
                                                    //fetch related Units
                                                    Units = [SELECT
                                                             Id, Name, PSI_Unit_ID__c, Unit_ID__c, ResMan_Unit_ID__c, Unit_Type__c, X1_Month_Lease__c, X2_Month_Lease__c, X3_Month_Lease__c, X4_Month_Lease__c, X5_Month_Lease__c, X6_Month_Lease__c, X7_Month_Lease__c, X8_Month_Lease__c, X9_Month_Lease__c, X10_Month_Lease__c, X11_Month_Lease__c, X12_Month_Lease__c   
                                                             FROM
                                                             Unit__c
                                                             WHERE
                                                             Property__c =: Property.Id
                                                             AND Floor_Plan__c IN : FloorPlanIds
                                                             AND Account__c =: Property.Account__c
                                                            ];
                                                    
                                                    Map<String, Unit__c> UnitIdsUnits = new Map<String, Unit__c>();
                                                    Map<String, String> UnitCodesandIds = new Map<String, String>();
                                                    Map<String, String> YardiCodesandIds = new Map<String, String>();
                                                    Map<String, String> ResManCodesandIds = new Map<String, String>();
                                                    Map<String, Map<String, String>> NamesandIds = new Map<String, Map<String, String>>();
                                                    
                                                    for( Unit__c Unit : Units ) {
                                                        UnitCodesandIds.put( Unit.PSI_Unit_ID__c, Unit.Id );
                                                        
                                                        if( null != Unit.Unit_ID__c )
                                                            YardiCodesandIds.put( Unit.Unit_ID__c, Unit.Id );
                                                        
                                                        if( null != Unit.ResMan_Unit_ID__c )
                                                            ResManCodesandIds.put( Unit.ResMan_Unit_ID__c, Unit.Id );
                                                        
                                                        UnitIdsUnits.put( Unit.Id, Unit );
                                                        if( NamesandIds.containsKey( Unit.Unit_Type__c ) ) {
                                                            NamesandIds.get( Unit.Unit_Type__c ).putAll( new Map<String, String>{ Unit.Name => Unit.Id } );
                                                        } else {
                                                            NamesandIds.put( Unit.Unit_Type__c, new Map<String, String>{ Unit.Name => Unit.Id } );
                                                        }
                                                    }
                                                    
                                                    //insert or update units
                                                    for( Object JSONUnit : JSONListUnits ) {
                                                        Map<String, object> JSONUnitElements = ( Map<String, Object> ) JSONUnit;
                                                        JSONUnitElements = ( Map<String, Object> ) JSONUnitElements.get( '@attributes' );
                                                        String FloorPlanCode 	= String.valueOf( JSONUnitElements.get( 'UnitTypeId' ) );
                                                        String PropertyUnitId 	= (String) JSONUnitElements.get( 'PropertyUnitId' );
                                                        String UnitNumber 		= ( String ) JSONUnitElements.get( 'UnitNumber' );
                                                        
                                                        if( FloorPlanIdCodes.containsKey( FloorPlanCode ) ) {
                                                            
                                                            Unit__c Unit = new Unit__c();
                                                            
                                                            String Id;
                                                            if( UnitCodesandIds.containsKey( PropertyUnitId ) ) {
                                                                Id = UnitCodesandIds.get( PropertyUnitId );
                                                            } else if( YardiCodesandIds.containsKey( UnitNumber ) ) {
                                                                Id = YardiCodesandIds.get( UnitNumber );
                                                            } else if( ResManCodesandIds.containsKey( UnitNumber ) ) {
                                                                Id = ResManCodesandIds.get( UnitNumber );
                                                            } else if( NamesandIds.containsKey(FloorPlanCode) && NamesandIds.get(FloorPlanCode).containsKey(UnitNumber) ) {
                                                                Id = NamesandIds.get(FloorPlanCode).get(UnitNumber);
                                                            }
                                                            
                                                            if( null != Id ) {
                                                                
                                                                Unit.Id = Id;
                                                                Unit.Unit_Type__c = FloorPlanCode;
                                                                Unit.PSI_Unit_ID__c = PropertyUnitId;
                                                                if( false == IsLROPriceActive ) {
                                                                    Unit.X1_Month_Lease__c 	= UnitIdsUnits.get( Id ).X1_Month_Lease__c;
                                                                    Unit.X2_Month_Lease__c 	= UnitIdsUnits.get( Id ).X2_Month_Lease__c;
                                                                    Unit.X3_Month_Lease__c 	= UnitIdsUnits.get( Id ).X3_Month_Lease__c;
                                                                    Unit.X4_Month_Lease__c 	= UnitIdsUnits.get( Id ).X4_Month_Lease__c;
                                                                    Unit.X5_Month_Lease__c 	= UnitIdsUnits.get( Id ).X5_Month_Lease__c;
                                                                    Unit.X6_Month_Lease__c 	= UnitIdsUnits.get( Id ).X6_Month_Lease__c;
                                                                    Unit.X7_Month_Lease__c	= UnitIdsUnits.get( Id ).X7_Month_Lease__c;
                                                                    Unit.X8_Month_Lease__c 	= UnitIdsUnits.get( Id ).X8_Month_Lease__c;
                                                                    Unit.X9_Month_Lease__c 	= UnitIdsUnits.get( Id ).X9_Month_Lease__c;
                                                                    Unit.X10_Month_Lease__c = UnitIdsUnits.get( Id ).X10_Month_Lease__c;
                                                                    Unit.X11_Month_Lease__c = UnitIdsUnits.get( Id ).X11_Month_Lease__c;
                                                                    Unit.X12_Month_Lease__c = UnitIdsUnits.get( Id ).X12_Month_Lease__c; 
                                                                }
                                                                
                                                                arrProcessedUnits.add( Id );
                                                            } else {
                                                                Unit.Floor_Plan__c = FloorPlanIdCodes.get( FloorPlanCode );
                                                                Unit.Property__c = Property.Id;
                                                                Unit.Account__c = Property.Account__c;
                                                                Unit.PSI_Unit_ID__c = PropertyUnitId;
                                                                Unit.Unit_Type__c = FloorPlanCode;
                                                            }
                                                            
                                                            Unit.Name = UnitNumber;
                                                            
                                                            if( !IsLROPriceAndAvailabilityActive ) {
                                                                if( JSONUnitElements.containsKey( 'AvailableOn' ) ) {
                                                                    System.debug(' AvailableOn : ' + JSONUnitElements.get('AvailableOn'));
                                                                    Unit.Available_On__c = Date.parse(  (String) JSONUnitElements.get('AvailableOn') );
                                                                }
                                                                
                                                                if( JSONUnitElements.containsKey( 'MakeReadyDate' ) ) {
                                                                    Unit.Made_Ready_Date__c = Date.parse( (String) JSONUnitElements.get( 'MakeReadyDate' ) );
                                                                }
                                                                
                                                                if( JSONUnitElements.containsKey( 'Status' ) ) {
                                                                    Unit.Occupancy_Status__c = ( String ) JSONUnitElements.get( 'Status' );
                                                                    
                                                                    List<String> ListUnitsActiveStatus = new List<String>();
                                                                    if( null != strCredentials.get( 'Unit_Status_Active' ) ) {
                                                                        ListUnitsActiveStatus = strCredentials.get( 'Unit_Status_Active' ).split(';');
                                                                    } 
                                                                    
                                                                    if( !ListUnitsActiveStatus.isEmpty() ) {
                                                                        Set<String> SetUnitActive = new Set<String>();
                                                                        for( String UnitActiveStatus: ListUnitsActiveStatus ) {
                                                                            SetUnitActive.add( UnitActiveStatus );
                                                                        }
                                                                        
                                                                        Unit.Active__c = false;
                                                                        if( SetUnitActive.contains( ( String ) JSONUnitElements.get( 'Status' ) ) ) {
                                                                            Unit.Active__c = true;
                                                                        }
                                                                    }
                                                                    
                                                                    List<String> ListUnitsInActiveStatus = new List<String>();
                                                                    if( null != strCredentials.get( 'Unit_Status_InActive' ) ) {
                                                                        ListUnitsInActiveStatus = strCredentials.get( 'Unit_Status_InActive' ).split(';');
                                                                    }
                                                                    
                                                                    if( !ListUnitsInActiveStatus.isEmpty() ) {
                                                                        Set<String> SetUnitInActive = new Set<String>();
                                                                        for( String UnitInActiveStatus: ListUnitsInActiveStatus ) {
                                                                            SetUnitInActive.add( UnitInActiveStatus );
                                                                        }
                                                                        
                                                                        if( SetUnitInActive.contains( ( String ) JSONUnitElements.get( 'Status' ) ) ) {
                                                                            Unit.Active__c = false;
                                                                        }
                                                                    }
                                                                    
                                                                    List<String> ListUnitsActiveNoShowingsStatus = new List<string>();
                                                                    if( null != strCredentials.get( 'Unit_Status_Active_No_Showings' ) ) {
                                                                        ListUnitsActiveNoShowingsStatus = strCredentials.get( 'Unit_Status_Active_No_Showings' ).split(';');
                                                                    }
                                                                    
                                                                    if( !ListUnitsActiveNoShowingsStatus.isEmpty() ) {
                                                                        Set<String> SetUnitActiveNoShowings = new Set<String>();
                                                                        for( String UnitInActiveStatus: ListUnitsActiveNoShowingsStatus ) {
                                                                            SetUnitActiveNoShowings.add( UnitInActiveStatus );
                                                                        }
                                                                        
                                                                        Unit.Do_Not_Show__c = false;
                                                                        if( SetUnitActiveNoShowings.contains( ( String ) JSONUnitElements.get( 'Status' ) ) ) {
                                                                            Unit.Do_Not_Show__c = true;
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            
                                                            JSONUnitElements = ( Map<String, Object> ) JSONUnit;
                                                            JSONUnitElements = ( Map<String, Object> ) JSONUnitElements.get( 'Rent' );
                                                            
                                                            if( false == IsLROPriceActive && JSONUnitElements.containsKey('TermRent') ) {
                                                                List<Object> ListTermRentElements 					= ( List<Object> ) JSONUnitElements.get( 'TermRent' );
                                                                
                                                                Map<String, Decimal> TodaysRentAmount 				= new Map<String, Decimal>();
                                                                Map<String, Map<String, Decimal>> FuturesRentAmount = new Map<String, Map<String, Decimal>>();
                                                                //Map<String, Map<String, Decimal>> PastsRentAmount 	= new Map<String, Map<String, Decimal>>();
                                                                Set<String> SetLeaseTerms 							= new Set<String>();
                                                                
                                                                for( Object TermRent : ListTermRentElements ) {
                                                                    Map<String, Object> objTermRent = ( Map<String, Object> ) TermRent;
                                                                    objTermRent = ( Map<String, Object> ) objTermRent.get( '@attributes' );
                                                                    String LeaseTerm = ( String ) objTermRent.get('LeaseTerm');
                                                                    SetLeaseTerms.add(LeaseTerm);
                                                                    
                                                                    Decimal RentAmount;
                                                                    if( '' != objTermRent.get('Rent') ) {
                                                                        RentAmount = Decimal.valueOf( String.valueOf( objTermRent.get('Rent') ).replaceAll(',', '') );
                                                                    }
                                                                    
                                                                    if( 'No' == strCredentials.get( 'Uses_Yieldstar' ) ) { 
                                                                        TodaysRentAmount.put( LeaseTerm, RentAmount );
                                                                    } else if( objTermRent.containsKey( 'StartDate' ) && objTermRent.containsKey( 'EndDate' ) && '' != objTermRent.get('StartDate') && '' != objTermRent.get('EndDate') ) {
                                                                        Date StartDate = Date.parse( (String) objTermRent.get('StartDate') );
                                                                        Date EndDate = Date.parse( (String) objTermRent.get('EndDate') );
                                                                        
                                                                        if( StartDate <= Date.today() && EndDate >= Date.Today() ) {
                                                                            TodaysRentAmount.put( LeaseTerm, RentAmount );
                                                                        }
                                                                        
                                                                        if( StartDate > Date.today() ) {
                                                                            if( !FuturesRentAmount.containsKey( LeaseTerm ) ) {
                                                                                FuturesRentAmount.put( LeaseTerm, new Map<String, Decimal>{ String.valueOf( objTermRent.get('StartDate') ) => RentAmount } );
                                                                            } else if( Date.parse( (new list<string>(FuturesRentAmount.get(LeaseTerm).keySet()) )[0] ) > StartDate ) {
                                                                                FuturesRentAmount.put( LeaseTerm, new Map<String, Decimal>{ String.valueOf( objTermRent.get('StartDate') ) => RentAmount } );
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                
                                                                for( String LeaseTerm : SetLeaseTerms ) {
                                                                    if( TodaysRentAmount.containsKey( LeaseTerm ) ) {
                                                                        this.setLeasetermValuestoUnit( Unit, LeaseTerm, TodaysRentAmount.get( LeaseTerm ) );
                                                                        
                                                                    } else if ( FuturesRentAmount.containsKey( LeaseTerm ) && 'Yes' == strCredentials.get( 'Uses_Yieldstar' ) ) {
                                                                        this.setLeasetermValuestoUnit( Unit, LeaseTerm, FuturesRentAmount.get( LeaseTerm ).get((new List<String>(FuturesRentAmount.get(LeaseTerm).keySet()))[0]) );                                                                    
                                                                    }
                                                                }
                                                            }
                                                            
                                                            JSONUnitElements = ( Map<String, Object> ) JSONUnit;
                                                            JSONUnitElements = ( Map<String, Object> ) JSONUnitElements.get( 'Deposit' );
                                                            JSONUnitElements = ( Map<String, Object> ) JSONUnitElements.get( '@attributes' );
                                                            
                                                            Unit.Deposit__c = Decimal.valueOf( String.valueOf( JSONUnitElements.get('MaxDeposit') ).replaceAll(',', '') );
                                                            
                                                            arrobjUnits.add( Unit );
                                                        }
                                                    } 
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if( !IsLROPriceAndAvailabilityActive ) {
                            for( Unit__c Unit : Units ) {
                                if( !arrProcessedUnits.contains( Unit.Id ) && true == isDeactivateUnits ) {
                                    Unit.Active__c = false;
                                    arrobjUnits.add( Unit );
                                }
                            }
                        }
                    } catch ( Exception e ) {
                        System.debug( e.getMessage() );
                        System.debug( e.getStackTraceString() );
                        System.debug( 'Error for Property: ' + property.Name );
                    }
                }
                
            }
            
        }
        
    }
    
    public void setLeasetermValuestoUnit( Unit__c Unit, String LeaseTerm, Decimal RentAmount ) {
        if ( '1 month' == LeaseTerm && ( 0.0 != Unit.X1_Month_Lease__c || RentAmount != null ) ) {
            Unit.X1_Month_Lease__c = RentAmount;
        } else if ( '2 months' == LeaseTerm && ( 0.0 != Unit.X2_Month_Lease__c || RentAmount != null ) ) {
            Unit.X2_Month_Lease__c = RentAmount;
        } else if ( '3 months' == LeaseTerm && ( 0.0 != Unit.X3_Month_Lease__c || RentAmount != null ) ) {
            Unit.X3_Month_Lease__c = RentAmount;
        } else if ( '4 months' == LeaseTerm && ( 0.0 != Unit.X4_Month_Lease__c || RentAmount != null ) ) {
            Unit.X4_Month_Lease__c = RentAmount;
        } else if ( '5 months' == LeaseTerm && ( 0.0 != Unit.X5_Month_Lease__c || RentAmount != null ) ) {
            Unit.X5_Month_Lease__c = RentAmount;
        } else if ( '6 months' == LeaseTerm && ( 0.0 != Unit.X6_Month_Lease__c || RentAmount != null ) ) {
            Unit.X6_Month_Lease__c = RentAmount;
        } else if ( '7 months' == LeaseTerm && ( 0.0 != Unit.X7_Month_Lease__c || RentAmount != null ) ) {
            Unit.X7_Month_Lease__c = RentAmount;
        } else if ( '8 months' == LeaseTerm && ( 0.0 != Unit.X8_Month_Lease__c || RentAmount != null ) ) {
            Unit.X8_Month_Lease__c = RentAmount;
        } else if ( '9 months' == LeaseTerm && ( 0.0 != Unit.X9_Month_Lease__c || RentAmount != null ) ) {
            Unit.X9_Month_Lease__c = RentAmount;
        } else if ( '10 months' == LeaseTerm && ( 0.0 != Unit.X10_Month_Lease__c || RentAmount != null ) ) {
            Unit.X10_Month_Lease__c = RentAmount;
        } else if ( '11 months' == LeaseTerm && ( 0.0 != Unit.X11_Month_Lease__c || RentAmount != null ) ) {
            Unit.X11_Month_Lease__c = RentAmount;
        } else if ( '12 months' == LeaseTerm && ( 0.0 != Unit.X12_Month_Lease__c || RentAmount != null ) ) {
            Unit.X12_Month_Lease__c = RentAmount;
        }
    }
    
    public void getUnitsAvailabilityAndPricing( String Username, String Password, String PropertyId, String PSI_API_URL ) {
        
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
        
        JSONrequest.writeStringField( 'name', 'getUnitsAvailabilityAndPricing');
        JSONrequest.writeFieldName( 'params' );
        JSONrequest.writeStartObject();
        JSONrequest.writeStringField( 'propertyId', PropertyId );
        JSONrequest.writeStringField( 'availableUnitsOnly', '0' );
        JSONrequest.writeStringField( 'showChildProperties', '0' );
        JSONrequest.writeStringField( 'includeDisabledFloorplans', '0' );
        JSONrequest.writeStringField( 'showUnitSpaces', '0' );
        JSONrequest.writeEndObject();
        JSONrequest.writeEndObject();
        JSONrequest.writeEndObject();
        
        Http httpPro = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndPoint( PSI_API_URL + '/propertyunits' );
        request.setMethod( 'POST' );
        request.setHeader( 'Content-Type', 'application/json' );
        request.setBody( JSONrequest.getAsString() );
        request.setTimeout( 120000 );
        if( !Test.isRunningTest() ) {
            HTTPResponse res = httpPro.send(request);
            strUnitAvailability_Login = res.getBody();            
        } else {
            strUnitAvailability_Login = '{"response":{"requestId":"15","result":{"ILS_Units":{"Unit":[{"@attributes":{"UnitNumber":"0511","FloorPlanName":"Tumbleweed","Availability":"Not Available","Status":"Occupied (Unavailable)","FloorplanId":190770,"UnitTypeId":"251534","PropertyUnitId":"3191963","PropertyId":104143},"Rent":{"@attributes":{"MinRent":"965.00","MaxRent":"1,505.00"}},"Deposit":{"@attributes":{"MinDeposit":"0.00","MaxDeposit":"0.00"}}}, {"@attributes":{"UnitNumber":"1716","FloorPlanName":"Tumbleweed","Availability":"Not Available","Status":"On Notice (Unavailable)","FloorplanId":190770,"UnitTypeId":"251534","PropertyUnitId":"3191970","PropertyId":104143},"Rent":{"TermRent":[{"@attributes":{"LeaseTerm":"1 months","StartDate":"01/12/2014","EndDate":"01/01/2100","Rent":"1,075.00"}},{"@attributes":{"LeaseTerm":"2 months","StartDate":"01/21/2015","EndDate":"01/01/2100","Rent":"1,075.00"}},{"@attributes":{"LeaseTerm":"3 months","StartDate":"01/21/2015","EndDate":"01/01/2100","Rent":"1,075.00"}},{"@attributes":{"LeaseTerm":"4 months","StartDate":"01/21/2015","EndDate":"01/01/2100","Rent":"1,080.00"}},{"@attributes":{"LeaseTerm":"5 months","StartDate":"01/21/2015","EndDate":"01/01/2100","Rent":"1,085.00"}},{"@attributes":{"LeaseTerm":"6 months","StartDate":"01/21/2015","EndDate":"01/01/2100","Rent":"1,135.00"}},{"@attributes":{"LeaseTerm":"7 months","StartDate":"01/21/2015","EndDate":"01/01/2100","Rent":"1,095.00"}},{"@attributes":{"LeaseTerm":"8 months","StartDate":"01/21/2015","EndDate":"01/01/2100","Rent":"1,100.00"}},{"@attributes":{"LeaseTerm":"9 months","StartDate":"01/21/2015","EndDate":"01/01/2100","Rent":"1,100.00"}},{"@attributes":{"LeaseTerm":"10 months","StartDate":"01/21/2015","EndDate":"01/01/2100","Rent":"985.00"}},{"@attributes":{"LeaseTerm":"11 months","StartDate":"01/21/2015","EndDate":"01/01/2100","Rent":"980.00"}},{"@attributes":{"LeaseTerm":"12 months","StartDate":"01/21/2015","EndDate":"01/01/2100","IsBestPrice":"true","Rent":"980.00"}}],"@attributes":{"MinRent":"980.00","MaxRent":"1,135.00"}},"Deposit":{"@attributes":{"MinDeposit":"0.00","MaxDeposit":"0.00"}}}]}}}}';
        }
    }
}