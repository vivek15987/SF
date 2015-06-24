public with sharing class Nano_YardiGCPullFloorPlanController {
    
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
    
    public Set<ID> AccountIds								= new Set<ID>();
    public Set<ID> PropertyIds 								= new Set<ID>();
    
    public Nano_YardiGCPullFloorPlanController() {
        strInterfaceEntity      = 'Anyone Home';
        strInterfaceLicense     = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
        
    }
    
    public void YardiGCPullFloorPlan() { 
        
        if( !this.AccountIds.isEmpty() ) {
            List<Integration__c> searchList = [	SELECT 
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
                                        Id, Name, Account__c, Account__r.Name, Customer_Prop_ID__c, Multi_Family_Property__c, Last_Yardi_FloorPlan_Pull__c, Group_Membership__c, Group_Membership__r.Name, Sub_Prop_IDs__c,
                                        ( SELECT Id, Name, Unit_Count__c, SQ_FT_Min__c, SQ_FT_Max__c, Market_Rent_Min__c, Market_Rent_Max__c, Effective_Rent_Min__c, Effective_Rent_Max__c, Application_Fee__c, Floorplan_ID__c, External_Sub_Prop_ID__c FROM Floor_Plans__r )
                                     FROM 
                                     	Property__c 
                                     WHERE
                                     	Id IN :PropertyIds
                                     ];
                
                List<Integration__c> ListIntegrations = new List<Integration__c>();
                Set<String> executedIntegrationIds = new Set<String>();
                
                for( Property__c Property : fetchedProperties ) {
                    try{ 
                        
                        List<String> strCredentials = new List<String>();
                        if( null != Property.Group_Membership__c && credentials.containsKey( Property.Group_Membership__c ) ) {
                            strCredentials = credentials.get( Property.Group_Membership__c );
                        } else if( credentials.containsKey( Property.Account__c ) ) {
                            strCredentials = credentials.get( Property.Account__c );
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
                            
                            List<String> strSubPropertyCodes = new List<String>();
                            if( true == Property.Multi_Family_Property__c && null != Property.Sub_Prop_IDs__c ) {
                                String tempString = Property.Sub_Prop_IDs__c;
                                tempString = tempString.replaceAll('(\\s+)', '');
                                List<String> tempstrSubPropertyCodes = tempString.split(',', 0);
                                strSubPropertyCodes.addAll( tempstrSubPropertyCodes );
                            }
                            
                            strSubPropertyCodes.add( Property.Customer_Prop_ID__c );
                            
                            for( String SubPropertyCode : strSubPropertyCodes ) {
                                Boolean isMainProperty = true;
                                if( true == Property.Multi_Family_Property__c && SubPropertyCode != Property.Customer_Prop_ID__c ) {
                                    isMainProperty = false;
                                }
                            
                            
                            this.UnitAvailability_Login( strCredentials, SubPropertyCode, strCredentials.get(7) );
                            
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
                            
                            if( !strFloorPlanCodes.isEmpty() ) {
                                
                                Map<String, String> floorPlanCodeIds = new Map<String, String>();
                                
                                if( !Property.Floor_Plans__r.isEmpty() ) {
                                    for( Floor_Plan__c fp : Property.Floor_Plans__r ) {
                                        if( strFloorPlanCodes.contains( fp.Floorplan_ID__c ) ) {
                                         	if( null == fp.External_Sub_Prop_ID__c && true == isMainProperty )
                                            	floorPlanCodeIds.put( fp.Floorplan_ID__c, fp.Id );  
                                            else if( fp.External_Sub_Prop_ID__c == SubPropertyCode )
                                                floorPlanCodeIds.put( fp.Floorplan_ID__c, fp.Id );
                                        } 
                                    }
                                }
                                
                                for( String FloorPlanCode : strFloorPlanCodes ) { 
                                	Floor_Plan__c FloorPlan = new Floor_Plan__c();
                                    
                                    if( floorPlanCodeIds.containsKey( FloorPlanCode ) ) {
                                        FloorPlan.Id = floorPlanCodeIds.get( FloorPlanCode );
                                    } else {
                                        FloorPlan.Account__c = Property.Account__c;
                                        FloorPlan.Property__c = Property.Id;
                                        FloorPlan.Floorplan_ID__c = FloorPlanCode;
                                        if( false == Property.Multi_Family_Property__c ){
                                            FloorPlan.Active__c = False;
                                        }
                                    }
                                    
                                    if( true == Property.Multi_Family_Property__c && false == isMainProperty ) {
                                        FloorPlan.External_Sub_Prop_ID__c = SubPropertyCode;
                                    }
                                    
                                    FloorPlan.Name                  = ( null != PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'Name' ) ) ? PullFloorPlanResponse.FloorPlanInfo.get( FloorPlanCode ).get( 'Name' ) : FloorPlanCode;
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
                                   
                                    arrobjFloorPlans.add( FloorPlan );
                                }
                            }
                            }
                        } 
                        
                    } catch( Exception e ) {
                        System.debug( e.getMessage() );
                        System.debug( e.getStackTraceString() );
                        System.debug( 'Error for Property: ' + Property.Name );
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
        }
    }
    
    public void UnitAvailability_Login( List<String> strCredentials, String strYardiPropertyId, String strVersionNumber) {
        if( !Test.isRunningTest() ) {
            if( '4' == strVersionNumber ) {
                strUnitAvailability_Login = yvn.UnitAvailability_Login( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4), strYardiPropertyId, strCredentials.get(5),strCredentials.get(6) );
            } else {
                strUnitAvailability_Login = yvn20.UnitAvailability_Login( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4), strYardiPropertyId, strCredentials.get(5),strCredentials.get(6) );
            } 
        } else {
            if( '4' == strVersionNumber ) {
                strUnitAvailability_Login = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <UnitAvailability_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard"> <UnitAvailability_LoginResult> <PhysicalProperty xsi:noNamespaceSchemaLocation="" xmlns:MITS="http://my-company.com/namespace" xmlns=""> <Property IDValue="anyhome1"> <PropertyID> <Identification IDValue="anyhome1"/> <MarketingName>Anyone Home 1 Test Prop</MarketingName> <Address AddressType="property"> <AddressLine1>430 South Fairview Avenue</AddressLine1> <AddressLine2/> <City>Goleta</City> <State>CA</State> <PostalCode>93117</PostalCode> </Address> </PropertyID> <ILS_Identification ILS_IdentificationType="Unspecified" RentalType="Unspecified"/> <Information> <StructureType>Unspecified</StructureType> <UnitCount>22</UnitCount> </Information> <Amenity AmenityType="CoverPark"> <Description>Garage</Description> </Amenity> <Amenity AmenityType="Other"> <Description>View - Ocean</Description> </Amenity> <Amenity AmenityType="Other"> <Description>Fireplace</Description> </Amenity> <Floorplan IDValue="3bd3bh"> <Name>3 bedroom 3 bath</Name> <UnitCount>2</UnitCount> <Room RoomType="Bedroom"> <Count>3.00</Count> <Comment/> </Room> <Room RoomType="Bathroom"> <Count>3.00</Count> <Comment/> </Room> <SquareFeet Min="1875" Max="1875"/> <MarketRent Min="2000" Max="2000"/> <EffectiveRent Min="2000" Max="2000"/> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="1500.00"/> </Amount> </Deposit> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> <AdminFee>0</AdminFee> <ApplicationFee>0</ApplicationFee> <BrokerFee>0</BrokerFee> </Fee> </Floorplan><Floorplan IDValue="3bd"> <Name>3 bedroom 3</Name> <UnitCount>2</UnitCount> <Room Type="Bedroom"> <Count>3.00</Count> <Comment/> </Room> <Room Type="Bathroom"> <Count>3.00</Count> <Comment/> </Room> <SquareFeet Min="1875" Max="1875"/> <MarketRent Min="2000" Max="2000"/> <EffectiveRent Min="2000" Max="2000"/> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <Value>1500.00</Value> </Amount> </Deposit> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> <AdminFee>0</AdminFee> <ApplicationFee>0</ApplicationFee> </Fee> </Floorplan></Property> </PhysicalProperty> </UnitAvailability_LoginResult> </UnitAvailability_LoginResponse> </soap:Body> </soap:Envelope>';
            } else {
                strUnitAvailability_Login = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <UnitAvailability_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard"> <UnitAvailability_LoginResult> <PhysicalProperty xsi:noNamespaceSchemaLocation="" xmlns:MITS="http://my-company.com/namespace" xmlns=""> <Property IDValue="anyhome1"> <PropertyID> <Identification IDValue="anyhome1"/> <MarketingName>Anyone Home 1 Test Prop</MarketingName> <Address AddressType="property"> <AddressLine1>430 South Fairview Avenue</AddressLine1> <AddressLine2/> <City>Goleta</City> <State>CA</State> <PostalCode>93117</PostalCode> </Address> </PropertyID> <ILS_Identification ILS_IdentificationType="Unspecified" RentalType="Unspecified"/> <Information> <StructureType>Unspecified</StructureType> <UnitCount>22</UnitCount> </Information> <Amenity AmenityType="CoverPark"> <Description>Garage</Description> </Amenity> <Amenity AmenityType="Other"> <Description>View - Ocean</Description> </Amenity> <Amenity AmenityType="Other"> <Description>Fireplace</Description> </Amenity> <Floorplan IDValue="3bd3bh"> <Name>3 bedroom 3 bath</Name> <UnitCount>2</UnitCount> <Room Type="Bedroom"> <Count>3.00</Count> <Comment/> </Room> <Room Type="Bathroom"> <Count>3.00</Count> <Comment/> </Room> <SquareFeet Min="1875" Max="1875"/> <MarketRent Min="2000" Max="2000"/> <EffectiveRent Min="2000" Max="2000"/> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <Value>1500.00</Value> </Amount> </Deposit> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> <AdminFee>0</AdminFee> <ApplicationFee>0</ApplicationFee> </Fee> </Floorplan><Floorplan IDValue="3bd"> <Name>3 bedroom 3</Name> <UnitCount>2</UnitCount> <Room Type="Bedroom"> <Count>3.00</Count> <Comment/> </Room> <Room Type="Bathroom"> <Count>3.00</Count> <Comment/> </Room> <SquareFeet Min="1875" Max="1875"/> <MarketRent Min="2000" Max="2000"/> <EffectiveRent Min="2000" Max="2000"/> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <Value>1500.00</Value> </Amount> </Deposit> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> <AdminFee>0</AdminFee> <ApplicationFee>0</ApplicationFee> </Fee> </Floorplan></Property> </PhysicalProperty> </UnitAvailability_LoginResult> </UnitAvailability_LoginResponse> </soap:Body> </soap:Envelope>';
            }
        }
        
        PullFloorPlanResponse       = new YardiGCPullFloorPlanResponseController();

        if( !String.isEmpty(strUnitAvailability_Login) && -1 != strUnitAvailability_Login.indexOf('<Floorplan') ) {
        	Integer StartIndex = strUnitAvailability_Login.indexOf('<Floorplan');
        	Integer LastIndex = strUnitAvailability_Login.lastIndexOf('</Floorplan>');
            
        	String FloorPlansStringParts = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <UnitAvailability_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20"> <UnitAvailability_LoginResult> <PhysicalProperty xsi:noNamespaceSchemaLocation="" xmlns:MITS="http://my-company.com/namespace" xmlns=""> <Property> ' + strUnitAvailability_Login.substring(StartIndex, LastIndex) + '</Floorplan></Property> </PhysicalProperty> </UnitAvailability_LoginResult> </UnitAvailability_LoginResponse> </soap:Body> </soap:Envelope>';
               
            if( null != FloorPlansStringParts ) {
                XmlStreamReader reader      = new XmlStreamReader( FloorPlansStringParts );
                if( '4' == strVersionNumber ) {
                    PullFloorPlanResponse.parsePullFloorPlanResponse40( reader );
                } else {
                    PullFloorPlanResponse.parsePullFloorPlanResponse20( reader );
                }
            }
        }
    }
    
    public void GetPropertyConfigurations( List<String> strCredentials, String strVersionNumber ) {       
        
        if( !Test.isRunningTest() ) {
            if( '4' == strVersionNumber ) {
                strPropertiesXml = yvn.GetPropertyConfigurations( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4),strCredentials.get(5),strCredentials.get(6) );
            } else {
                strPropertiesXml = yvn20.GetPropertyConfigurations( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4),strCredentials.get(5),strCredentials.get(6) );
            } 
            System.debug( strPropertiesXml );
        } else {
            strPropertiesXml = '<GetPropertyConfigurationsResult><Properties><Property><Code>anyhome1</Code><MarketingName>Anyone Home 1 Test Prop</MarketingName><AddressLine1>430 South Fairview Avenue</AddressLine1><AddressLine2 /><AddressLine3 /><City>Goleta</City><State>CA</State><PostalCode>93117</PostalCode></Property></Properties></GetPropertyConfigurationsResult>';
        }      
        
        if( null != strPropertiesXml ) {
            XmlStreamReader reader          = new XmlStreamReader( strPropertiesXml );
            objGCPullPropertiesResponse     = new YardiGCPullPropertiesResponseController();
            objGCPullPropertiesResponse.parsePropertyConfigurationsResponse( reader );
        }
    }
}