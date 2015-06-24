public class PSIPullFloorPlansController {

    public String strRequest;
    public String responseJsonString;
    public List<String> strCredentials            		= new List<String>();
    public Map<String, Set<String>> strAccountURLs    	= new Map<String, Set<String>>();
    public List<Floor_Plan__c> FloorPlanListProperty    = new List<Floor_Plan__c>();
    public List<Floor_Plan__c> FloorPlanList        	= new List<Floor_Plan__c>();
    public Set<String> CustomerPropertyIds				= new Set<String>();

    public List<Floor_Plan__c> getFloorPlans( Boolean IsTestClass ) {

        List<Integration__c> searchList = [ SELECT 
                                           		Account__c, PSI_API_URL__c,PSI_Password__c,PSI_Username__c, Grouping__c 
                                           FROM
                                           		Integration__c
                                           WHERE
                                                PSI_Integration_Active__c = true
                                                AND Get_PSI_Floorplans__c != NULL
                                           ];

        if( !searchList.isEmpty() ) {
             for( Integration__c I :searchList ) {
                 System.debug('I - ' + I);
                 strCredentials.clear();
                 strCredentials.add( I.PSI_API_URL__c );
                 strCredentials.add( I.PSI_Username__c );
                 strCredentials.add( I.PSI_Password__c );
                 strCredentials.add( I.Account__c );

                 List<Property__c> PropertyId_list = new List<Property__c>();
                 System.debug( 'I.Grouping__c - ' + I.Grouping__c );
                 if( NULL != I.Grouping__c ) {
                     PropertyId_list = [SELECT Id, PSI_Prop_ID__c, Sub_Prop_IDs__c FROM Property__c WHERE Account__c = :strCredentials.get(3) AND Group_Membership__c =: I.Grouping__c];
                 } else {
                     PropertyId_list = [SELECT Id, PSI_Prop_ID__c, Sub_Prop_IDs__c FROM Property__c WHERE Account__c = :strCredentials.get(3)];
                 }
                 
                 System.debug('PropertyId_list - ' + PropertyId_list );

                 if( null != PropertyId_list ) {
                         for( Property__c P: PropertyId_list) {
                             if( null != p.PSI_Prop_ID__c && false == CustomerPropertyIds.contains( p.PSI_Prop_ID__c ) ) {
                                 if( true == Pattern.matches('^[0-9]+$',p.PSI_Prop_ID__c) ) { // why this is require?
                                     CustomerPropertyIds.add( p.PSI_Prop_ID__c );
                                     CustomerPropertyIds.add( p.PSI_Prop_ID__c );
                                     if( strCredentials.size() > 4 )
                                         strCredentials.set( 4, p.PSI_Prop_ID__c);                                
                                     else
                                         strCredentials.add( p.PSI_Prop_ID__c);

                                     // Build request
                                     buildRequest( strCredentials );

                                     // Send request
                                     HttpRequest request = new HttpRequest();
                                     request.setEndpoint( strCredentials.get(0) + '/properties' );
                                     request.setMethod( 'POST' );
                                     request.setHeader( 'Content-Type', 'application/json; charset=UTF-8' );
                                     request.setTimeout(120000);
                                     request.setBody( strRequest );

                                     if( false == IsTestClass ) {
                                         Http http           		= new Http();
                                         HTTPResponse response     	= http.send( request );
                                         responseJsonString  =  response.getBody();
                                     }

                                     // Parse response
                                     if( null != responseJsonString ) {
                                         parseJSONresponse( responseJsonString, I.Account__c, p.Id );
                                     }
                                 }
                             }
                         }
                     }

             }
        }
        return FloorPlanList;
    }

    public void buildRequest( List<String>strCredentials ){

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
                gen.writeStringField( 'name', 'getFloorPlans' );
                gen.writeFieldName( 'params' ); 
                gen.writeStartObject();
                    if( null != strCredentials.get(4) ) {
                        gen.writeStringField('propertyId', strCredentials.get(4) );
                    }
                gen.writeEndObject();
          gen.writeEndObject();
        gen.writeEndObject();

        strRequest = gen.getAsString();
    }

    public void parseJSONresponse( String strJSON, String AccountId, String PropertyId ) {
        
        Map<String, Object> jsonObjectFloorPlans   	= (Map<String, Object>) JSON.deserializeUntyped(strJSON);
        jsonObjectFloorPlans            			= ( Map<String, Object> ) jsonObjectFloorPlans.get( 'response' );
        jsonObjectFloorPlans             			= ( Map<String, Object> ) jsonObjectFloorPlans.get( 'result' );
        jsonObjectFloorPlans             			= ( Map<String, Object> ) jsonObjectFloorPlans.get( 'FloorPlans' );
        List<Object>FloorPlans_temp         		= ( List<Object> ) jsonObjectFloorPlans.get( 'FloorPlan' );

        for( Object Fp1 : FloorPlans_temp ) {

            Map<String, Object> Fp 		= ( Map<String, Object> ) Fp1;
            Floor_Plan__c FloorPlan  	= new Floor_Plan__c();
            FloorPlan.Account__c		= AccountId;
            FloorPlan.Property__c		= PropertyId;

            //Amenity
            if( Fp.containsKey( 'Amenity' ) ) {
                List<Object>Amenities   = ( List<Object> ) Fp.get( 'Amenity' );
                String AmenityTypes    	= '';
                System.debug( Amenities );
                for( Object Amenity1 :Amenities ){
                    Map<String, Object> Amenity       		= ( Map<String, Object> ) Amenity1;
                    Map<String, Object> Attribute_amenity   = ( Map<String, Object> ) Amenity.get( '@attributes' );
                    String AmenityType             			= ( String ) Attribute_amenity.get( 'AmenityType' );
                    if( null == AmenityTypes || '' == AmenityTypes ) {
                        AmenityTypes = AmenityTypes + AmenityType;
                    } else {
                        AmenityTypes = AmenityTypes + ', ' + AmenityType;
                    }
                }
                FloorPlan.Special_Concession__c = AmenityTypes;
                
                //Deposit
                Map<String, Object> Deposit           		= ( Map<String, Object> ) Fp.get( 'Deposit' );
                Map<String, Object> Attribute_deposit   	= ( Map<String, Object> ) Deposit.get( '@attributes' );
                String DepositType                			= ( String ) Attribute_deposit.get( 'DepositType' );

                Map<String, Object> Amount             		= ( Map<String, Object> ) Deposit.get( 'Amount' );
                Map<String, Object> Attribute_amount    	= ( Map<String, Object> ) Amount.get( '@attributes' );
                String AmountType                			= ( String ) Attribute_amount.get( 'AmountType' );

                Map<String, Object> ValueRange          	= ( Map<String, Object> ) Amount.get( 'ValueRange' );
                Map<String, Object> Attribute_valueRange	= ( Map<String, Object> ) ValueRange.get( '@attributes' );
                Integer Max_deposite              			= ( Integer ) Attribute_valueRange.get( 'Max' );
                Integer Min_deposite              			= ( Integer ) Attribute_valueRange.get( 'Min' );
                FloorPlan.Deposit__c						= Max_deposite;
            }

            //File
            if( Fp.containsKey( 'File' ) ) {
                List<Object> FileList         	= ( List<Object> ) Fp.get( 'File' );
                for( Object File1 :FileList ) {
                    Map<String, Object> File = ( Map<String, Object> ) File1;
                    FloorPlan.Floorplan_Image__c = ( String )File.get( 'Src' );
                }
            }

            //Identification
            if( Fp.containsKey( 'Identification' ) ) {
                Map<String, Object> Identification         	= ( Map<String, Object> ) Fp.get( 'Identification' );
                FloorPlan.PSI_Floor_Plan_ID__c                	= '' + ( Integer ) Identification.get( 'IDValue' );
            }

            //MarketRent
            if( Fp.containsKey( 'MarketRent' ) ) {
                Map<String, Object> MarketRent           	= ( Map<String, Object> ) Fp.get( 'MarketRent' );
                Map<String, Object> Attribute_marketRent    = ( Map<String, Object> ) MarketRent.get( '@attributes' );
                FloorPlan.Market_Rent__c              		= ( Decimal ) Attribute_marketRent.get( 'Max' );
            }

            //Name
            if( Fp.containsKey( 'Name' ) ) {
                FloorPlan.Name                 				= ( String ) Fp.get( 'Name' );
            }

            //Room
            if( Fp.containsKey( 'Room' ) ) {
                List<Object>RoomList                		= ( List<Object> ) Fp.get( 'Room' );
                for( Object Room1 :RoomList ) {
                    Map<String, Object> Room 				= ( Map<String, Object> ) Room1;
                    Map<String, Object> Attribute_room     	= ( Map<String, Object> ) Room.get( '@attributes' );
                    String RoomType              			= ( String ) Attribute_room.get( 'RoomType' );
                    if( 'Bedroom' == RoomType ) {
                        FloorPlan.Bedrooms__c        		= ( Decimal ) Room.get( 'Count' );
                    } else if( 'Bathroom' == RoomType  ) {
                        FloorPlan.Bathrooms__c        		= ( Decimal ) Room.get( 'Count' );
                    }
                }
            }

            //SquareFeet
            if( Fp.containsKey( 'SquareFeet' ) ) {
                Map<String, Object> SquareFeet        		= ( Map<String, Object> ) Fp.get( 'SquareFeet' );
                Map<String, Object> Attribute_squareFeet   	= ( Map<String, Object> ) SquareFeet.get( '@attributes' );
                FloorPlan.Square_Feet__c           			= '' + ( Integer ) Attribute_squareFeet.get( 'Max' );
            }

            //UnitsAvailable
            if( Fp.containsKey( 'UnitsAvailable' ) ) {
                FloorPlan.Unit_Count__c            			= ( Integer ) Fp.get( 'UnitsAvailable' );
            }

            List<Floor_Plan__c>	FloorPlans = [ SELECT
                                              Id
                                              FROM
                                              Floor_Plan__c
                                              WHERE
                                              PSI_Floor_Plan_ID__c =: FloorPlan.PSI_Floor_Plan_ID__c  
                                              AND Property__c =: PropertyId
                                              AND Account__c  =: AccountId
                                             ];
            if( null != FloorPlans ) {
                for( Floor_Plan__c fps: FloorPlans ) {
                    FloorPlan.Id = fps.Id;
                }
            }
            FloorPlanList.add( FloorPlan );
        }
    }
}