public class PSIPullUnitTypesController {

    public String strRequest;
    public String responseJsonString;
    public List<Floor_Plan__c> arrobjFloorPlans         = new List<Floor_Plan__c>();
    public Set<String> CustomerPropertyIds              = new Set<String>();
    
    public Set<ID> AccountIds							= new Set<ID>();
    public Set<ID> PropertyIds 							= new Set<ID>();

    public void getUnitTypes() {

        if( !this.AccountIds.isEmpty() ) {
            List<Integration__c> searchList = [ SELECT 
                                               Account__c, PSI_API_URL__c, PSI_Password__c, PSI_Username__c, Grouping__c
                                               FROM
                                               Integration__c
                                               WHERE
                                               PSI_Integration_Active__c = true
                                               AND Get_PSI_UnitTypes__c != NULL
                                               AND Account__c IN : AccountIds
                                              ];
            
            Set<String> AccountIds = new Set<String>();
            Set<String> GroupingIds = new Set<String>();
            Map<String, List<String>> credentials = new Map<String, List<String>>();
            if( !searchList.isEmpty() ) {
                for( Integration__c I :searchList ) { 
                    List<String> tempCredentials = new List<String>();
                    tempCredentials.add(I.PSI_API_URL__c);
                    tempCredentials.add(I.PSI_Username__c);
                    tempCredentials.add(I.PSI_Password__c);
                    tempCredentials.add(I.Account__c);
                    
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
                                         Id, Account__c, PSI_Prop_ID__c, Last_Yardi_FloorPlan_Pull__c, Group_Membership__c, Sub_Prop_IDs__c, 
                                         ( SELECT Id, Name, PSI_Floor_Plan_ID__c, External_Sub_Prop_ID__c  FROM Floor_Plans__r )
                                     FROM 
                                     	Property__c 
                                     WHERE
                                     	Id IN :PropertyIds
                                     ];
                
				Integer Count = 0;                
                for( Property__c property : fetchedProperties ) { 
                    try{
                        
                        List<String> strCredentials = new List<String>();
                        if( null != property.Group_Membership__c && credentials.containsKey( property.Group_Membership__c ) ) {
                            strCredentials = credentials.get( property.Group_Membership__c );
                        } else if( credentials.containsKey( property.Account__c ) ) {
                            strCredentials = credentials.get( property.Account__c );
                        }
                        
                        if( !strCredentials.isEmpty() ) {
                            // Build request
                            Boolean isPropertyHasSubPropertyIds = false;
                            Set<String> PSIPropertyIds = new Set<String>();
                            if( null != property.Sub_Prop_IDs__c ) {
                                isPropertyHasSubPropertyIds = true;
                                PSIPropertyIds.addAll( String.valueOf( property.Sub_Prop_IDs__c ).split( ',', 0 ) );
                            }
                            PSIPropertyIds.add( property.PSI_Prop_ID__c );
                           
                            for( String PSIPropertyId : PSIPropertyIds ) {
                                buildRequest( strCredentials, PSIPropertyId );
                                
                                // Send request
                                HttpRequest request = new HttpRequest();
                                request.setEndpoint( strCredentials.get(0) + '/propertyunits' );
                                request.setMethod( 'POST' );
                                request.setHeader( 'Content-Type', 'application/json; charset=UTF-8' );
                                request.setTimeout(120000);
                                request.setBody( strRequest );
                                
                                if( !Test.isRunningTest() ) {
                                    Http http                   = new Http();
                                    HTTPResponse response       = http.send( request );
                                    responseJsonString = response.getBody();
                                } else {
                                    responseJsonString = '{"response":{"requestId":"15","result":{"property":{"type":"Apartment","propertyId":104143,"marketingName":"Ponderosa Villas","generalId":"7376","yearBuilt":"1986","shortDescription":"Ponderosa Villas is located in the renowned Cherry Creek School district and only minutes from Downtown, Denver Tech and DIA.","longDescription":"Ponderosa Villas is located in the heart of it all! Bel Rea Institute, The Denver Tech Center, Downtown, and DIA are all within minutes of the community. Enjoy close comforts such as Costco, Safeway, Starbucks, Canterbury Park, and Red Robin all within walking distance! Your new one or two bedroom apartment home will have every feature you need and more, including wood burning fireplaces, newly renovated interiors, vaulted ceilings, private patios and balconies, and in-home washer and dryer units. The community features an expansive fitness center, ample parking, mature landscaping, enclosed pet park, two relaxing pools, and covered parking. Add to all this a professional management company and you\'ve found the perfect place to call home!"},"unitTypes":{"unitType":[{"identificationType":{"@attributes":{"idType":"unitTypeId"},"idValue":251533},"name":"non_resi","unitBedRooms":0,"unitBathrooms":0,"minSquareFeet":0,"maxSquareFeet":0},{"identificationType":{"@attributes":{"idType":"unitTypeId"},"idValue":251534},"name":"One bed one bath","unitBedRooms":0,"unitBathrooms":0,"minSquareFeet":720,"maxSquareFeet":720},{"identificationType":{"@attributes":{"idType":"unitTypeId"},"idValue":251535},"name":"Two bed one bath","unitBedRooms":0,"unitBathrooms":0,"minSquareFeet":980,"maxSquareFeet":980},{"identificationType":{"@attributes":{"idType":"unitTypeId"},"idValue":251536},"name":"two bed 1.5 bath","unitBedRooms":0,"unitBathrooms":0,"minSquareFeet":980,"maxSquareFeet":980},{"identificationType":{"@attributes":{"idType":"unitTypeId"},"idValue":251537},"name":"Two bed two bath","unitBedRooms":0,"unitBathrooms":0,"minSquareFeet":980,"maxSquareFeet":980}]}}}}';
                                }
                                // Parse response
                                
                                if( null != responseJsonString ) {
                                    parseJSONresponse( responseJsonString, Property.Account__c, Property.Id, Property.Floor_Plans__r, PSIPropertyId, isPropertyHasSubPropertyIds );
                                }
                            }
                        }
                   	} catch( Exception e ) {
                        System.debug( e.getMessage() );
                        System.debug( e.getStackTraceString() );
                        System.debug( 'Error for Property: ' + property.Name );
                    }
                }
            }
        }
    }

    public void buildRequest( List<String> strCredentials, String PSIPropertyId ){

        String UserName = strCredentials.get(1);
        String Password  = strCredentials.get(2);
    
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
          gen.writeFieldName('auth'); 
          gen.writeStartObject();
                gen.writeStringField('type', 'basic');
                gen.writeStringField('username', UserName );
                gen.writeStringField('password', Password );
          gen.writeEndObject();
           gen.writeNumberField( 'requestId', 15 );
          gen.writeFieldName( 'method' ); 
          gen.writeStartObject();
                gen.writeStringField( 'name', 'getUnitTypes' );
                gen.writeFieldName( 'params' ); 
                gen.writeStartObject();
                    if( null != PSIPropertyId ) {
                        gen.writeStringField('propertyId', PSIPropertyId );
                    }
                gen.writeEndObject();
          gen.writeEndObject();
        gen.writeEndObject();

        strRequest = gen.getAsString();
    }

    public void parseJSONresponse( String strJSON, String AccountId, String PropertyId, List<Floor_Plan__c> FloorPlans, String PSIPropertyId, Boolean isPropertyHasSubPropertyIds ) {
        if( null != strJSON ) {
            
            Map<String, Object> JSONdeserializedResponse = (Map<String, Object>) JSON.deserializeUntyped( strJSON ); 
            
            if( JSONdeserializedResponse.containsKey( 'response' ) ) {
                JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('response');
                
                if( JSONdeserializedResponse.containsKey( 'result' ) ) {
                    //System.debug( JSONdeserializedResponse );
                    try {
                        JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('result');
                    } catch( Exception e ) {
                        System.debug( e.getMessage() );
                        System.debug( e.getStackTraceString() );
                        return;
                    }
                    
                    if( JSONdeserializedResponse.containsKey( 'unitTypes' ) ) {
                        JSONdeserializedResponse = ( Map<String, Object> ) JSONdeserializedResponse.get('unitTypes');
                        List<Object> JSONListFloorPlans = ( List<Object> ) JSONdeserializedResponse.get('unitType');
                        
                        if( 0 < JSONListFloorPlans.size() ) {
                            
                            Map<String, String> FloorPlanCodeIds = new Map<String, String>();
                            Map<String, String> FloorPlanNamesIds = new Map<String, String>();
                            
                            if( !FloorPlans.isEmpty() ) {
                                for( Floor_Plan__c fp: FloorPlans ) {
                                    if( PSIPropertyId == fp.External_Sub_Prop_ID__c || false == isPropertyHasSubPropertyIds ) {
                                        FloorPlanCodeIds.put( fp.PSI_Floor_Plan_ID__c, fp.Id );
                                    	FloorPlanNamesIds.put( fp.Name, fp.Id );
                                    }
                                }
                            }
                            
                            System.debug( JSONListFloorPlans.size() );
                            for( Object JSONFloorPlan : JSONListFloorPlans ) {
                                Map<String, object> JSONFloorPlanElements = ( Map<String, Object> ) JSONFloorPlan;
                                
                                JSONFloorPlanElements = ( Map<String, Object> ) JSONFloorPlanElements.get( 'identificationType' );
                                String FloorPlanCode = String.valueOf( JSONFloorPlanElements.get( 'idValue' ) );
                                
                                JSONFloorPlanElements = ( Map<String, Object> ) JSONFloorPlan;
                                
                                String FloorPlanName;
                                if( JSONFloorPlanElements.containsKey( 'name' ) ) { 
                                    FloorPlanName = String.valueOf( JSONFloorPlanElements.get( 'name' ) );
                                }
                                
                                Floor_Plan__c FloorPlan = new Floor_Plan__c();
                                
                                String Id;
                                if( FloorPlanCodeIds.containsKey( FloorPlanCode ) ) {
                                    Id = FloorPlanCodeIds.get( FloorPlanCode );
                                } else if ( null != FloorPlanName && FloorPlanNamesIds.containsKey( FloorPlanName ) ) {
                                    Id = FloorPlanNamesIds.get( FloorPlanName );
                                }
                                    
                                if( null != Id ) {
                                    FloorPlan.Id = Id;
                                    FloorPlan.PSI_Floor_Plan_ID__c = FloorPlanCode;
                                } else {
                                    FloorPlan.Account__c = AccountId;
                                    FloorPlan.Property__c = PropertyId;
                                    FloorPlan.PSI_Floor_Plan_ID__c = FloorPlanCode;
                                }
                                
                                if( true == isPropertyHasSubPropertyIds ) {
                                    FloorPlan.External_Sub_Prop_ID__c = PSIPropertyId;
                                }
                                
                                FloorPlan.Name = FloorPlanName;
                                
                                if( JSONFloorPlanElements.containsKey( 'unitBedRooms' ) ) { 
                                    FloorPlan.Bedrooms__c = Decimal.valueOf( String.valueOf( JSONFloorPlanElements.get('unitBedRooms') ).replaceAll(',', '') );
                                }
                                
                                if( JSONFloorPlanElements.containsKey( 'unitBathrooms' ) ) { 
                                    FloorPlan.Bathrooms__c = Decimal.valueOf( String.valueOf( JSONFloorPlanElements.get('unitBathrooms') ).replaceAll(',', '') );
                                }
                                
                                if( JSONFloorPlanElements.containsKey( 'minSquareFeet' ) ) { 
                                    FloorPlan.SQ_FT_Min__c = Decimal.valueOf( String.valueOf( JSONFloorPlanElements.get('minSquareFeet') ).replaceAll(',', '') );
                                }
                                
                                if( JSONFloorPlanElements.containsKey( 'maxSquareFeet' ) ) { 
                                    FloorPlan.SQ_FT_Max__c = Decimal.valueOf( String.valueOf( JSONFloorPlanElements.get('maxSquareFeet') ).replaceAll(',', '') );
                                }
                             
                                arrobjFloorPlans.add( FloorPlan );
                            }              
                        }
                    }
                }
            }
        }
    }
}