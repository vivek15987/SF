public with sharing class HBHPullPropertiesController {
    public String responseJsonString;
    public Set<String> PropertyCodes = new Set<String>();
    public List<Grouping__c> NeedtoCreateGroups = new List<Grouping__c>();
    public List<Property__c> arrobjProperties = new List<Property__c>();
    public Map<String, Unit__c> arrobjUnits = new Map<String, Unit__c>();
    public Map<String, String> GroupingNamesPerId = new Map<String, String>();
    public Map<String, String> PropertiesIdPerGroupName = new Map<String, String>();
    public Set<String> NewUniqueGroupNames = new Set<String>();
    public Set<String> GroupingsWithDoNotUpdateNames = new Set<String>();
    
    public void HBHPullProperties() {
         Map<String, List<Integration__c>> IntegrationObjectsPerAccount = new Map<String,List<Integration__c>>();
        List<AggregateResult> ActiveAccountList = [SELECT
                                                   Account__c
                                                   FROM
                                                   Integration__c
                                                   WHERE
                                                   HBH_Integration_Active__c = true AND Get_HBH_Properties__c != NULL
                                                   GROUP BY
                                                   Account__c]; 
        
        if( !ActiveAccountList.isEmpty() ) {
            Set<String>AccoutIds = new Set<String>();
            for( AggregateResult ActiveAccount :ActiveAccountList ){
                AccoutIds.add( String.valueOf( ActiveAccount.get('Account__c') ) );
            }
            
            List<Integration__c> IntegationsOfAllAccounts = [ SELECT 
                                                             Id, Account__c, Name, Do_Not_Update_Names_Of__c, Grouping__c
                                                             FROM
                                                             Integration__c
                                                             WHERE
                                                             Account__c IN :AccoutIds ORDER BY Grouping__c];
            for( String AccountId :AccoutIds ) {
                List<Integration__c> Integrations = new List<Integration__c>();
                for( Integration__c i :IntegationsOfAllAccounts ){
                    if( i.Account__c == AccountId ) {
                        Integrations.add( i );
                    }
                }
                IntegrationObjectsPerAccount.put( AccountId , Integrations );
            }
        }
        if( !ActiveAccountList.isEmpty() ) {
            try {
                for( AggregateResult ActiveAccount: ActiveAccountList ) {
                    Integration__c I = [ SELECT 
                                        Id, Name, HBH_API_URL__c, Account__c, Do_not_update_property_name__c
                                        FROM
                                        Integration__c
                                        WHERE
                                        HBH_Integration_Active__c = true AND Get_HBH_Properties__c != NULL AND Account__c =: String.valueOf(ActiveAccount.get('Account__c'))
                                        LIMIT 1
                                       ];
                    if( null != I ) {
                        this.HBHGetProperties( I.HBH_API_URL__c );
                        if( !PropertyCodes.isEmpty() ) {
                            
                            List<Integration__c> IntegationsPerAccount = new List<Integration__c>();
                            if( IntegrationObjectsPerAccount.containsKey( I.Account__c ) ) {
                                IntegationsPerAccount = IntegrationObjectsPerAccount.get( I.Account__c );
                            }
                            List<Property__c> Properties = new List<Property__c>();
                            Properties = [ SELECT Id, Name, Active__c, Group_Membership__c, Group_Membership__r.Name, HBH_Prop_Id__c, Account__c, ( SELECT Id, Name FROM Units__r WHERE Unit_ID__c != NULL LIMIT 1 ) FROM Property__c WHERE HBH_Prop_Id__c != NULL AND Account__c =: I.Account__c];
                            
                            Map<String, String> PropertyCodesIds = new Map<String, String>();
                            Map<String, String> PropertyCodesActive = new Map<String, String>();
                            Map<String, Property__c> PropertyCodesObjects = new Map<String, Property__c>();
                            Map<String, String> GroupIdPerPropertyId = new Map<String, String>();
                            
                            for( Property__c Property: Properties ) {
                                GroupingNamesPerId.put( Property.Group_Membership__r.Name , Property.Group_Membership__c );
                                PropertyCodesIds.put( Property.HBH_Prop_Id__c, Property.Id );
                                PropertyCodesObjects.put( Property.HBH_Prop_Id__c, Property );
                                PropertyCodesActive.put( Property.HBH_Prop_Id__c, Property.Active__c );
                                if( null != Property.Group_Membership__c )
                                    GroupIdPerPropertyId.put( Property.Id, Property.Group_Membership__c );
                            }
                            
                            List<Object> JSONdeserializedResponse = (List<Object>) JSON.deserializeUntyped( responseJsonString );
                            Set<String> ProcessedPropertyCodes = new Set<String>();
                            
                            for( Object JSONPropertyObject : JSONdeserializedResponse ) {
                                String PropertyCode;
                                try {
                                    Map<String, object> JSONPropertyObjectElements = ( Map<String, Object> ) JSONPropertyObject;
                                    if( JSONPropertyObjectElements.containsKey('property_id') ) {
                                        Property__c p = new Property__c();
                                        Unit__c Unit = new Unit__c();
                                        PropertyCode = (String)JSONPropertyObjectElements.get('property_id'); 
                                        if(!ProcessedPropertyCodes.contains(PropertyCode)){
                                            ProcessedPropertyCodes.add(PropertyCode);
                                            
                                            if( PropertyCodesIds.containsKey( PropertyCode ) ) {
                                                p.Id 					= PropertyCodesIds.get( PropertyCode );
                                                p.Account__c     		= I.Account__c;
                                                p.HBH_Prop_Id__c 		= PropertyCode;
                                                if( PropertyCodesActive.get( PropertyCode ) == 'No' ) 
                                                    p.Active__c 		= 'Newly Active Queue';
                                            } else {
                                                p.HBH_Prop_Id__c 		= PropertyCode;
                                                p.Active__c 			= 'New Property Queue';     
                                                p.Price__c 				= 1;
                                                p.Account__c     		= I.Account__c;
                                                p.Square_Footage__c 	= 1;
                                                p.Bed_Count__c 			= 1;
                                                p.Bath_Count__c 		= 1;
                                                p.Lease_Terms__c 		= 1;
                                            }
                                            
                                            if( PropertyCodesObjects.containsKey(PropertyCode) ) {
                                                if( !PropertyCodesObjects.get(PropertyCode).Units__r.isEmpty() ) {
                                                    for( Unit__c u :PropertyCodesObjects.get(PropertyCode).Units__r ) {
                                                        Unit.Id = u.Id;
                                                    }	
                                                }
                                            }
                                            Unit.Account__c = p.Account__c;
                                            
                                             Boolean DoNotUpdatePropertyName=false;
                                    if( IntegationsPerAccount.size() > 0 ) {
                                        for( Integration__c integration_obj: IntegationsPerAccount ) {
                                            if( integration_obj.Grouping__c == null ) {
                                                if( integration_obj.Do_Not_Update_Names_Of__c != null && integration_obj.Do_Not_Update_Names_Of__c.contains( 'Properties' ) ) {
                                                    DoNotUpdatePropertyName = true;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        for( Integration__c integration_obj: IntegationsPerAccount ) {
                                            if( integration_obj.Grouping__c != null && integration_obj.Do_Not_Update_Names_Of__c != null && integration_obj.Do_Not_Update_Names_Of__c.contains( 'Properties' ) ) {
                                                GroupingsWithDoNotUpdateNames.add( integration_obj.Grouping__c );
                                            }
                                        }
                                        
                                        if( false == DoNotUpdatePropertyName && GroupIdPerPropertyId.containsKey( p.Id ) && GroupingsWithDoNotUpdateNames.contains( GroupIdPerPropertyId.get( p.Id ) ) ) {
                                            DoNotUpdatePropertyName = true;
                                        }
                                    }
                                            if( ( !PropertyCodesIds.containsKey(PropertyCode) || false == DoNotUpdatePropertyName ) && JSONPropertyObjectElements.containsKey('property_title') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('property_title') ) )
                                                p.Name = (String) JSONPropertyObjectElements.get('property_title');
                                            
                                            if( JSONPropertyObjectElements.containsKey('property_type') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('property_type') ) ) {
                                                if( 'Single Family Home' == JSONPropertyObjectElements.get('property_type') ) {
                                                    p.Type_of_Property__c = 'Single Family Dwelling';
                                                    p.Multi_Family_Property__c = false;
                                                }
                                            } 
                                            
                                            //Assigning Group Membership
                                            if( JSONPropertyObjectElements.containsKey('field_office') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('field_office') ) ) {
                                                
                                                String GroupName = (String) JSONPropertyObjectElements.get('field_office');
                                                if( GroupingNamesPerId.containsKey( GroupName ) ) {
                                                    //Assign existing groups
                                                    p.Group_Membership__c = GroupingNamesPerId.get( GroupName );
                                                } else {
                                                    //Need to create new group & assign it to that property
                                                    Grouping__c NewGroup = new Grouping__c();
                                                    NewGroup.Account__c = I.Account__c;
                                                    NewGroup.Name = GroupName;
                                                    if( !NewUniqueGroupNames.contains( GroupName ) ) {
                                                        NewUniqueGroupNames.add( GroupName );
                                                        NeedtoCreateGroups.add( NewGroup );
                                                    }
                                                }
                                            }
                                            
                                            if( JSONPropertyObjectElements.containsKey('address_1') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('address_1') ) )
                                                p.Address_Line_1__c = (String) JSONPropertyObjectElements.get('address_1');
                                            
                                            if( JSONPropertyObjectElements.containsKey('city') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('city') ) )
                                                p.City__c = (String) JSONPropertyObjectElements.get('city');
                                            
                                            if( JSONPropertyObjectElements.containsKey('state') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('state') ) )
                                                p.State__c = (String) JSONPropertyObjectElements.get('state');
                                            
                                            if( JSONPropertyObjectElements.containsKey('postal_code') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('postal_code') ) )
                                                p.Zip_Code__c = (String) JSONPropertyObjectElements.get('postal_code');
                                            
                                            if( JSONPropertyObjectElements.containsKey('description') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('description') ) )
                                                p.Description__c = (String) JSONPropertyObjectElements.get('description');
                                            
                                            if( JSONPropertyObjectElements.containsKey('approximate_square_feet') &&  null != JSONPropertyObjectElements.get('approximate_square_feet') ) {
                                                p.Square_Footage__c = (Decimal) JSONPropertyObjectElements.get('approximate_square_feet');
                                                Unit.Square_Feet__c = String.valueOf( JSONPropertyObjectElements.get('approximate_square_feet') );
                                            }
                                            
                                            if( JSONPropertyObjectElements.containsKey('bedroom_number') &&  null != JSONPropertyObjectElements.get('bedroom_number') ) {
                                                p.Bed_Count__c = (Decimal) JSONPropertyObjectElements.get('bedroom_number');
                                                Unit.Bedrooms__c  = (Decimal) JSONPropertyObjectElements.get('bedroom_number');
                                            }
                                            
                                            if( JSONPropertyObjectElements.containsKey('bathroom_number') &&  null != JSONPropertyObjectElements.get('bathroom_number') ) {
                                                p.Bath_Count__c = (Decimal) JSONPropertyObjectElements.get('bathroom_number');
                                                Unit.Bathrooms__c = (Decimal) JSONPropertyObjectElements.get('bathroom_number');
                                            }
                                            
                                            if( JSONPropertyObjectElements.containsKey('neighborhood') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('neighborhood') ) )
                                                p.Neighborhood__c = (String) JSONPropertyObjectElements.get('neighborhood');
                                            
                                            //'schools' on Junction Object will work later on.
                                            
                                            if( JSONPropertyObjectElements.containsKey('amenities_list') ) {
                                                List<Object> JSONAmenitiesElements = ( List<Object> ) JSONPropertyObjectElements.get('amenities_list');
                                                if( !JSONAmenitiesElements.isEmpty() ) {
                                                    String ListOfAmenities;
                                                    for( Object Amenity: JSONAmenitiesElements ) {
                                                        ListOfAmenities = ( null == ListOfAmenities ) ? (String) Amenity : ListOfAmenities  + ', '+ (String) Amenity;
                                                    }
                                                    if( 255 <= ListOfAmenities.length()){
                                                        System.debug( ListOfAmenities.length() );
                                                        ListOfAmenities = ListOfAmenities.substring(0,254);
                                                    } 
                                                    p.Community_Amenity_Additional_Info__c = ListOfAmenities;
                                                }
                                            }
                                            
                                            if( JSONPropertyObjectElements.containsKey('top_features_list') ) {
                                                List<Object> JSONTopFeaturesElements = ( List<Object> ) JSONPropertyObjectElements.get('top_features_list');
                                                if( !JSONTopFeaturesElements.isEmpty() ) {
                                                    String ListOfTopFeatures;
                                                    Integer count = 1;
                                                    
                                                    for( Object TopFeature: JSONTopFeaturesElements ) {
                                                        if( 1 == count )
                                                            p.property_selling_feature_1__c = (String) TopFeature;
                                                        
                                                        if( 2 == count )
                                                            p.property_selling_feature_2__c = (String) TopFeature;
                                                        
                                                        if( 3 == count )
                                                            p.property_selling_feature_3__c = (String) TopFeature;
                                                        
                                                        if( 4 == count )
                                                            p.property_selling_feature_4__c = (String) TopFeature;
                                                        
                                                        if( 5 == count )
                                                            p.property_selling_feature_5__c = (String) TopFeature;
                                                        
                                                        count++;
                                                    }
                                                }
                                            }
                                            
                                            if( JSONPropertyObjectElements.containsKey('owned_property_id') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('owned_property_id') ) ) {
                                                p.Customer_Prop_ID__c 	= (String)JSONPropertyObjectElements.get('owned_property_id');
                                                Unit.Name 			  	= (String)JSONPropertyObjectElements.get('owned_property_id');
                                                Unit.Unit_ID__c			= (String)JSONPropertyObjectElements.get('owned_property_id');
                                            }
                                            
                                            if( JSONPropertyObjectElements.containsKey('property_manager_email') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('property_manager_email') ) )
                                                p.Property_Email__c = (String)JSONPropertyObjectElements.get('property_manager_email');
                                            
                                            if( JSONPropertyObjectElements.containsKey('rent_per_month') &&  null != JSONPropertyObjectElements.get('rent_per_month') )
                                                Unit.Effective_Rent__c = (Decimal)JSONPropertyObjectElements.get('rent_per_month');
                                            
                                            if( JSONPropertyObjectElements.containsKey('property_status') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('property_status') ) ) {
                                                Unit.Active__c = ( 'Available' == (String) JSONPropertyObjectElements.get('property_status') ) ? true : false;
                                                if( 'Available' != (String) JSONPropertyObjectElements.get('property_status') )
                                                    p.Active__c = 'No';
                                            }    
                                            
                                            if( JSONPropertyObjectElements.containsKey('available_date') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('available_date') ) ) {
                                                Unit.Available_On__c = DateTime.valueOf(String.valueOf( JSONPropertyObjectElements.get('available_date') ).replaceAll( 'T', ' ' )).date();
                                            }
                                            
                                            if( JSONPropertyObjectElements.containsKey('make_ready_date') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('make_ready_date') ) ) {
                                                Unit.Made_Ready_Date__c = DateTime.valueOf(String.valueOf( JSONPropertyObjectElements.get('make_ready_date') ).replaceAll( 'T', ' ' )).date();
                                            }
                                            
                                            if( JSONPropertyObjectElements.containsKey('pets_allowed') &&  null != JSONPropertyObjectElements.get('pets_allowed') ) {
                                                p.Pet_Policy__c = ( true == Boolean.valueOf( JSONPropertyObjectElements.get('pets_allowed') ) ) ? 'Yes' : 'No';
                                                Unit.Pets_Allowed__c = ( true == Boolean.valueOf( JSONPropertyObjectElements.get('pets_allowed') ) ) ? 'Yes' : 'No';
                                            }
                                            
                                            if( JSONPropertyObjectElements.containsKey('pet_deposit') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('pet_deposit') ) )
                                                p.Pet_Deposit__c =  (String) JSONPropertyObjectElements.get('pet_deposit');
                                            
                                            if( JSONPropertyObjectElements.containsKey('breed_restrictions') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('breed_restrictions') ) )
                                                p.Breed_Restrictions__c = (String)JSONPropertyObjectElements.get('breed_restrictions');
                                            
                                            if( JSONPropertyObjectElements.containsKey('minimim_lease_terms_mo') &&  null != JSONPropertyObjectElements.get('minimim_lease_terms_mo') )
                                                p.Lease_Terms__c = (Decimal)JSONPropertyObjectElements.get('minimim_lease_terms_mo');
                                            
                                            String tempListOriginString;
                                            if( JSONPropertyObjectElements.containsKey('property_manager_name') && !String.isEmpty( (String) JSONPropertyObjectElements.get('property_manager_name') ) ) 
                                                tempListOriginString = (String)JSONPropertyObjectElements.get('property_manager_name');
                                            
                                            if( JSONPropertyObjectElements.containsKey('assist_property_manager_name') && !String.isEmpty( (String) JSONPropertyObjectElements.get('assist_property_manager_name') ) ) 
                                                tempListOriginString = ( String.isEmpty(tempListOriginString) ) ? (String)JSONPropertyObjectElements.get('assist_property_manager_name') : tempListOriginString + ', ' + (String)JSONPropertyObjectElements.get('assist_property_manager_name');
                                            
                                            if( !String.isEmpty(tempListOriginString) )
                                                p.List_Origin__c = tempListOriginString;
                                            
                                            arrobjUnits.put( PropertyCode, Unit );
                                            arrobjProperties.add(p);
                                        }
                                    }
                                } catch( Exception e ) {
                                    System.debug( PropertyCode );
                                    System.debug( e.getMessage() );
                                    System.debug( e.getStackTraceString() );
                                } 
                            }
                            
                            for( String PropertyCode: PropertyCodesObjects.keySet() ) {
                                if( !ProcessedPropertyCodes.contains( PropertyCode ) && !PropertyCodesObjects.get(PropertyCode).Units__r.isEmpty() ) {
                                    for( Unit__c Unit :PropertyCodesObjects.get(PropertyCode).Units__r ) {
                                        Unit.Active__c = false;
                                        arrobjUnits.put( PropertyCode, Unit );
                                    }	
                                    PropertyCodesObjects.get(PropertyCode).Active__c = 'No';
                                    arrobjProperties.add( PropertyCodesObjects.get(PropertyCode) );
                                }
                            }
                        }
                    }
                }
            } catch ( Exception e ) {
                System.debug( e.getMessage() );
                System.debug( e.getStackTraceString() );
            }
        }
    }
    
    public void HBHGetProperties( String HBHURL ) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint( HBHURL + '/PropertySearch' );
        request.setMethod( 'GET' );
        request.setCompressed(true);
        request.setTimeout( 120000 );
        
        if( !Test.isRunningTest() ) {
            Http http                     = new Http();
            HTTPResponse response         = http.send( request );
            responseJsonString            =  response.getBody();
        }
        
        PropertyCodes.clear();
        
        if( !String.isEmpty(responseJsonString) ) {
            List<Object> JSONdeserializedResponse = (List<Object>) JSON.deserializeUntyped( responseJsonString );
            if( !JSONdeserializedResponse.isEmpty() ) {
                for( Object JSONPropertyObject : JSONdeserializedResponse ) {
                    Map<String, object> JSONPropertyObjectElements = ( Map<String, Object> ) JSONPropertyObject;
                    
                    if( JSONPropertyObjectElements.containsKey('property_id') ) {
                        PropertyCodes.add( String.valueOf( JSONPropertyObjectElements.get('property_id') ) );
                        PropertiesIdPerGroupName.put( String.valueOf( JSONPropertyObjectElements.get('property_id') ), String.valueOf( JSONPropertyObjectElements.get('field_office') ) );
                    }
                }  
            }
        }
    }
}