public with sharing class tempUnitsController {
	
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
    
    public tempUnitsController() {
        strInterfaceEntity      = 'Anyone Home';
        strInterfaceLicense     = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
    }
   
    public void YardiGCPullUnit(Boolean isGCPullUnitScheduler) { 
        if( this.AccountIds.isEmpty() ) {
            return;
        }
        
        List<Integration__c> searchList = [ SELECT 
                                                Id, Account__c, Name, Yardi_Database_Name__c, Push_Guest_Cards_to_Yardi__c, Yardi_Integration_Active__c, Yardi_Server_Name__c, Yardi_ID__c, Yardi_Password__c, Yardi_Platform_Type__c, Yardi_API_URL__c, Yardi_SR_API_URL__c, Grouping__c, Yardi_Version_Number__c, Last_Yardi_Pull__c, Vacant_Available__c, Vacant_Leased__c, Vacant_Leased_On_Notice__c, Vacant_Leased_Reserved__c, Vacant_Not_Ready__c, Vacant_On_Notice__c, Vacant_Other__c, vacant_reserved__c, Vacant_Approved__c,
                                                Occupied_Approved__c, Occupied_Available__c, Occupied_Leased__c, Occupied_Leased_On_Notice__c, Occupied_Leased_Reserved__c, Occupied_Not_Ready__c, Occupied_On_Notice__c, Occupied_Other__c, Occupied_Reserved__c, Occupied_No_Notice__c
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
                                 	Id, Name, Account__c, Account__r.Name, Customer_Prop_ID__c, Last_Unit_Pull__c, Group_Membership__c, Group_Membership__r.Name
                                 FROM 
                                 	Property__c 
                                 WHERE
                                 	Id IN :PropertyIds
                                 	//Id IN ( SELECT Property__c FROM Floor_Plan__c WHERE Floorplan_ID__c != NULL )
                                 	//AND Customer_Prop_ID__c != NULL
                                 	//AND ( ( Group_Membership__c IN : GroupingIds ) OR ( Account__c IN : AccountIds AND Group_Membership__c = NULL ) ) 
                                 //ORDER BY
                                 	//Last_Unit_Pull__c ASC, Account__c
                                 //LIMIT 55
                                ];
            
            /*for( Property__c property : fetchedProperties ) {
                property.Last_Unit_Pull__c = datetime.now();
                System.debug( property.Name );
            }*/
            
            List<Integration__c> ListIntegrations = new List<Integration__c>();
            Set<String> executedIntegrationIds = new Set<String>();
            
            for( Property__c property : fetchedProperties ) {
                System.debug( property.Name );
                try{ 
                    
                    List<String> strCredentials = new List<String>();
                    if( null != property.Group_Membership__c && credentials.containsKey( property.Group_Membership__c ) ) {
                        strCredentials = credentials.get( property.Group_Membership__c );
                    } else if( credentials.containsKey( property.Account__c ) ) {
                        strCredentials = credentials.get( property.Account__c );
                    }
                    
                    Map<String , String> Integration_map = new  Map<String , String>();
                    if( null != property.Group_Membership__c && IntegrationStatusmap.containsKey( property.Group_Membership__c ) ) {
                        Integration_map = IntegrationStatusmap.get( property.Group_Membership__c );
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
                        
                        List<Floor_Plan__c>	FloorPlans = [	SELECT
                                                          		Id, Floorplan_ID__c
                                                          	FROM
                                                          		Floor_Plan__c
                                                          	WHERE
                                                          		Id IN :FloorPlanIds
                                                          		AND Floorplan_ID__c != NULL
                                                          		AND Property__c =: property.Id
                                                          		AND Account__c =: property.Account__c
                                                          ];
                        if( !FloorPlans.isEmpty() ) {
                            Map<String, String> FloorPlanIdCodes 	= new Map<String, String>();
                            Set<String> FilteredFloorPlanIds 		= new Set<String>();
                            Set<String> FloorPlanCodes				= new Set<String>();
                            
                            for( Floor_Plan__c floorplan : FloorPlans ) {
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
                            this.UnitAvailability_Login( strCredentials, property.Customer_Prop_ID__c, strCredentials.get(7), isGCPullUnitScheduler );
                            
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
                                        } else {
                                           	Unit.Floor_Plan__c			= FloorPlanIdCodes.get( objGCPullUnitResponse.UnitInfo.get(UnitCode).get('UnitType') );
                                            Unit.Property__c 			= property.Id;
                                            Unit.Account__c				= property.Account__c;
                                        }
                                        
                                        Unit.Unit_ID__c				= UnitCode;
                                        Unit.Name 					= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitID' );
                                        Unit.Unit_Type__c 			= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitType' );
                                        Unit.Bedrooms__c 			= Decimal.valueOf( objGCPullUnitResponse.UnitInfo.get(Unit.Unit_ID__c).get( 'UnitBedrooms' ) );
                                    	Unit.Bathrooms__c 			= Decimal.valueOf( objGCPullUnitResponse.UnitInfo.get(Unit.Unit_ID__c).get( 'UnitBathrooms' ) );
                                        
                                        String MinSquareFeet 		= NULL == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MinSquareFeet' ) ? '0':objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MinSquareFeet' ) ;
                                        String MaxSquareFeet 		= NULL == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MaxSquareFeet' ) ? '0':objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MaxSquareFeet' ) ;
                                        
                                        if( '0' == MaxSquareFeet || MinSquareFeet == MaxSquareFeet )    
                                            Unit.Square_Feet__c 	= MinSquareFeet;
                                        else 
                                            Unit.Square_Feet__c 	= MaxSquareFeet;
                                        
                                    	Unit.Market_Rent__c 		= Decimal.valueOf( objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MarketRent' ) );
                                    	Unit.Occupancy_Status__c 	= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitOccupancyStatus' );
                                        Unit.Leased_Status__c 		= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'UnitLeasedStatus' );
                                        Unit.Deposit__c				= Decimal.valueOf( objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'Deposit' ) );
                                        Unit.Vacate_Date__c 		= NULL == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'VacateDate' ) ? NULL : Date.parse( objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'VacateDate' ) );
                                        Unit.Vacancy_Class__c 		= objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'VacancyClass' );
                                        Unit.Made_Ready_Date__c 	= NULL == objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MadeReadyDate' ) ? NULL : Date.parse( objGCPullUnitResponse.UnitInfo.get(UnitCode).get( 'MadeReadyDate' ) );
                                        
                                        Unit.Active__c = false;
                                        if( true == Integration_map.containsKey( Unit.Occupancy_Status__c.toLowerCase() ) && 'Active' == Integration_map.get( Unit.Occupancy_Status__c.toLowerCase() ) ) {
                                            Unit.Active__c = true;
                                        }
                                        
                                        Unit.Leased_Status__c = Unit.Leased_Status__c.replace( '_', ' ' );
                                        if( true == Integration_map.containsKey( ( Unit.Occupancy_Status__c + ' ' + Unit.Leased_Status__c ).toLowerCase() ) && 'Active' == Integration_map.get( ( Unit.Occupancy_Status__c + ' ' + Unit.Leased_Status__c ).toLowerCase() ) ){
                                            Unit.Active__c = true;
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
            //upsert fetchedProperties;
        }
    }
    
    public void UnitAvailability_Login( List<String> strCredentials, String strYardiPropertyId, String strVersionNumber, Boolean isGCPullUnitScheduler ) {
        if( true == isGCPullUnitScheduler ) {
           	if( '4' == strVersionNumber ) {
                strUnitAvailability_Login = yvn.UnitAvailability_Login( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4), strYardiPropertyId, strCredentials.get(5),strCredentials.get(6) );
          	} else {
              	strUnitAvailability_Login = yvn20.UnitAvailability_Login( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4), strYardiPropertyId, strCredentials.get(5),strCredentials.get(6) );
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