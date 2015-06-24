public class PSISRPushController {

    public String strRequest                									= '';
    public String responseJsonStringWOPickList									= '';
    public String WOPickListReq													= '';
    public String responseJsonString											= ''; 
    public List<Service_Request1__c>  ServiceRequests							= new List<Service_Request1__c> ();
    public List<String> strCredentials      									= new List<String>();
    public Map<String, Set<String>> strAccountURLs      						= new Map<String, Set<String>>();
    public Map<String, Map<String, Map<String, String>>> PropertyPriorities 	= new Map<String, Map<String, Map<String, String>>>();
    public Map<String, Map<String, Map<String, String>>> PropertyLocations 		= new Map<String, Map<String, Map<String, String>>>();
    public Map<String, Map<String, Map<String, String>>> PropertyProblems	 	= new Map<String, Map<String, Map<String, String>>>();
    public Map<String, Map<String, Map<String, String>>> PropertyStatusTypes	= new Map<String, Map<String, Map<String, String>>>();

    public List<Service_Request1__c> PushGuestCards( Boolean IsTestScheduler ) {
        
        List<Integration__c> searchList = [ SELECT 
                                            Account__c, PSI_API_URL__c,PSI_Password__c,PSI_Username__c 
                                           FROM
                                            Integration__c
                                           WHERE
                                            Push_Service_Requests_to_PSI__c  = true
                                           ];
        
        if( !searchList.isEmpty() ) {
             for( Integration__c I :searchList ) {  
                 strCredentials.clear();
                 strCredentials.add(I.Account__c);
                 strCredentials.add(I.PSI_API_URL__c);
                 strCredentials.add(I.PSI_Password__c);
                 strCredentials.add(I.PSI_Username__c);

                 System.debug( 'strAccountURLs ->' + strAccountURLs );
                 if( strAccountURLs.isEmpty() || !strAccountURLs.containsKey( I.Account__c ) || ( strAccountURLs.containsKey( I.Account__c) && !strAccountURLs.get(I.Account__c).contains(I.PSI_API_URL__c) ) ) {

                      Set<String> tempSet = new Set<String>();
                      if( strAccountURLs.containsKey( I.Account__c) ) {
                          tempSet = strAccountURLs.get( I.Account__c );
                      } 
                     
                      tempSet.add( I.PSI_API_URL__c );
                      strAccountURLs.put( I.Account__c, tempSet );
                 
                     System.debug('Integration - ' + I );
                     List<Property__c> PropertyList = [SELECT Id, PSI_Prop_ID__c FROM Property__c WHERE PSI_Prop_ID__c != null AND Account__c = :I.Account__c ];
                     String CustProList = '';
                     for( Property__c Property: PropertyList ) {
                         if( true == Pattern.matches('^[0-9]+$', Property.PSI_Prop_ID__c) ) {
                             if( '' == CustProList ){
                                 CustProList = '' + Property.PSI_Prop_ID__c;
                             } else {
                                 CustProList = CustProList + ', ' + Property.PSI_Prop_ID__c;
                             }
                         }
                     }
    
                     //getWorkOrderPickLists
                     WOPickListReq = BuildWOPickListJson( strCredentials, CustProList );
    
                     //Send request
                     HttpRequest request = new HttpRequest();
                     request.setEndpoint( strCredentials.get(1) + '/maintenance' );
                     request.setMethod( 'POST' );
                     request.setHeader( 'Content-Type', 'application/json' );
                     request.setTimeout(120000);
                     request.setBody( WOPickListReq );
    
                     if( false == IsTestScheduler ) {                 
                         Http http                  		= new Http();
                         HTTPResponse response      		= http.send( request );
                         responseJsonStringWOPickList  		=  response.getBody();
                     }
                     
                     System.debug( 'responseJsonStringWOPickList - ' + responseJsonStringWOPickList );
                    //responseJsonStringWOPickList = '{"response":{"requestId":"15","result":{"Property":{"104143":{"@attributes":{"Id":104143},"Priorities":{"Priority":[{"@attributes":{"Id":18516,"Name":"Emergency","Code":""}},{"@attributes":{"Id":18590,"Name":"Standard","Code":"Sd"}},{"@attributes":{"Id":16613,"Name":"High","Code":"HI"}},{"@attributes":{"Id":16612,"Name":"Medium","Code":"MD"}}]},"StatusTypes":{"StatusType":[{"@attributes":{"Id":18507,"Name":"CALL","Code":""}},{"@attributes":{"Id":18505,"Name":"Scheduled","Code":""}},{"@attributes":{"Id":18506,"Name":"In Progress","Code":""}},{"@attributes":{"Id":18504,"Name":"Work Completed","Code":"WCC"}},{"@attributes":{"Id":18511,"Name":"Canceled","Code":""}}]},"Problems":{"Problem":[{"@attributes":{"Id":75645,"Name":"Flooring"}},{"@attributes":{"Id":78265,"Name":"Building Exterior"}},{"@attributes":{"Id":78267,"Name":"Carbon Monoxide Det."}},{"@attributes":{"Id":78268,"Name":"Carpentry"}},{"@attributes":{"Id":78269,"Name":"Carpet"}},{"@attributes":{"Id":78272,"Name":"Door"}},{"@attributes":{"Id":78273,"Name":"Drywall Repair"}},{"@attributes":{"Id":78277,"Name":"Graffiti"}},{"@attributes":{"Id":78280,"Name":"Haul Away"}},{"@attributes":{"Id":78281,"Name":"Hot Water"}},{"@attributes":{"Id":78285,"Name":"Keys"}},{"@attributes":{"Id":78286,"Name":"Laundry"}},{"@attributes":{"Id":78287,"Name":"Locks"}},{"@attributes":{"Id":78288,"Name":"Mailbox"}},{"@attributes":{"Id":78290,"Name":"Moss"}},{"@attributes":{"Id":78291,"Name":"MR Go Back"}},{"@attributes":{"Id":78292,"Name":"Notice of Violation"}},{"@attributes":{"Id":78293,"Name":"Paint"}},{"@attributes":{"Id":78294,"Name":"Parking Lot"}},{"@attributes":{"Id":78295,"Name":"Patio"}},{"@attributes":{"Id":78296,"Name":"Pest Control"}},{"@attributes":{"Id":78297,"Name":"Phone"}},{"@attributes":{"Id":78298,"Name":"Plumb Supplies"}},{"@attributes":{"Id":78300,"Name":"Roof"}},{"@attributes":{"Id":78301,"Name":"Safety"}},{"@attributes":{"Id":78302,"Name":"Smoke Detector"}},{"@attributes":{"Id":78303,"Name":"Snow\\/Ice Removal"}},{"@attributes":{"Id":78305,"Name":"Tile\\/Vinyl"}},{"@attributes":{"Id":78306,"Name":"Tub\\/Reglaze"}},{"@attributes":{"Id":78307,"Name":"Water Leak"}},{"@attributes":{"Id":78308,"Name":"Windows"}},{"@attributes":{"Id":87288,"Name":"Dryer"}},{"@attributes":{"Id":87289,"Name":"Stove"}},{"@attributes":{"Id":91356,"Name":"Microwave"}},{"@attributes":{"Id":94081,"Name":"Dishwasher"}},{"@attributes":{"Id":97086,"Name":"Refrigerator"}},{"@attributes":{"Id":97136,"Name":"Washer"}},{"@attributes":{"Id":97329,"Name":"County"}},{"@attributes":{"Id":97330,"Name":"Move Out"}},{"@attributes":{"Id":97331,"Name":"Pet"}},{"@attributes":{"Id":97351,"Name":"HPD Violation"}},{"@attributes":{"Id":97352,"Name":"DOB Violation"}},{"@attributes":{"Id":97353,"Name":"ECB Violation"}},{"@attributes":{"Id":97354,"Name":"FDNY Violation"}},{"@attributes":{"Id":97355,"Name":"Sanitation Violation"}},{"@attributes":{"Id":97356,"Name":"Court Stipulation"}},{"@attributes":{"Id":97357,"Name":"Section 8 Requirement"}},{"@attributes":{"Id":97410,"Name":"Garbage Disposal"}},{"@attributes":{"Id":115893,"Name":"Blinds"}},{"@attributes":{"Id":115894,"Name":"Cabinets"}},{"@attributes":{"Id":115895,"Name":"Ceiling Fan"}},{"@attributes":{"Id":115896,"Name":"Closet"}},{"@attributes":{"Id":115898,"Name":"Fireplace"}},{"@attributes":{"Id":115902,"Name":"Hardware"}},{"@attributes":{"Id":115904,"Name":"Housekeeping"}},{"@attributes":{"Id":115916,"Name":"Pool"}},{"@attributes":{"Id":116442,"Name":"Thermostat"}},{"@attributes":{"Id":120626,"Name":"Light Bulb"}},{"@attributes":{"Id":120627,"Name":"Light Fixture"}},{"@attributes":{"Id":120628,"Name":"Light Switch"}},{"@attributes":{"Id":120629,"Name":"Outlet"}},{"@attributes":{"Id":120631,"Name":"Landscape"}},{"@attributes":{"Id":120632,"Name":"Power Wash"}},{"@attributes":{"Id":120633,"Name":"Radiator"}},{"@attributes":{"Id":120634,"Name":"Boiler"}},{"@attributes":{"Id":120636,"Name":"01- Pre MO Inspection"}},{"@attributes":{"Id":120637,"Name":"02- MO Insptection"}},{"@attributes":{"Id":120638,"Name":"03- Lock\\/Keys"}},{"@attributes":{"Id":120639,"Name":"04- Demo"}},{"@attributes":{"Id":120640,"Name":"05- Paint"}},{"@attributes":{"Id":120641,"Name":"06.1- Applicances"}},{"@attributes":{"Id":120642,"Name":"06.2- Counters"}},{"@attributes":{"Id":120643,"Name":"06.3- Cabinets"}},{"@attributes":{"Id":120644,"Name":"06.4- Blinds & Verticals"}},{"@attributes":{"Id":120645,"Name":"06.5- Patio & Balcony"}},{"@attributes":{"Id":120646,"Name":"06.6- Life & Safety"}},{"@attributes":{"Id":120647,"Name":"06.7- Plumnbing"}},{"@attributes":{"Id":120648,"Name":"06.8- MEP"}},{"@attributes":{"Id":120649,"Name":"07- Tub"}},{"@attributes":{"Id":120650,"Name":"08- Carpet"}},{"@attributes":{"Id":120651,"Name":"09- Vinyl"}},{"@attributes":{"Id":120652,"Name":"10- Clean"}},{"@attributes":{"Id":120653,"Name":"11- Pest Control"}},{"@attributes":{"Id":120654,"Name":"12- Final Inspection"}},{"@attributes":{"Id":120656,"Name":"Kitchen Sink"}},{"@attributes":{"Id":120657,"Name":"Master Bath Sink"}},{"@attributes":{"Id":120658,"Name":"Master Bath Tub"}},{"@attributes":{"Id":120659,"Name":"Guest Bath Tub"}},{"@attributes":{"Id":120660,"Name":"Guest Bath Sink"}},{"@attributes":{"Id":120661,"Name":"Master Toilet"}},{"@attributes":{"Id":120662,"Name":"Guest Toilet"}},{"@attributes":{"Id":125906,"Name":"Renovations"}},{"@attributes":{"Id":125907,"Name":"Violations"}}]}}}}}}';
                    //responseJsonStringWOPickList  = '{ "response":{ "requestId":"15", "result":{ "Property":{ "11111":{ "@attributes":{ "Id":28725 }, "Locations":{ "Location":[ { "@attributes":{ "Id":11370, "Name":"Basement" } }, { "@attributes":{ "Id":11369, "Name":"Family Room" } }, { "@attributes":{ "Id":11362, "Name":"Kitchen" } }, { "@attributes":{ "Id":11368, "Name":"Living Room" } }, { "@attributes":{ "Id":11363, "Name":"Master Bathroom" } }, { "@attributes":{ "Id":11366, "Name":"Master Bedroom" } }, { "@attributes":{ "Id":11373, "Name":"Other" } }, { "@attributes":{ "Id":11364, "Name":"Other Bathroom" } }, { "@attributes":{ "Id":11372, "Name":"Outside" } }, { "@attributes":{ "Id":11371, "Name":"Roof" } } ] }, "Priorities":{ "Priority":[ { "@attributes":{ "Id":15299, "Name":"Emergency", "Code":"EM" } },{ "@attributes":{ "Id":15299, "Name":"Standard", "Code":"SD" } }, { "@attributes":{ "Id":15297, "Name":"High", "Code":"HI" } }, { "@attributes":{ "Id":15295, "Name":"Low", "Code":"LO" } }, { "@attributes":{ "Id":15296, "Name":"Medium", "Code":"MD" } }, { "@attributes":{ "Id":15298, "Name":"Very High", "Code":"VH" } }, { "@attributes":{ "Id":15294, "Name":"Very Low", "Code":"VL" } } ] }, "StatusTypes":{ "StatusType":[ { "@attributes":{ "Id":15107, "Name":"Completed", "Code":"CP" } }, { "@attributes":{ "Id":15103, "Name":"New", "Code":"NE" } }, { "@attributes":{ "Id":15104, "Name":"Open", "Code":"OP" } }, { "@attributes":{ "Id":15105, "Name":"Suspended", "Code":"SU" } } ] }, "Problems":{ "Problem":[ { "@attributes":{ "Id":55263, "Name":"Plumbing" } }, { "@attributes":{ "Id":55269, "Name":"Other" } }, { "@attributes":{ "Id":55262, "Name":"Electrical" } }, { "@attributes":{ "Id":55264, "Name":"Heating" } }, { "@attributes":{ "Id":55266, "Name":"Structural" } }, { "@attributes":{ "Id":55267, "Name":"Cosmetic" } }, { "@attributes":{ "Id":55268, "Name":"Flooring" } }, { "@attributes":{ "Id":62386, "Name":"Power" } } ] } }, "22222":{ "@attributes":{ "Id":21618 }, "Locations":{ "Location":[ { "@attributes":{ "Id":11370, "Name":"Basement" } }, { "@attributes":{ "Id":17903, "Name":"bathroom1" } }, { "@attributes":{ "Id":11369, "Name":"Family Room" } }, { "@attributes":{ "Id":17904, "Name":"kicthen" } }, { "@attributes":{ "Id":11362, "Name":"Kitchen" } }, { "@attributes":{ "Id":11368, "Name":"Living Room" } }, { "@attributes":{ "Id":11363, "Name":"Master Bathroom" } }, { "@attributes":{ "Id":11366, "Name":"Master Bedroom" } }, { "@attributes":{ "Id":11373, "Name":"Other" } }, { "@attributes":{ "Id":11364, "Name":"Other Bathroom" } }, { "@attributes":{ "Id":11372, "Name":"Outside" } }, { "@attributes":{ "Id":11371, "Name":"Roof" } }, { "@attributes":{ "Id":17512, "Name":"ryd" } } ] }, "Priorities":{ "Priority":[ { "@attributes":{ "Id":15299, "Name":"Emergency", "Code":"EM" } }, { "@attributes":{ "Id":15297, "Name":"High", "Code":"HI" } }, { "@attributes":{ "Id":15295, "Name":"Low", "Code":"LO" } }, { "@attributes":{ "Id":15296, "Name":"Medium", "Code":"MD" } }, { "@attributes":{ "Id":15298, "Name":"Very High", "Code":"VH" } }, { "@attributes":{ "Id":15294, "Name":"Very Low", "Code":"VL" } } ] }, "StatusTypes":{ "StatusType":[ { "@attributes":{ "Id":15104, "Name":"Open", "Code":"OP" } }, { "@attributes":{ "Id":15105, "Name":"Suspended", "Code":"SU" } }, { "@attributes":{ "Id":15107, "Name":"Completed", "Code":"CP" } }, { "@attributes":{ "Id":15103, "Name":"New", "Code":"NE" } }, { "@attributes":{ "Id":18223, "Name":"Abhishektest", "Code":"AB" } } ] }, "Problems":{ "Problem":[ { "@attributes":{ "Id":62621, "Name":"Leaving room" } }, { "@attributes":{ "Id":62388, "Name":"power lwak" } }, { "@attributes":{ "Id":67716, "Name":"Leak" } }, { "@attributes":{ "Id":67717, "Name":"powercut" } } ] } } } } } }';
                     responseWOPickListJsonString( responseJsonStringWOPickList, CustProList );
    
                     for( Property__c Property: PropertyList ) {
                         System.debug('Property - ' + Property);
                         if( true == Pattern.matches('^[0-9]+$', Property.PSI_Prop_ID__c) ) {
                             List<Service_Request1__c> SFDCServiceRequests = [
                                                                                SELECT
                                                                                    Id, Account__c, Status__c, Contact_Name__r.Name, Contact_Mobile__c,Contact_Email__c, Permission_to_Enter__c, Work_Order_Dispatch__c, Service_Request_Type__c, Room_Area_Impacted__c
                                                                                FROM
                                                                                    Service_Request1__c
                                                                                WHERE
                                                                                    Property_of_Interest__r.PSI_Prop_ID__c = :Property.PSI_Prop_ID__c
                                                                                    AND Property_of_Interest__r.Id              = :Property.Id
                                                                                    AND Account_Name__r.Id                      = :I.Account__c
                                                                             ];
    
                             System.debug('SFDCServiceRequests - ' + SFDCServiceRequests);
                             for( Service_Request1__c sr1 : SFDCServiceRequests ) {

                                 Map<String, String> OtherInfo = new Map<String, String>();
                                 OtherInfo.put( 'CustPropId', '' + Property.PSI_Prop_ID__c );
                                 OtherInfo.put( 'Name', sr1.Contact_Name__r.Name );
                                 OtherInfo.put( 'MobileNumber', sr1.Contact_Mobile__c );
                                 OtherInfo.put( 'Email', sr1.Contact_Email__c );
                                 OtherInfo.put( 'PTE', sr1.Permission_to_Enter__c );

                                 //maintenanceLocationId
                                  OtherInfo.put( 'LocationId', '' );
                                 if( true == PropertyLocations.containsKey( Property.PSI_Prop_ID__c  ) && true == PropertyLocations.get( Property.PSI_Prop_ID__c ).containsKey( sr1.Room_Area_Impacted__c ) ) {
                                     for( String location: PropertyLocations.get( Property.PSI_Prop_ID__c ).keySet() ) {
                                         if( location == sr1.Room_Area_Impacted__c ) {
                                             OtherInfo.put( 'LocationId' , PropertyLocations.get( Property.PSI_Prop_ID__c ).get( location ).get( 'Id' ) );
                                             break;
                                         }
                                     }
                                 }

                                 //maintenanceProblemId
                                 List<Work_Order_Dispatch__c> WoDispatchLists = [ SELECT Id, Request_Category1__c FROM Work_Order_Dispatch__c WHERE Id = : sr1.Work_Order_Dispatch__c ];
                                 System.debug( 'WoDispatchLists - ' + WoDispatchLists );
                                 if( null != WoDispatchLists ) {
                                     for( Work_Order_Dispatch__c Wo: WoDispatchLists ) {
                                         if( true == PropertyProblems.containsKey( Property.PSI_Prop_ID__c  ) ) {
                                             for( String Problem : PropertyProblems.get( Property.PSI_Prop_ID__c ).keySet() ){
                                                 if( Wo.Request_Category1__c == Problem ) {
                                                     OtherInfo.put( 'ProblemId', PropertyProblems.get( Property.PSI_Prop_ID__c ).get( Wo.Request_Category1__c ).get('Id') ); 
                                                     break;
                                                 }
                                             }
                                         }
                                     }
                                 }
    
                                 //maintenancePriorityId
                                 List<Service_Request_Type__c> SRTypeList = [SELECT Id,Name,Request_Classification__c FROM Service_Request_Type__c WHERE Id =: sr1.Service_Request_Type__c AND Account__c =: sr1.Account__c ];
                                 if( null != SRTypeList ){
                                     for( Service_Request_Type__c SRType : SRTypeList ) {
                                         System.debug('PropertyPriorities - ' + PropertyPriorities);
                                         System.debug('Property.PSI_Prop_ID__c  -' + Property.PSI_Prop_ID__c );
                                         if( true == PropertyPriorities.containsKey( Property.PSI_Prop_ID__c ) ) {
                                             for( String Priority : PropertyPriorities.get( Property.PSI_Prop_ID__c ).keySet() ){
                                                 if( SRType.Request_Classification__c == Priority ) {
                                                     OtherInfo.put( 'PriorityId', PropertyPriorities.get( Property.PSI_Prop_ID__c ).get( SRType.Request_Classification__c ).get('Id') ); 
                                                     break;
                                                 }
                                             }
                                         }
                                     }
                                 }
    
                                 //maintenanceStatusTypeId
                                 /*System.debug( 'Property.PSI_Prop_ID__c ' + ( Property.PSI_Prop_ID__c ) );
                                 System.debug( 'PropertyStatusTypes.get( Property.PSI_Prop_ID__c ) -- ' + PropertyStatusTypes );
                                 System.debug( 'sr1.Status__c - ' + sr1.Status__c );*/
                                 
                                 OtherInfo.put( 'StatusTypeId', '');
                                 if( true == PropertyStatusTypes.containsKey( Property.PSI_Prop_ID__c ) ) {
                                     if( true == PropertyStatusTypes.get( Property.PSI_Prop_ID__c ).containsKey( sr1.Status__c ) ){
                                         OtherInfo.put( 'StatusTypeId', PropertyStatusTypes.get( Property.PSI_Prop_ID__c ).get( sr1.Status__c ).get( 'Id' ) );                       
                                     } else {
                                         //OtherInfo.put( 'StatusTypeId', PropertyStatusTypes.get( Property.PSI_Prop_ID__c ).get( 'In Progress' ).get( 'Id' ) );                       
                                         if( true ==  PropertyStatusTypes.containsKey( Property.PSI_Prop_ID__c ) && null != PropertyStatusTypes.get( Property.PSI_Prop_ID__c )  ) {
                                             for( String Id:  PropertyStatusTypes.get( Property.PSI_Prop_ID__c ).keySet() ){
                                                 OtherInfo.put( 'StatusTypeId', PropertyStatusTypes.get( Property.PSI_Prop_ID__c ).get( Id ).get( 'Id' ) );
                                                 break;
                                             }
                                         }
                                     }
                                 }
    
                                 System.debug( 'OtherInfo - ' + OtherInfo );
                                 //Build Request
                                 strRequest = this.BuildServiceRequestJson( strCredentials, OtherInfo );
                                
                                 // Send request
                                 HttpRequest request1 = new HttpRequest();
                                 request1.setEndpoint( strCredentials.get(1) + '/maintenance' );
                                 request1.setMethod( 'POST' );
                                 request1.setHeader( 'Content-Type', 'application/json' );
                                 request1.setTimeout(120000);
                                 System.debug( 'BuildServiceRequestJson -> ' + strRequest );
                                 request1.setBody( strRequest );
    
                                 if( false == IsTestScheduler ) {
                                     Http http1                  	= new Http();
                                     HTTPResponse response1      	= http1.send( request1 );
                                     responseJsonString  			=  response1.getBody();
                                 }
    
                                 System.debug( 'responseJsonString - ' + responseJsonString );
                                 //responseJsonString = '{ "response":{ "requestId":"15", "result":{ "Success": "Work orders inserted successfully." } } }';
                                 Map<String, String> SRResponse = responseServiceRequestJsonString( responseJsonString );
                                 System.debug( 'SRResponse - ' + SRResponse );
                                 
                                 sr1.Integration_Failed__c 					= ( 'true' == SRResponse.get( 'IsFailed' ) ? true : false );
                                 sr1.Work_Order_Entered_in_PMS__c			= ( 'true' == SRResponse.get( 'IsFailed' ) ? false : true );
                                 sr1.Integration_Fail_Success_Message__c	= SRResponse.get( 'Message' );
                                 //sr1.Customer_Work_Order_ID__c				= SRResponse.get( 'Id' );
                                 
                                 ServiceRequests.add( sr1 );
                             }
                         }
                     }
                 } //Integration Loop
             }
        }// SeachList Empty
        return ServiceRequests;
    }
    
    public String BuildWOPickListJson( List<String> Credetials, String CustPropIds ) {
        
        String UserName     = strCredentials.get(3);
        String Password     = strCredentials.get(2);
        
        JSONGenerator gen   = JSON.createGenerator(true);

        gen.writeStartObject();
            gen.writeFieldName( 'auth' ); 
            gen.writeStartObject();
                gen.writeStringField( 'type', 'basic' );
                gen.writeStringField( 'password', Password );
                gen.writeStringField( 'username', UserName );               
            gen.writeEndObject();
            gen.writeNumberField( 'requestId', 15 );
            gen.writeFieldName( 'method' ); 
            gen.writeStartObject();
                gen.writeStringField( 'name', 'getWorkOrderPickLists' );
                gen.writeFieldName( 'params' );
                gen.writeStartObject();
                    gen.writeStringField( 'propertyIds', CustPropIds );
                gen.writeEndObject();
            gen.writeEndObject();
        gen.writeEndObject();
         System.debug( gen.getAsString() );
        return gen.getAsString();

    }

    public void responseWOPickListJsonString ( String strJSON, String CustPropIds ){

        Map<String, Object> jsonObjectWOPickList   	= ( Map<String, Object> ) JSON.deserializeUntyped(strJSON);
        jsonObjectWOPickList            			= ( Map<String, Object> ) jsonObjectWOPickList.get( 'response' );
        if( jsonObjectWOPickList.containsKey( 'error' ) ) {
            jsonObjectWOPickList             		= ( Map<String, Object> ) jsonObjectWOPickList.get( 'error' );
            String message							= ( String ) jsonObjectWOPickList.get( 'message' );
            System.debug( 'Error - ' + message );
            return;
        }
        jsonObjectWOPickList             			= ( Map<String, Object> ) jsonObjectWOPickList.get( 'result' );
        jsonObjectWOPickList         				= ( Map<String, Object> ) jsonObjectWOPickList.get( 'Property' );
       // List<String>CustPropertyIds 				= CustPropIds.split( ',' );

        for( String CustPropertyId : jsonObjectWOPickList.keySet() ) {
            System.debug('CustPropertyId - ' + CustPropertyId);
            Map<String, Object>jsonObjectWOPickList1    	= ( Map<String, Object> ) jsonObjectWOPickList.get( CustPropertyId );
            
            //Locations
            if( jsonObjectWOPickList1.containsKey( 'Locations' ) ) {
                Map<String, Map<String, String>> Locations		= new Map<String, Map<String, String>>();
                Map<String, Object> jsonObjectLocations   		= ( Map<String, Object> ) jsonObjectWOPickList1.get( 'Locations' );
                List<Object> LocationsList_temp					= ( List<Object> ) jsonObjectLocations.get( 'Location' );
                for( Object LocationList1 : LocationsList_temp ) {
                    
                    Map<String, String> LocationsValues 		= new Map<String, String>();
                    Map<String, Object> LocationsList 			= ( Map<String, Object> ) LocationList1;
                    Map<String, Object> LocationsList_att		= ( Map<String, Object> ) LocationsList.get( '@attributes' );
                    String Id_Location							= '' + ( Integer ) LocationsList_att.get( 'Id' );
                    String Name_Location						= ( String ) LocationsList_att.get( 'Name' );
                    LocationsValues.put( 'Id', Id_Location );
                    Locations.put( Name_Location, LocationsValues );
                }
                PropertyLocations.put( CustPropertyId, Locations );
            }

            //Priorities
            if( jsonObjectWOPickList1.containsKey( 'Priorities' ) ) {
                Map<String, Map<String, String>> Priorities		= new Map<String, Map<String, String>>();
                Map<String, Object> jsonObjectPriorities   		= ( Map<String, Object> ) jsonObjectWOPickList1.get( 'Priorities' );
                List<Object> PrioritiesList_temp				= ( List<Object> ) jsonObjectPriorities.get( 'Priority' );
                for( Object PriorityList1 : PrioritiesList_temp ) {
                    
                    Map<String, String> PropertyPriorityValues 	= new Map<String, String>();
                    Map<String, Object> PrioritiesList 			= ( Map<String, Object> ) PriorityList1;
                    Map<String, Object> PrioritiesList_att		= ( Map<String, Object> ) PrioritiesList.get( '@attributes' );
                    String Code_Priority						= ( String ) PrioritiesList_att.get( 'Code' );
                    String Id_Priority							= '' + ( Integer ) PrioritiesList_att.get( 'Id' );
                    String Name_Priority						= ( String ) PrioritiesList_att.get( 'Name' );
                    PropertyPriorityValues.put( 'Code', Code_Priority );
                    PropertyPriorityValues.put( 'Id', Id_Priority );
                    Priorities.put( Name_Priority , PropertyPriorityValues );
                }
                PropertyPriorities.put( CustPropertyId, Priorities );
            }
            
            //Problems
            if( jsonObjectWOPickList1.containsKey( 'Problems' ) ) {
                Map<String, Map<String, String>> Problems		= new Map<String, Map<String, String>>();
                Map<String, Object> jsonObjectProblems   		= ( Map<String, Object> ) jsonObjectWOPickList1.get( 'Problems' );
                List<Object> ProblemsList_temp					= ( List<Object> ) jsonObjectProblems.get( 'Problem' );
                for( Object ProblemList1: ProblemsList_temp ) {
                    
                    Map<String, String> ProblemValues 			= new Map<String, String>();
                    Map<String, Object> ProblemList 			= ( Map<String, Object> ) ProblemList1;
                    Map<String, Object> ProblemsList_att		= ( Map<String, Object> ) ProblemList.get( '@attributes' );
                    String Name_Problem							= ( String ) ProblemsList_att.get( 'Name' );
                    String Id_Problem							= '' + ( Integer ) ProblemsList_att.get( 'Id' );
                    ProblemValues.put( 'Id' , Id_Problem );
                    Problems.put( Name_Problem, ProblemValues );
                }
                PropertyProblems.put( CustPropertyId, Problems);
        	}
            
            //StatusTypes
            if( jsonObjectWOPickList1.containsKey( 'StatusTypes' ) ) {
                Map<String, Map<String, String>> StatusTypes		= new Map<String, Map<String, String>>();
                Map<String, Object> jsonObjectStatusTypes   		= ( Map<String, Object> ) jsonObjectWOPickList1.get( 'StatusTypes' );
                List<Object> StatusTypesList_temp					= ( List<Object> ) jsonObjectStatusTypes.get( 'StatusType' );
                for( Object StatusTypeList1: StatusTypesList_temp ) {
                    
                    Map<String, String> StatusTypeValues 			= new Map<String, String>();
                    Map<String, Object> StatusTypeList 				= ( Map<String, Object> )StatusTypeList1;
                    Map<String, Object> StatusTypesList_att			= ( Map<String, Object> ) StatusTypeList.get( '@attributes' );
                    String Name_StatusType							= ( String ) StatusTypesList_att.get( 'Name' );
                    String Id_StatusType							= '' + ( Integer ) StatusTypesList_att.get( 'Id' );
                    String Code_StatusType							= ( String ) StatusTypesList_att.get( 'Code' );
                    StatusTypeValues.put( 'Id', Id_StatusType );
                    StatusTypeValues.put( 'Code', Code_StatusType );
                    StatusTypes.put( Name_StatusType, StatusTypeValues );
                }
                PropertyStatusTypes.put( CustPropertyId, StatusTypes );
            }
        }

        System.debug( 'PropertyPriorities1 - ' + PropertyPriorities.get( '104143' ) );
        //System.debug( 'PropertyPriorities2 - ' + PropertyPriorities.get( '22222' ) );
        System.debug( 'PropertyLocations1 - ' + PropertyLocations.get( '104143' ) );
       // System.debug( 'PropertyLocations2 - ' + PropertyLocations.get( '22222' ) );
        System.debug( 'PropertyProblems1 - ' + PropertyProblems.get( '104143' ) );
       // System.debug( 'PropertyProblems2 - ' + PropertyProblems.get( '22222' ) );
        System.debug( 'PropertyStatusTypes1 - ' + PropertyStatusTypes.get( '104143' ) );
      //  System.debug( 'PropertyStatusTypes2 - ' + PropertyStatusTypes.get( '22222' ) );

    }

    public String BuildServiceRequestJson( List<String> Credetials, Map<String, String> OtherInfo ) {
        
        String FirstName    = '';
        String LastName     = '';
        String UserName     = strCredentials.get(3);
        String Password     = strCredentials.get(2);

        //FirstName & LastName

        List<String> Name = OtherInfo.get( 'Name' ).split(' ');
        if( Name.size() == 2 ) {
            FirstName = Name[0];
            LastName  = Name[1];
        } else if( Name.size() == 1 ) {
            LastName  = Name[0];
        }
        
        JSONGenerator gen   = JSON.createGenerator(true);

        gen.writeStartObject();
            gen.writeFieldName( 'auth' ); 
            gen.writeStartObject();
                gen.writeStringField( 'type', 'basic' );
                gen.writeStringField( 'username', UserName );
                gen.writeStringField( 'password', Password );
            gen.writeEndObject();
            gen.writeNumberField( 'requestId', 15 );
            gen.writeFieldName( 'method' ); 
            gen.writeStartObject();
                gen.writeStringField( 'name', 'sendWorkOrders' );
                gen.writeFieldName( 'params' ); 
                gen.writeStartObject();
                    gen.writeFieldName( 'workOrder' );
                    gen.writeStartArray();
                        gen.writeStartObject();
                            gen.writeStringField( 'propertyId', OtherInfo.get( 'CustPropId' ) );
                            gen.writeStringField( 'customerId', '' );
                            gen.writeStringField( 'leaseId', '' );
                            gen.writeStringField( 'unitNumber', '' );
                            gen.writeStringField( 'customerFirstName', FirstName );
                            gen.writeStringField( 'customerLastName', LastName );
                            gen.writeStringField( 'mainPhoneNumber', ( null != OtherInfo.get('MobileNumber') ? OtherInfo.get('MobileNumber'): '' ) );
                            gen.writeStringField( 'altPhoneNumber', '' );
                            gen.writeStringField( 'emailAddress', ( null != OtherInfo.get('Email') ? OtherInfo.get('Email'): '' ) );
                            gen.writeStringField( 'permissionToEnter', ( null != OtherInfo.get('PTE') ? OtherInfo.get('PTE'): '' ) );
                            gen.writeStringField( 'maintenanceLocationId', '11362' );
                            gen.writeStringField( 'maintenanceCategoryId',  PropertyStatusTypes.get( OtherInfo.get( 'CustPropId' ) ).get( 'CALL' ).get( 'Id' )  );
                            gen.writeStringField( 'maintenanceProblemId', PropertyProblems.get( OtherInfo.get( 'CustPropId' ) ).get( 'Flooring' ).get( 'Id' ) );
                            gen.writeStringField( 'subMaintenanceProblemId', '' );
                            gen.writeStringField( 'maintenancePriorityId', PropertyPriorities.get( OtherInfo.get( 'CustPropId' ) ).get( 'Emergency' ).get( 'Id' ) );
                            gen.writeStringField( 'petsDescription', '' );
                            gen.writeStringField( 'problemDescription', 'asasas' );
                            gen.writeStringField( 'additionalInfo', '' );
                        gen.writeEndObject();
                    gen.writeEndArray();
                gen.writeEndObject();
            gen.writeEndObject();
        gen.writeEndObject();
          
        return gen.getAsString();
    }
    
    public Map<String, String> responseServiceRequestJsonString( String strJSON ) {

        Boolean IsFailed								= true;
        String message 									= '';
        String SRId										= '';
        Map<String, String> responseSR  				= new Map<String, String>();
        Map<String, Object> jsonObjectServiceRequest   	= ( Map<String, Object> ) JSON.deserializeUntyped(strJSON);

        jsonObjectServiceRequest            			= ( Map<String, Object> ) jsonObjectServiceRequest.get( 'response' );
       // jsonObjectServiceRequest            			= ( Map<String, Object> ) jsonObjectServiceRequest.get( 'result' );

        System.debug( 'jsonObjectServiceRequest -----' + jsonObjectServiceRequest );
        if( true == jsonObjectServiceRequest.containsKey( 'error' ) ) {
            jsonObjectServiceRequest	= ( Map<String, Object> ) jsonObjectServiceRequest.get( 'error' );
            message 					= ( String ) jsonObjectServiceRequest.get( 'message' );
        } else if( true == jsonObjectServiceRequest.containsKey( 'Success' ) ){
            jsonObjectServiceRequest	= ( Map<String, Object> ) jsonObjectServiceRequest.get( 'Success' );
            message 					= ( String ) jsonObjectServiceRequest.get( 'message' );
            //SRId 						= ( String ) jsonObjectServiceRequest.get( 'Id' );
            IsFailed					= false;
        }
        responseSR.put( 'Id', SRId );
        responseSR.put( 'Message', message );
        responseSR.put( 'IsFailed', '' + IsFailed );
        
        return responseSR;
        
    }
}