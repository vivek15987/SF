public with sharing class tempFloorPlansController {
    
    public YardiGCPushWsdltoApexController.ItfILSGuestCardSoap yvn; 
    public YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn20;
    
    public YardiGCPullFloorPlanResponseController PullFloorPlanResponse;
    public YardiGCPullPropertiesResponseController objGCPullPropertiesResponse;
    
    final String strInterfaceEntity;
    final String strInterfaceLicense;
    
    public String strUnitAvailability_Login;
    public String strPropertiesXml;
    public String strGetYardiFloorPlanResultInfo;
    
   	public List<Floor_Plan__c> arrobjFloorPlans                 = new List<Floor_Plan__c>();
    //public Map<String, Set<String>> strAccountProperties        = new Map<String, Set<String>>();
    //public Map<String, Set<String>> strAccountURLs              = new Map<String, Set<String>>();
    
    public Set<ID> AccountIds								= new Set<ID>();
    public Set<ID> PropertyIds 								= new Set<ID>();
    
    public tempFloorPlansController() {
        strInterfaceEntity      = 'Anyone Home';
        strInterfaceLicense     = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
        
    }
    
    public void YardiGCPullFloorPlan(Boolean isYardiGCPullFloorPlanScheduler) { 
        
        if( this.AccountIds.isEmpty() ) {
            return;
        }
        List<Integration__c> searchList = [ SELECT 
                                           		Id, Account__c, Name, Yardi_Database_Name__c, Push_Guest_Cards_to_Yardi__c, Yardi_Integration_Active__c, Yardi_Server_Name__c, Yardi_ID__c, Yardi_Password__c, Yardi_Platform_Type__c, Yardi_API_URL__c, Grouping__c, Yardi_Version_Number__c
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
                
                if( null != I.Grouping__c && !GroupingIds.contains( I.Grouping__c ) ) {
                    GroupingIds.add( I.Grouping__c );
                    credentials.put( I.Grouping__c, tempCredentials );
                } else if( !AccountIds.contains( I.Account__c ) ) {
                	AccountIds.add( I.Account__c );
                    credentials.put( I.Account__c, tempCredentials );
                }         
            }
            
            List<Property__c> fetchedProperties = new List<Property__c>();
        
            fetchedProperties = [SELECT 
                                 	Id, Name, Account__c, Account__r.Name, Customer_Prop_ID__c, Multi_Family_Property__c, Last_Yardi_FloorPlan_Pull__c, Group_Membership__c, Group_Membership__r.Name
                                 FROM 
                                 	Property__c 
                                 WHERE
                                 	Id IN :PropertyIds
                                 	//Customer_Prop_ID__c != NULL
                                 	//AND ( ( Group_Membership__c IN : GroupingIds ) OR ( Account__c IN : AccountIds AND Group_Membership__c = NULL ) ) 
                                 //ORDER BY
                                 	//Last_Yardi_FloorPlan_Pull__c ASC, Account__c
                                 //LIMIT 100
                                ];
            
            /*for( Property__c property : fetchedProperties ) {
                property.Last_Yardi_FloorPlan_Pull__c = datetime.now();
            }*/
            List<Integration__c> ListIntegrations = new List<Integration__c>();
            Set<String> executedIntegrationIds = new Set<String>();
            
            for( Property__c property : fetchedProperties ) {
                try{ 
                    /*if( null != p.Group_Membership__c && credentials.containsKey( p.Group_Membership__c ) ) {
                        System.debug( p.Name + '=> Integration Object:' + credentials.get( p.Group_Membership__c ).get( 0 ) + '=> groupName:' + p.Group_Membership__r.Name );
                        } else {
                        System.debug( p.Name + '=> Integration Object:' + credentials.get( p.Account__c ).get( 0 ) + '=> groupName:' + p.Group_Membership__r.Name );
                        }*/
                    List<String> strCredentials = new List<String>();
                    if( null != property.Group_Membership__c && credentials.containsKey( property.Group_Membership__c ) ) {
                        strCredentials = credentials.get( property.Group_Membership__c );
                    } else if( credentials.containsKey( property.Account__c ) ) {
                        strCredentials = credentials.get( property.Account__c );
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
                        
                        this.UnitAvailability_Login( strCredentials, property.Customer_Prop_ID__c, strCredentials.get(7), isYardiGCPullFloorPlanScheduler );
                        
                        String strGetUnitAvailability_LoginInfo = 'Invalid Response.';
                        
                        if( null != strUnitAvailability_Login ) {
                            if( 90000 > strUnitAvailability_Login.length() ) {
                                strGetUnitAvailability_LoginInfo = strUnitAvailability_Login;
                            } else {
                                if( null != PullFloorPlanResponse && !PullFloorPlanResponse.FloorPlanCodes.isEmpty() ) {
                                    strGetUnitAvailability_LoginInfo = strUnitAvailability_Login.substring(1, 90000) + 'Response is Valid. Success_Message length exceeded the limit. Cannot store response.';
                                } else {
                                    strGetUnitAvailability_LoginInfo = 'Response is Invalid. Error_Message length exceeded the limit. Cannot store response.';  
                                }
                            }
                        }
                        //strGetUnitAvailability_LoginInfo = Property.Name +':' + strGetUnitAvailability_LoginInfo;
                        String strId = strCredentials.get(9);
                        
                        if( !executedIntegrationIds.contains( strId ) ) {
                            executedIntegrationIds.add( strId );
                            Integration__c Integration = new Integration__c();
                            Integration.Id  = strId;
                            Integration.Get_FloorPlan_Result_Info__c = strGetUnitAvailability_LoginInfo;
                            ListIntegrations.add( Integration );
                        }
                        
                        Set<String> strFloorPlanCodes = new Set<String>(); 
                        if( null != PullFloorPlanResponse ) {
                            strFloorPlanCodes = PullFloorPlanResponse.FloorPlanCodes; 
                        }
                        
                        Set<String> strExcludedFloorPlanCodes   = new Set<String>();
                        System.debug( strFloorPlanCodes );
                        
                        if( !strFloorPlanCodes.isEmpty() ) {
                            List<Floor_Plan__c> FloorPlans = [ SELECT
                                                              Id, Name, Unit_Count__c, SQ_FT_Min__c, SQ_FT_Max__c, Market_Rent_Min__c, Market_Rent_Max__c, Effective_Rent_Min__c, Effective_Rent_Max__c, Application_Fee__c, Floorplan_ID__c
                                                              FROM
                                                              Floor_Plan__c
                                                              WHERE
                                                              Floorplan_ID__c IN : strFloorPlanCodes 
                                                              AND Property__c =: property.Id
                                                              AND Account__c =: property.Account__c
                                                             ];
                            
                            for( Floor_Plan__c FloorPlan: FloorPlans ) {
                                if( !PullFloorPlanResponse.FloorPlanInfo.isEmpty() ) {
                                    FloorPlan.Name                  = PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'Name' );
                                    FloorPlan.Unit_Count__c         = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'UnitCount' ) );
                                    FloorPlan.SQ_FT_Min__c          = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'SquareFeetMin' ) );
                                    FloorPlan.SQ_FT_Max__c          = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'SquareFeetMax' ) );
                                    FloorPlan.Market_Rent_Min__c    = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'MarketRentMin' ) );
                                    FloorPlan.Market_Rent_Max__c    = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'MarketRentMax' ) );
                                    FloorPlan.Effective_Rent_Min__c = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'EffectiveRentMin' ) );
                                    FloorPlan.Effective_Rent_Max__c = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'EffectiveRentMax' ) );
                                    FloorPlan.Application_Fee__c    = Decimal.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'ApplicationFee' ) );
                                    if( null != PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'Deposit' ) ) {
                                        FloorPlan.Deposit__c        = Decimal.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'Deposit' ) );
                                    }
                                    FloorPlan.Bathrooms__c          = Decimal.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'Bathroom' ) );
                                    FloorPlan.Bedrooms__c           = Decimal.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlan.Floorplan_ID__c ).get( 'Bedroom' ) );
                                    
                                    //update floorplan here.
                                    arrobjFloorPlans.add( FloorPlan );
                                }  
                                
                                strExcludedFloorPlanCodes.add( FloorPlan.Floorplan_ID__c );
                            }
                            
                            for( String FloorPlanCode : strFloorPlanCodes ) {
                                if( !strExcludedFloorPlanCodes.contains(FloorPlanCode) ) {
                                    
                                    Floor_Plan__c FloorPlan         = new Floor_Plan__c();
                                    FloorPlan.Name                  = PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'Name' );
                                    FloorPlan.Account__c            = property.Account__c;
                                    FloorPlan.Property__c           = property.Id;
                                    if( false == property.Multi_Family_Property__c ){
                                        FloorPlan.Active__c = False;
                                    }
                                    FloorPlan.Unit_Count__c         = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'UnitCount' ) );
                                    FloorPlan.SQ_FT_Min__c          = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'SquareFeetMin' ) );
                                    FloorPlan.SQ_FT_Max__c          = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'SquareFeetMax' ) );
                                    FloorPlan.Market_Rent_Min__c    = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'MarketRentMin' ) );
                                    FloorPlan.Market_Rent_Max__c    = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'MarketRentMax' ) );
                                    FloorPlan.Effective_Rent_Min__c = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'EffectiveRentMin' ) );
                                    FloorPlan.Effective_Rent_Max__c = Integer.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'EffectiveRentMax' ) );
                                    FloorPlan.Application_Fee__c    = Decimal.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'ApplicationFee' ) );
                                    if( null != PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'Deposit' ) ) {
                                        FloorPlan.Deposit__c        = Decimal.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'Deposit' ) );
                                    }
                                    FloorPlan.Bathrooms__c          = Decimal.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'Bathroom' ) );
                                    FloorPlan.Bedrooms__c           = Decimal.valueOf( PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'Bedroom' ) );
                                    FloorPlan.Floorplan_ID__c       = FloorPlanCode;
                                    //insert floorplans
                                    arrobjFloorPlans.add( FloorPlan );
                                }
                            }
                        }
                    } 
                    
                } catch( Exception e ) {
                    System.debug( e.getMessage() );
                    System.debug( e.getStackTraceString() );
					System.debug( 'Error for Property: ' + property.Name );
                }
            }
            
            try {
            	//upsert fetchedProperties;
            	upsert ListIntegrations;    
            } catch( Exception e ) {
                    System.debug( 'Upsert Error Messages on Integration/Property object ' + e.getMessage() );
                    System.debug( e.getStackTraceString() );
					
            }           
        }
        
        for(Floor_Plan__c f:arrobjFloorPlans){
            System.debug(f);
        }
    }
    
    public void UnitAvailability_Login( List<String> strCredentials, String strYardiPropertyId, String strVersionNumber, Boolean isYardiGCPullFloorPlanScheduler ) {
        if( true == isYardiGCPullFloorPlanScheduler ) {
            if( '4' == strVersionNumber ) {
                strUnitAvailability_Login = yvn.UnitAvailability_Login( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4), strYardiPropertyId, strCredentials.get(5),strCredentials.get(6) );
            } else {
                strUnitAvailability_Login = yvn20.UnitAvailability_Login( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4), strYardiPropertyId, strCredentials.get(5),strCredentials.get(6) );
            } 
        }
        
        if( !String.isEmpty(strUnitAvailability_Login) && -1 != strUnitAvailability_Login.indexOf('<Floorplan') ) {
        	Integer StartIndex = strUnitAvailability_Login.indexOf('<Floorplan');
        	Integer LastIndex = strUnitAvailability_Login.lastIndexOf('</Floorplan>');
            
        	String FloorPlansStringParts = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <UnitAvailability_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20"> <UnitAvailability_LoginResult> <PhysicalProperty xsi:noNamespaceSchemaLocation="" xmlns:MITS="http://my-company.com/namespace" xmlns=""> <Property> ' + strUnitAvailability_Login.substring(StartIndex, LastIndex) + '</Floorplan></Property> </PhysicalProperty> </UnitAvailability_LoginResult> </UnitAvailability_LoginResponse> </soap:Body> </soap:Envelope>';
               
            if( null != FloorPlansStringParts ) {
                XmlStreamReader reader      = new XmlStreamReader( FloorPlansStringParts );
                PullFloorPlanResponse       = new YardiGCPullFloorPlanResponseController();
                
                if( '4' == strVersionNumber ) {
                    PullFloorPlanResponse.parsePullFloorPlanResponse40( reader );
                } else {
                    PullFloorPlanResponse.parsePullFloorPlanResponse20( reader );
                }
            }
        }
    }
    
    public void GetPropertyConfigurations( List<String> strCredentials, String strVersionNumber, Boolean isYardiGCPullFloorPlanScheduler ) {       
        
        if( true == isYardiGCPullFloorPlanScheduler ) {
            if( '4' == strVersionNumber ) {
                strPropertiesXml = yvn.GetPropertyConfigurations( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4),strCredentials.get(5),strCredentials.get(6) );
            } else {
                strPropertiesXml = yvn20.GetPropertyConfigurations( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4),strCredentials.get(5),strCredentials.get(6) );
            } 
            System.debug( strPropertiesXml );
        }      
        if( null != strPropertiesXml ) {
            XmlStreamReader reader          = new XmlStreamReader( strPropertiesXml );
            objGCPullPropertiesResponse     = new YardiGCPullPropertiesResponseController();
            objGCPullPropertiesResponse.parsePropertyConfigurationsResponse( reader );
        }
    }
}