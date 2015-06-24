public with sharing class Nano_YardiGCPullPropertiesController {
	  
    public YardiGCPushWsdltoApexController.ItfILSGuestCardSoap yvn; 
    public YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn20;
 	public YardiGCPullPropertiesResponseController objGCPullPropertiesResponse;
     
    final String strInterfaceEntity;
    final String strInterfaceLicense;
    
    public String strPropertiesXml;
    public String strGetPropertyResultInfo;

    public List<String> strCredentials      					= new List<String>();
    public Set<String> PropertyCodes        					= new Set<String>();
    public List<Property__c> arrobjProperties					= new List<Property__c>();
    public Map<String, Set<String>> strAccountProperties		= new Map<String, Set<String>>();
    public Map<String, Set<String>> strAccountURLs				= new Map<String, Set<String>>();
    
    //Constructor
    public Nano_YardiGCPullPropertiesController() {
		strInterfaceEntity 		= 'Anyone Home';
    	strInterfaceLicense 	= 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
    
    }
    
    public void YardiGCPullPropertyConfigurations(Boolean isYardiGCPullPropertiesScheduler) { 
    	List<Integration__c> searchList = [ SELECT 
                                                Account__c, Name, Yardi_Database_Name__c, Push_Guest_Cards_to_Yardi__c, Yardi_Integration_Active__c, Yardi_Server_Name__c, Yardi_ID__c, Yardi_Password__c, Yardi_Platform_Type__c, Yardi_API_URL__c, Yardi_SR_API_URL__c, Grouping__c, Yardi_Version_Number__c,Do_Not_Update_Names_Of__c
                                             FROM
                                                Integration__c
                                             WHERE
 												Yardi_Integration_Active__c = true 
         									  	AND	Get_Yardi_Property_Info__c != null 
                                           ];
        

        if( !searchList.isEmpty() ) {
            
            List<Integration__c> ListIntegrations = new List<Integration__c>();
            
            for( Integration__c I :searchList ) {  
               	strCredentials.clear();
                strCredentials.add(I.Yardi_ID__c);
                strCredentials.add(I.Yardi_Password__c);
                strCredentials.add(I.Yardi_Server_Name__c);
                strCredentials.add(I.Yardi_Database_Name__c);
                strCredentials.add(I.Yardi_Platform_Type__c);
                strCredentials.add(strInterfaceEntity);
                strCredentials.add(strInterfaceLicense);  
                strCredentials.add(I.Do_Not_Update_Names_Of__c);
                
                if( '4' == I.Yardi_Version_Number__c ) {
                    yvn = new YardiGCPushWsdltoApexController.ItfILSGuestCardSoap();
                  	yvn.endpoint_x = I.Yardi_API_URL__c;                  
              		yvn.timeout_x = 120000; 
                } else {
                    yvn20 = new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
                    yvn20.endpoint_x = I.Yardi_API_URL__c;
                    yvn20.timeout_x = 120000;
                }
               
               	I.Get_Yardi_Property_Result_Info__c = strGetPropertyResultInfo;
                if( strAccountURLs.isEmpty() || !strAccountURLs.containsKey( I.Account__c ) || ( strAccountURLs.containsKey( I.Account__c) && !strAccountURLs.get(I.Account__c).contains(I.Yardi_API_URL__c) ) ) {
                   	System.debug( I.Name );
                   
                    Set<String> tempSet = new Set<String>();
                    if( strAccountURLs.containsKey( I.Account__c) ) {
                       tempSet = strAccountURLs.get( I.Account__c );
                    } 
                    
                    tempSet.add( I.Yardi_API_URL__c );
                    strAccountURLs.put( I.Account__c, tempSet );
                    
                    try{
                        this.GetPropertyConfigurations( strCredentials, I.Yardi_Version_Number__c, isYardiGCPullPropertiesScheduler );
                                            
                        Set<String> strExcludedPropertyCodes 	= new Set<String>();
                        Set<String> strPropertyCodes 			= new Set<String>();
                        
                        for(String propertycode: objGCPullPropertiesResponse.PropertyCodes ) {
                            if( !strAccountProperties.containsKey( I.Account__c ) || ( strAccountProperties.containsKey( I.Account__c ) && !strAccountProperties.get( I.Account__c ).contains( propertycode ) ) ) {
                                strPropertyCodes.add( propertycode );
                            }
                        } 
                        
                        strGetPropertyResultInfo = 'Invalid Response.';
                        
                        if( null != strPropertiesXml ) {
                            if( 90000 > strPropertiesXml.length() ) {
                                strGetPropertyResultInfo = strPropertiesXml;
                                
                            } else {
                                if( null != objGCPullPropertiesResponse && !objGCPullPropertiesResponse.PropertyCodes.isEmpty() ) {
                                    strGetPropertyResultInfo = 'Response is Valid. Success_Message length exceeded the limit. Cannot store response.';
                                } else {
                                    strGetPropertyResultInfo = 'Response is Invalid. Error_Message length exceeded the limit. Cannot store response.';  
                                }
                            }
                        }
                        
                        I.Get_Yardi_Property_Result_Info__c = strGetPropertyResultInfo; 
                        ListIntegrations.add( I );
                        if( !strPropertyCodes.isEmpty() ) {
                            List<Property__c> Properties = [SELECT 
                                                            	Id, Account__c, Active__c, Address_Line_1__c, City__c, State__c, Zip_Code__c, Customer_Prop_ID__c, Sub_Prop_IDs__c, Multi_Family_Property__c 
                                                            FROM
                                                            	Property__c
                                                            WHERE 
                                                            	Customer_Prop_ID__c IN : strPropertyCodes AND Account__c =: I.Account__c ];
                            
                            for( Property__c property: Properties ) {
                                if( true == property.Multi_Family_Property__c && null != property.Sub_Prop_IDs__c ) {
                                    String tempString = property.Sub_Prop_IDs__c;
                                    tempString = tempString.replaceAll('(\\s+)', '');
                                    List<String> strSubPropertyCodes = tempString.split(',', 0);
                                    strExcludedPropertyCodes.addAll(strSubPropertyCodes);
                                }
                            }
                            
                            for( Property__c property: Properties ) {
                                                            
                                property.Address_Line_1__c 	= objGCPullPropertiesResponse.PropConfResponse.get(property.Customer_Prop_ID__c).get('AddressLine1');
                                property.City__c 			= objGCPullPropertiesResponse.PropConfResponse.get(property.Customer_Prop_ID__c).get('City');
                                property.State__c 			= objGCPullPropertiesResponse.PropConfResponse.get(property.Customer_Prop_ID__c).get('State');
                                property.Zip_Code__c 		= objGCPullPropertiesResponse.PropConfResponse.get(property.Customer_Prop_ID__c).get('PostalCode');
                                Boolean DoNotUpdatePropertyName = ( null != strCredentials.get( 8 ) &&  strCredentials.get( 8 ).contains( 'Properties' ) ? true :false );
                                if( false == DoNotUpdatePropertyName )
                                	property.Name	 			= objGCPullPropertiesResponse.PropConfResponse.get(property.Customer_Prop_ID__c).get('MarketingName');
                                
                                /*if( property.Active__c == 'No' ) {
                                    property.Active__c 		= 'Newly Active Queue';
                                }*/
                                
                                if( !strExcludedPropertyCodes.contains( property.Customer_Prop_ID__c ) ) {
                                    arrobjProperties.add(property);
                                    strExcludedPropertyCodes.add( property.Customer_Prop_ID__c );
                                }
                            }                          
                           
                            for( String PropertyCode : strPropertyCodes ) {
                                if( !strExcludedPropertyCodes.contains(PropertyCode) ) {
                                    
                                    Property__c property 			= new Property__c();
                                    property.Active__c 				= 'New Property Queue';
                                    property.Address_Line_1__c 		= objGCPullPropertiesResponse.PropConfResponse.get(PropertyCode).get('AddressLine1');
                                    property.City__c 				= objGCPullPropertiesResponse.PropConfResponse.get(PropertyCode).get('City');
                                    property.State__c 				= objGCPullPropertiesResponse.PropConfResponse.get(PropertyCode).get('State');
                                    property.Zip_Code__c 			= objGCPullPropertiesResponse.PropConfResponse.get(PropertyCode).get('PostalCode');
                                    property.Name 					= objGCPullPropertiesResponse.PropConfResponse.get(PropertyCode).get('MarketingName');
                                    property.Price__c				= 1;
                                    property.Account__c     		= I.Account__c;
                                    property.Square_Footage__c 		= 1;
                                    property.Bed_Count__c 			= 1;
                                    property.Bath_Count__c 			= 1;
                                    property.Lease_Terms__c 		= 1;
                                    property.Customer_Prop_ID__c 	= PropertyCode;
                                    
                                    arrobjProperties.add(property);
                                }     
                            }
                            
                            if( strAccountProperties.containsKey( I.Account__c ) ) {
                                Set<String> temp = new Set<String>();
                                temp.addAll( strAccountProperties.get( I.Account__c ) );
                                temp.addAll( strPropertyCodes );
                                strAccountProperties.put( I.Account__c, temp );
                            } else {
                                strAccountProperties.put( I.Account__c, strPropertyCodes );
                            }
                        }
                    } catch ( Exception e ) {
                        System.Debug( 'ErrorMessage: ' + e.getMessage() );
                        System.Debug( 'ErrorStackTrace: ' + e.getStackTraceString() );
                        System.Debug( 'Error in Integration object: ' + I.Name );
                    }
                } else {
                    ListIntegrations.add( I );
                }
            }
            upsert ListIntegrations;
      	}
    }
    
    public void GetPropertyConfigurations( List<String> strCredentials, String strVersionNumber, Boolean isYardiGCPullPropertiesScheduler ) {       
        
        if( true == isYardiGCPullPropertiesScheduler ) {
           	if( '4' == strVersionNumber ) {
                strPropertiesXml = yvn.GetPropertyConfigurations( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4),strCredentials.get(5),strCredentials.get(6) );
          	} else {
              	strPropertiesXml = yvn20.GetPropertyConfigurations( strCredentials.get(0),strCredentials.get(1),strCredentials.get(2),strCredentials.get(3),strCredentials.get(4),strCredentials.get(5),strCredentials.get(6) );
           	} 
        }      
        System.debug( strPropertiesXml );
        XmlStreamReader reader 			= new XmlStreamReader( strPropertiesXml );
        objGCPullPropertiesResponse 	= new YardiGCPullPropertiesResponseController();
        objGCPullPropertiesResponse.parsePropertyConfigurationsResponse( reader );
        
    }
}