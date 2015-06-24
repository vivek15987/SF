public with sharing class YardiGCPullUnitController {
    
    public YardiGCPushWsdltoApexController.ItfILSGuestCardSoap yvn; 
    public YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn20;
    
    public YardiGCPullPropertiesResponseController objGCPullPropertiesResponse;
    public YardiGCPullUnitResponseController objGCPullUnitResponse;
    
    final String strInterfaceEntity;
    final String strInterfaceLicense;
    
    public String strUnitAvailability_Login;
    
    public List<String> strCredentials  				= new List<String>();
    public List<Unit__c> arrobjUnits					= new List<Unit__c>();
    
    public Set<ID> AccountIds							= new Set<ID>();
    public Set<ID> PropertyIds 							= new Set<ID>();
    public Set<ID> FloorPlanIds 						= new Set<ID>();
    
    public YardiGCPullUnitController() {
        strInterfaceEntity      = 'Anyone Home';
        strInterfaceLicense     = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
    }
    
    public void YardiGCPullUnit() { 
        if( !AccountIds.isEmpty() ) {
            List<Integration__c> searchList = [ SELECT 
                                               Id, Account__c, Name, Yardi_Database_Name__c, Push_Guest_Cards_to_Yardi__c, Yardi_Integration_Active__c, Yardi_Server_Name__c, Yardi_ID__c, Yardi_Password__c, Yardi_Platform_Type__c, Yardi_API_URL__c, Yardi_SR_API_URL__c, Grouping__c, Yardi_Version_Number__c, Last_Yardi_Pull__c, Vacant_Available__c, Vacant_Leased__c, Vacant_Leased_On_Notice__c, Vacant_Leased_Reserved__c, Vacant_Not_Ready__c, Vacant_On_Notice__c, Vacant_Other__c, vacant_reserved__c, Vacant_Approved__c,
                                               Occupied_Approved__c, Occupied_Available__c, Occupied_Leased__c, Occupied_Leased_On_Notice__c, Occupied_Leased_Reserved__c, Occupied_Not_Ready__c, Occupied_On_Notice__c, Occupied_Other__c, Occupied_Reserved__c, Occupied_No_Notice__c, Uses_Yieldstar__c, Do_Not_Update_Names_Of__c, New_LRO_Setting__c
                                               FROM
                                               Integration__c
                                               WHERE
                                               Yardi_Integration_Active__c = true 
                                               AND Yardi_Availability_Pricing__c != null 
                                               AND Account__c IN : AccountIds
                                              ];
            
            Set<String> AccountIds = new Set<String>();
            Set<String> GroupingIds = new Set<String>();
            Map<String, List<String>> credentials = new Map<String, List<String>>();
            Map<String, Map<String , String>> IntegrationStatusmap = new  Map<String, Map<String , String>>();
            
            if( !searchList.isEmpty() ) {
                for( Integration__c I :searchList ) { 
                    List<String> tempCredentials = new List<String>();
                    tempCredentials.add(I.Yardi_ID__c);
                    tempCredentials.add(I.Yardi_Password__c);
                    tempCredentials.add(I.Yardi_Server_Name__c);
                    tempCredentials.add(I.Yardi_Database_Name__c);
                    tempCredentials.add(I.Yardi_Platform_Type__c);
                    tempCredentials.add(strInterfaceEntity);
                    tempCredentials.add(strInterfaceLicense);  
                    tempCredentials.add(I.Yardi_Version_Number__c);
                    tempCredentials.add(I.Yardi_API_URL__c);
                    tempCredentials.add(I.Id);
                    tempCredentials.add(I.Name);
                    
                    Map<String, String> tempIntegrationStatusMap = new Map<String, String>();
                    tempIntegrationStatusMap.put( 'vacant approved', I.Vacant_Approved__c );
                    tempIntegrationStatusMap.put( 'vacant available', I.Vacant_Available__c );
                    tempIntegrationStatusMap.put( 'vacant leased', I.Vacant_Leased__c );
                    tempIntegrationStatusMap.put( 'vacant leased on notice', I.Vacant_Leased_On_Notice__c );
                    tempIntegrationStatusMap.put( 'vacant leased reserved', I.Vacant_Leased_Reserved__c );
                    tempIntegrationStatusMap.put( 'vacant not ready', I.Vacant_Not_Ready__c );
                    tempIntegrationStatusMap.put( 'vacant on notice', I.Vacant_On_Notice__c );
                    tempIntegrationStatusMap.put( 'vacant other', I.Vacant_Other__c );
                    tempIntegrationStatusMap.put( 'vacant reserved', I.vacant_reserved__c );
                    tempIntegrationStatusMap.put( 'occupied approved', I.Occupied_Approved__c );
                    tempIntegrationStatusMap.put( 'occupied available', I.Occupied_Available__c );
                    tempIntegrationStatusMap.put( 'occupied leased', I.Occupied_Leased__c );
                    tempIntegrationStatusMap.put( 'occupied leased on notice', I.Occupied_Leased_On_Notice__c );
                    tempIntegrationStatusMap.put( 'occupied leased reserved', I.Occupied_Leased_Reserved__c );
                    tempIntegrationStatusMap.put( 'occupied not ready', I.Occupied_Not_Ready__c );
                    tempIntegrationStatusMap.put( 'occupied on notice', I.Occupied_On_Notice__c );
                    tempIntegrationStatusMap.put( 'occupied other', I.Occupied_Other__c );
                    tempIntegrationStatusMap.put( 'occupied reserved', I.Occupied_Reserved__c );
                    tempIntegrationStatusMap.put( 'occupied no notice', I.Occupied_No_Notice__c );
                    tempIntegrationStatusMap.put( 'Uses Yieldstar', ( true == I.Uses_Yieldstar__c ? 'YES' : 'NO' ) );
                    if( null != I.Do_Not_Update_Names_Of__c ) {
                        tempIntegrationStatusMap.put( 'Do Not Update Name',  I.Do_Not_Update_Names_Of__c.contains( 'Units' )  ? 'YES' : 'NO' );    
                    } else {
                        tempIntegrationStatusMap.put( 'Do Not Update Name', 'NO' );    
                    }
                    if( null != I.New_LRO_Setting__c )
                        tempIntegrationStatusMap.put( 'New LRO Setting', I.New_LRO_Setting__c );
                    
                    if( null != I.Grouping__c && !GroupingIds.contains( I.Grouping__c ) ) {
                        GroupingIds.add( I.Grouping__c );
                        credentials.put( I.Grouping__c, tempCredentials );
                        IntegrationStatusmap.put( I.Grouping__c, tempIntegrationStatusMap );
                    } else if( !AccountIds.contains( I.Account__c ) ) {
                        AccountIds.add( I.Account__c );
                        credentials.put( I.Account__c, tempCredentials );
                        IntegrationStatusmap.put( I.Account__c, tempIntegrationStatusMap );
                    }  
                }
                
                List<Property__c> fetchedProperties = new List<Property__c>();
                
                fetchedProperties = [SELECT 
                                     Id, Name, Account__c, Account__r.Name, Customer_Prop_ID__c, Last_Unit_Pull__c, Group_Membership__c, Group_Membership__r.Name,
                                     ( SELECT Id, Floorplan_ID__c FROM Floor_Plans__r WHERE Floorplan_ID__c != NULL AND Id IN :FloorPlanIds  )
                                     FROM 
                                     Property__c 
                                     WHERE
                                     Id IN :PropertyIds
                                    ];
                
                for( Property__c property : fetchedProperties ) {
                    property.Last_Unit_Pull__c = datetime.now();
                    System.debug( property.Name );
                }
                
                List<Integration__c> ListIntegrations = new List<Integration__c>();
                Set<String> executedIntegrationIds = new Set<String>();
                
                for( Property__c property : fetchedProperties ) {
                    System.debug( property.Name );
                    try{ 
                        Boolean IsLROPriceActive = false;
                        Boolean IsLROPriceAndAvailabilityActive = false;
                        
                        List<String> strCredentials = new List<String>();
                        if( null != property.Group_Membership__c && credentials.containsKey( property.Group_Membership__c ) ) {
                            strCredentials = credentials.get( property.Group_Membership__c );
                        } else if( credentials.containsKey( property.Account__c ) ) {
                            strCredentials = credentials.get( property.Account__c );
                        }
                        
                        Map<String , String> Integration_map = new  Map<String , String>();
                        if( null != property.Group_Membership__c && IntegrationStatusmap.containsKey( property.Group_Membership__c ) ) {
                            Integration_map = IntegrationStatusmap.get( property.Group_Membership__c );
                            if( IntegrationStatusmap.get( Property.Group_Membership__c ).containsKey( 'New LRO Setting' ) ) {
                                if( 'Price' == IntegrationStatusmap.get( Property.Group_Membership__c ).get( 'New LRO Setting' ) ) {
                                    IsLROPriceActive = true;
                                } else if ( 'Price and Availability' == IntegrationStatusmap.get( Property.Group_Membership__c ).get( 'New LRO Setting' ) ) {
                                    IsLROPriceActive = true;
                                    IsLROPriceAndAvailabilityActive = true;
                                }
                            }
                        } else if( IntegrationStatusmap.containsKey( property.Account__c ) ) {
                            Integration_map = IntegrationStatusmap.get( property.Account__c );
                        }
                        
                        if( !strCredentials.isEmpty() ) {
                            if( '4' == strCredentials.get(7) ) {
                                yvn = new YardiGCPushWsdltoApexController.ItfILSGuestCardSoap();
                                yvn.endpoint_x = strCredentials.get(8);   
                                yvn.timeout_x = 120000; 
                            } else {
                                yvn20 = new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
                                yvn20.endpoint_x = strCredentials.get(8);
                                yvn20.timeout_x = 120000;
                            }
                            
                            if( !property.Floor_Plans__r.isEmpty() ) {
                                Map<String, String> FloorPlanIdCodes 	= new Map<String, String>();
                                Set<String> FilteredFloorPlanIds		= new Set<String>();
                                Set<String> FloorPlanCodes				= new Set<String>();
                                
                                for( Floor_Plan__c floorplan : property.Floor_Plans__r ) {
                                    FloorPlanIdCodes.put( floorplan.Floorplan_ID__c, floorplan.Id );
                                    FilteredFloorPlanIds.add( floorplan.Id );
                                    FloorPlanCodes.add( floorplan.Floorplan_ID__c );
                                }
                                
                                List<Unit__c> Units = [ SELECT
                                                       Id, Unit_ID__c  
                                                       FROM
                                                       Unit__c
                                                       WHERE
                                                       Unit_ID__c != NULL
                                                       AND Floor_Plan__c IN : FilteredFloorPlanIds
                                                       AND Property__c =: property.Id
                                                       AND Account__c =: property.Account__c   
                                                      ];
                                
                                this.UnitAvailability_Login( strCredentials, property.Customer_Prop_ID__c, strCredentials.get(7) );
                                
                                Map<String, String> UnitCodesandIds = new Map<String, String>();
                                for( Unit__c Unit :Units ) { 
                                    UnitCodesandIds.put( Unit.Unit_ID__c, Unit.Id );
                                }
                                
                                if( null != objGCPullUnitResponse && !objGCPullUnitResponse.UnitInfo.isEmpty() ) {
                                    for( String UnitCode: objGCPullUnitResponse.UnitCodes ) {
                                        if( FloorPlanIdCodes.containsKey( objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitType' ) ) ) {
                                            Unit__c Unit = new Unit__c();
                                            
                                            if( UnitCodesandIds.containsKey( UnitCode ) ) {
                                                Unit.Id = UnitCodesandIds.get( UnitCode );
                                                if( 'NO' == Integration_map.get( 'Do Not Update Name' ) )
                                                    Unit.Name 				= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitID' );
                                            } else {
                                                Unit.Floor_Plan__c			= FloorPlanIdCodes.get( objGCPullUnitResponse.UnitInfo.get(UnitCode).get('UnitType') );
                                                Unit.Property__c 			= property.Id;
                                                Unit.Account__c				= property.Account__c;
                                                Unit.Name 					= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitID' );
                                            }
                                            
                                            Unit.Unit_ID__c				= UnitCode;
                                            Unit.Unit_Type__c 			= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitType' );
                                            Unit.Bedrooms__c 			= Decimal.valueOf( objGCPullUnitResponse.UnitInfo.get(Unit.Unit_ID__c).get( 'UnitBedrooms' ) );
                                            Unit.Bathrooms__c 			= Decimal.valueOf( objGCPullUnitResponse.UnitInfo.get(Unit.Unit_ID__c).get( 'UnitBathrooms' ) );
                                            
                                            String MinSquareFeet 		= NULL == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MinSquareFeet' ) ? '0':objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MinSquareFeet' ) ;
                                            String MaxSquareFeet 		= NULL == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MaxSquareFeet' ) ? '0':objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MaxSquareFeet' ) ;
                                            
                                            if( '0' == MaxSquareFeet || MinSquareFeet == MaxSquareFeet )    
                                                Unit.Square_Feet__c 	= MinSquareFeet;
                                            else 
                                                Unit.Square_Feet__c 	= MaxSquareFeet;
                                            
                                            if( !IsLROPriceActive ) {
                                                Unit.Market_Rent__c 		= Decimal.valueOf( objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MarketRent' ) );
                                                if( true == Integration_map.containsKey( 'Uses Yieldstar' ) && 'NO' == Integration_map.get( 'Uses Yieldstar' ) && '2' == objGCPullUnitResponse.VersionNumber ) {
                                                    unit.X12_Month_Lease__c 	= Decimal.valueOf( objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MarketRent' ) );
                                                }
                                            }
                                            
                                            if( !IsLROPriceAndAvailabilityActive ) {
                                                Unit.Occupancy_Status__c 	= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitOccupancyStatus' );
                                                Unit.Leased_Status__c 		= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitLeasedStatus' );
                                                
                                                if('available' == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitLeasedStatus') && Null !=objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'Comment' )){
                                                    if('RentReady=true' == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'Comment' )){
                                                        
                                                        Unit.Leased_Status__c = 'Available'; 
                                                    }else if('RentReady=false' == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'Comment' )){
                                                        
                                                        Unit.Leased_Status__c = 'Not Ready';
                                                    }
                                                }
                                            }
                                            
                                            Unit.Deposit__c				= Decimal.valueOf( objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'Deposit' ) );
                                            
                                            if( null != objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'VacateDate' ) && '0/0/0' == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'VacateDate' ) )
                                                Unit.Vacate_Date__c 		= NULL;
                                            else
                                                Unit.Vacate_Date__c 		= NULL == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'VacateDate' ) ? NULL : Date.parse( objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'VacateDate' ) );
                                            Unit.Vacancy_Class__c 		= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'VacancyClass' );
                                            
                                            if( !IsLROPriceAndAvailabilityActive ) {
                                                if( null != objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MadeReadyDate' ) && '0/0/0' == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MadeReadyDate' ) )
                                                    Unit.Made_Ready_Date__c 	= NULL;
                                                else
                                                    Unit.Made_Ready_Date__c 	= NULL == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MadeReadyDate' ) ? NULL : Date.parse( objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MadeReadyDate' ) );
                                           
                                                Unit.Active__c = false;
                                                if( true == Integration_map.containsKey( Unit.Occupancy_Status__c.toLowerCase() ) ) {
                                                    if( 'Active' == Integration_map.get( Unit.Occupancy_Status__c.toLowerCase() ) || 'Active No Showings Available' == Integration_map.get( Unit.Occupancy_Status__c.toLowerCase() ) ) {
                                                        Unit.Active__c = true;
                                                    }
                                                    
                                                    Unit.Do_Not_Show__c = false;
                                                    if( 'Active No Showings Available' == Integration_map.get( Unit.Occupancy_Status__c.toLowerCase() ) ) {
                                                        Unit.Do_Not_Show__c = true;
                                                    }
                                                } 
                                                
                                                Unit.Leased_Status__c = Unit.Leased_Status__c.replace( '_', ' ' );
                                                if( true == Integration_map.containsKey( ( Unit.Occupancy_Status__c + ' ' + Unit.Leased_Status__c ).toLowerCase() ) ) {
                                                    System.debug(' Status - ' + Integration_map.get( ( Unit.Occupancy_Status__c + ' ' + Unit.Leased_Status__c ).toLowerCase()) );
                                                    if( 'Active' == Integration_map.get( ( Unit.Occupancy_Status__c + ' ' + Unit.Leased_Status__c ).toLowerCase() ) || 'Active No Showings Available' == Integration_map.get( ( Unit.Occupancy_Status__c + ' ' + Unit.Leased_Status__c ).toLowerCase() ) ) {
                                                        Unit.Active__c = true;
                                                    }
                                                    
                                                    Unit.Do_Not_Show__c = false;
                                                    if( 'Active No Showings Available' == Integration_map.get( ( Unit.Occupancy_Status__c + ' ' + Unit.Leased_Status__c ).toLowerCase() ) ) {
                                                        Unit.Do_Not_Show__c = true;
                                                    }
                                                }
                                                
                                                if(Unit.Leased_Status__c == 'Other'){
                                                    Unit.Is_Waitlist__c = true;
                                                }
                                            }
                                            
                                            System.debug('Status - '+ (Unit.Occupancy_Status__c + ' ' + Unit.Leased_Status__c ).toLowerCase() );
                                            System.debug('Unit - ' + Unit );
                                            
                                            arrobjUnits.add( Unit );
                                        }
                                    }
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
    
    public void UnitAvailability_Login( List<String> strCredentials, String strYardiPropertyId, String strVersionNumber ) {
        if( !Test.isRunningTest() ) {
            if( '4' == strVersionNumber ) {
                strUnitAvailability_Login = yvn.UnitAvailability_Login( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4), strYardiPropertyId, strCredentials.get(5),strCredentials.get(6) );
            } else {
                strUnitAvailability_Login = yvn20.UnitAvailability_Login( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4), strYardiPropertyId, strCredentials.get(5),strCredentials.get(6) );
            } 
        } else {
            if( '4' == strVersionNumber ) {
                strUnitAvailability_Login = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <UnitAvailability_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard"> <UnitAvailability_LoginResult> <PhysicalProperty xsi:noNamespaceSchemaLocation="" xmlns:MITS="http://my-company.com/namespace" xmlns=""> <Property IDValue="anyhom5"> <PropertyID> <Identification IDValue="anyhom5"/> <MarketingName>anyhom5 property</MarketingName> <Address AddressType="property"> <AddressLine1>anyhom5 Address 1</AddressLine1> <AddressLine2>anyhom5 Address 2</AddressLine2> <City>Miami</City> <State>IN</State> <PostalCode>1234</PostalCode> </Address> </PropertyID> <ILS_Identification ILS_IdentificationType="Unspecified" RentalType="Unspecified"/> <Information> <StructureType>Unspecified</StructureType> <UnitCount>1</UnitCount> </Information> <Floorplan IDValue="anyhom5"> <Name>anyhom5 unit</Name> <UnitCount>1</UnitCount> <Room RoomType="Bedroom"> <Count>2.00</Count> <Comment/> </Room> <Room RoomType="Bathroom"> <Count>1.00</Count> <Comment/> </Room> <SquareFeet Min="500" Max="500"/> <MarketRent Min="300" Max="300"/> <EffectiveRent Min="300" Max="300"/> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="800.00"/> </Amount> </Deposit> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> <AdminFee>0</AdminFee> <ApplicationFee>0</ApplicationFee> <BrokerFee>0</BrokerFee> </Fee> </Floorplan> <ILS_Unit IDValue="ANYHOM5"> <Units> <Unit> <Identification IDValue="ANYHOM5" IDType="14617"/> <UnitType>anyhom5</UnitType> <UnitBedrooms>2.00</UnitBedrooms> <UnitBathrooms>1.00</UnitBathrooms> <MinSquareFeet>500</MinSquareFeet> <MaxSquareFeet>500</MaxSquareFeet> <MarketRent>300.00</MarketRent> <UnitEconomicStatus>residential</UnitEconomicStatus> <UnitOccupancyStatus>occupied</UnitOccupancyStatus> <UnitLeasedStatus>on_notice</UnitLeasedStatus> <FloorplanName>anyhom5 unit</FloorplanName> </Unit> </Units> <Comment>RentReady=false</Comment> <EffectiveRent Min="300" Max="300"/> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="800.00"/> </Amount> <Description>Deposit</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> <Availability> <VacateDate Month="3" Day="20" Year="2014"/> <VacancyClass>Occupied</VacancyClass> <MadeReadyDate Month="3" Day="20" Year="2014"/> </Availability> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> </Fee> </ILS_Unit> <ILS_Unit IDValue="13234"> <Units> <Unit> <Identification IDValue="ANYHOM5" IDType="14617"/> <UnitType>anyhom5</UnitType> <UnitBedrooms>2.00</UnitBedrooms> <UnitBathrooms>1.00</UnitBathrooms> <MinSquareFeet>500</MinSquareFeet> <MaxSquareFeet>500</MaxSquareFeet> <MarketRent>300.00</MarketRent> <UnitEconomicStatus>residential</UnitEconomicStatus> <UnitOccupancyStatus>occupied</UnitOccupancyStatus> <UnitLeasedStatus>on_notice</UnitLeasedStatus> <FloorplanName>anyhom5 unit</FloorplanName> </Unit> </Units> <Comment>RentReady=false</Comment> <EffectiveRent Min="300" Max="300"/> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="800.00"/> </Amount> <Description>Deposit</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> <Availability> <VacateDate Month="3" Day="20" Year="2014"/> <VacancyClass>Occupied</VacancyClass> <MadeReadyDate Month="3" Day="20" Year="2014"/> </Availability> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> </Fee> </ILS_Unit> </Property> </PhysicalProperty> </UnitAvailability_LoginResult> </UnitAvailability_LoginResponse> </soap:Body> </soap:Envelope>';
            } else {
                strUnitAvailability_Login = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <UnitAvailability_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20"> <UnitAvailability_LoginResult> <PhysicalProperty xsi:noNamespaceSchemaLocation="" xmlns:MITS="http://my-company.com/namespace" xmlns=""> <Property> <PropertyID> <MITS:Identification Type="other"> <MITS:PrimaryID>anyhom5</MITS:PrimaryID> <MITS:MarketingName>anyhom5 property</MITS:MarketingName> </MITS:Identification> <MITS:Address Type="property"> <MITS:Address1>anyhom5 Address 1</MITS:Address1> <MITS:Address2>anyhom5 Address 2</MITS:Address2> <MITS:City>Miami</MITS:City> <MITS:State>IN</MITS:State> <MITS:PostalCode>1234</MITS:PostalCode> </MITS:Address> </PropertyID> <ILS_Identification Type="Unspecified" RentalType="Unspecified"/> <Information> <StructureType>Unspecified</StructureType> <UnitCount>1</UnitCount> </Information> <Floorplan Id="anyhom5"> <Name>anyhom5 unit</Name> <UnitCount>1</UnitCount> <Room Type="Bedroom"> <Count>2.00</Count> <Comment/> </Room> <Room Type="Bathroom"> <Count>1.00</Count> <Comment/> </Room> <SquareFeet Min="500" Max="500"/> <MarketRent Min="300" Max="300"/> <EffectiveRent Min="300" Max="300"/> <Deposit type="deposit"> <Amount Type="Actual"> <Value>800.00</Value> </Amount> </Deposit> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> <AdminFee>0</AdminFee> <ApplicationFee>0</ApplicationFee> </Fee> </Floorplan> <ILS_Unit Id="ANYHOM5" FloorplanID=""> <Unit> <MITS:Information> <MITS:UnitID>ANYHOM5</MITS:UnitID> <MITS:UnitType>anyhom5</MITS:UnitType> <MITS:UnitBedrooms>2.00</MITS:UnitBedrooms> <MITS:UnitBathrooms>1.00</MITS:UnitBathrooms> <MITS:MinSquareFeet>500</MITS:MinSquareFeet> <MITS:MaxSquareFeet>500</MITS:MaxSquareFeet> <MITS:MarketRent>300.00</MITS:MarketRent> <MITS:UnitEconomicStatus>residential</MITS:UnitEconomicStatus> <MITS:UnitOccupancyStatus>occupied</MITS:UnitOccupancyStatus> <MITS:UnitLeasedStatus>on_notice</MITS:UnitLeasedStatus> <MITS:FloorPlanID/> <MITS:FloorplanName>anyhom5 unit</MITS:FloorplanName> </MITS:Information> <MITS:PropertyPrimaryID>anyhom5</MITS:PropertyPrimaryID> <MITS:MarketingName>anyhom5 property</MITS:MarketingName> </Unit> <Comment>RentReady=false</Comment> <EffectiveRent Min="300" Max="300"/> <Deposit type="deposit"> <Amount Type="Actual"> <Value>800.00</Value> </Amount> <Description>Deposit</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> <Availability> <VacateDate Month="3" Day="20" Year="2014"/> <VacancyClass>Occupied</VacancyClass> <MadeReadyDate Month="3" Day="20" Year="2014"/> </Availability> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> </Fee> </ILS_Unit> </Property> </PhysicalProperty> </UnitAvailability_LoginResult> </UnitAvailability_LoginResponse> </soap:Body> </soap:Envelope>';
            } 
        }
        
        System.debug('strUnitAvailability_Login - ' + strUnitAvailability_Login);
        XmlStreamReader reader = new XmlStreamReader( strUnitAvailability_Login );
        objGCPullUnitResponse = new YardiGCPullUnitResponseController();
        
        if( '4' == strVersionNumber ) {
            objGCPullUnitResponse.parsePullUnitResponse40(reader);
        } else {
            objGCPullUnitResponse.parsePullUnitResponse20(reader);
        }
    }
}