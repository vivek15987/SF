public class PSISearchCustomersController {

    public String strRequest              = '';
    public List<Contact> Contacts            = new List<Contact>();
    public List<String> PropertyIds            = new List<String>();
    public Map<String, Set<String>> strAccountURLs    = new Map<String, Set<String>>();
    public List<String> strCredentials             = new List<String>();

    
     //Fetch All Properties
    public List<Contact> searchCustomers( Boolean IsScheduler, String Search ) {

        List<Integration__c> searchList = [ SELECT 
                                                 Account__c, PSI_API_URL__c,PSI_Password__c,PSI_Username__c 
                                             FROM
                                                Integration__c
                                             WHERE
                         						Get_PSI_Unit_Availability__c != null
                                           ];

          if( !searchList.isEmpty() ) {
              
              for( Integration__c I :searchList ) {     
                  
                  strCredentials.clear();
                  strCredentials.add( I.PSI_API_URL__c );
                  strCredentials.add( I.PSI_Username__c );
                  strCredentials.add( I.PSI_Password__c );
                  strCredentials.add( I.Account__c );
                  strCredentials.add( Search );
              
                  if( strAccountURLs.isEmpty() || !strAccountURLs.containsKey( I.Account__c ) || ( strAccountURLs.containsKey( I.Account__c) && !strAccountURLs.get(I.Account__c).contains(I.PSI_API_URL__c) ) ) {
                      
                      List<Property__c> ProepertyList = [SELECT PSI_Prop_ID__c FROM Property__c WHERE Account__c = :I.Account__c];
                      for( Property__c P : ProepertyList ) {

                          Set<String> tempSet = new Set<String>();
                          if( strAccountURLs.containsKey( I.Account__c) ) {
                              tempSet = strAccountURLs.get( I.Account__c );
                          } 
                          
                          strCredentials.add( P.PSI_Prop_ID__c );
                          tempSet.add( I.PSI_API_URL__c );
                          strAccountURLs.put( I.Account__c, tempSet );
                          
                          // Build request
                          buildRequest( strCredentials );
                          // variable 'strRequest' has request;

                          // Send request
                          HttpRequest request = new HttpRequest();
                          request.setEndpoint( 'https://laramar.propertysolutions.com/api/customers' );
                          request.setMethod( 'POST' );
                          request.setHeader( 'Content-Type', 'application/json' );
                          request.setTimeout(120000);
                          request.setBody( strRequest );
                          
                          Http http           = new Http();
                          HTTPResponse response     = http.send( request );
                          String responseJsonString   =  response.getBody();
    
                          System.debug( strRequest );
                          System.debug('responseJsonString - ' + responseJsonString );
                          responseJsonString = '{ "response":{ "requestId":"15", "result":{ "Customers":{ "customer":[ { "Id": "000000", "NamePrefix":"Mr.", "FirstName":"Dave", "LastName":"Robinson", "UnitNumber":"111", "BuildingName":"Thornberry", "Email":"dummy@example.com" }, { "Id": "0000000", "NamePrefix":"Mr.", "FirstName":"Kurt", "LastName":"Dunn", "UnitNumber":"112", "BuildingName":"Thornberry", "Email":"dummy1@example.com" } ] } } } }';
                          // Parse response
                          Contacts  = parseJSONresponse( responseJsonString );
                         }
                  }
              }
          }
        return Contacts;
    }

    public void buildRequest( List<String>strCredentials ){

        String UserName = strCredentials.get(1);
        String Password  = strCredentials.get(2);

        JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
                gen.writeFieldName('auth'); 
                gen.writeStartObject();
                gen.writeStringField( 'type', 'basic' );
                gen.writeStringField( 'username', UserName );
                gen.writeStringField( 'password', Password );
            gen.writeEndObject();
            gen.writeNumberField( 'requestId', 15 );
            gen.writeFieldName( 'method' ); 
            gen.writeStartObject();
                gen.writeStringField( 'name', 'searchCustomers' );
                gen.writeStringField( 'propertyId', strCredentials.get(5) );
              gen.writeStringField( 'search', strCredentials.get(4)  );
            gen.writeEndObject();
        strRequest = gen.getAsString();
    }

    public List<Contact> parseJSONresponse( String strJSON ){

        Map<String, Object> jsonObjectContacts  	= (Map<String, Object>) JSON.deserializeUntyped(strJSON);
        jsonObjectContacts             				= ( Map<String, Object> ) jsonObjectContacts.get( 'response' );
        jsonObjectContacts             				= ( Map<String, Object> ) jsonObjectContacts.get( 'result' );
        jsonObjectContacts             				= ( Map<String, Object> ) jsonObjectContacts.get( 'Customers' );
        List<Object> Contacts_temp        			= ( List<Object> ) jsonObjectContacts.get( 'customer' );
        List<Contact> SearchedContacts       		= new List<Contact>();

        for( Object Contact1 :Contacts_temp ) {

            //Id
            //UnitNumber
            //BuildingName
            try {
                Map<String, Object> Contact        	= ( Map<String, Object> ) Contact1;
                Contact C                 			= new Contact();
                String Id                			= ( String ) Contact.get( 'Id' );
                String NamePrefix            		= ( String ) Contact.get( 'NamePrefix' );
                String FirstName            		= ( String ) Contact.get( 'FirstName' );
                C.FirstName                			= NamePrefix + ' ' + FirstName;
                String LastName              		= ( String ) Contact.get( 'LastName' );
                C.LastName                			= LastName;
                String UnitNumber            		= ( String ) Contact.get( 'UnitNumber' );
                String BuildingName            		= ( String ) Contact.get( 'BuildingName' );
                String Email              			= ( String ) Contact.get( 'Email' );
                C.Email                  			= Email;
                SearchedContacts.add( C );

            } catch( Exception e ) {

               System.debug( 'Error - ' + e.getMessage() );
               System.debug( 'Stack - ' + e.getStackTraceString() );
           } 
        }

        System.debug( SearchedContacts );
        return SearchedContacts;
    }
}