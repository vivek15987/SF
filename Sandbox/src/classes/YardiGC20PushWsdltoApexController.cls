public class YardiGC20PushWsdltoApexController {
    
    public class GetYardiGuestActivity_Search_element {
        public String UserName;
        public String Password;
        public String ServerName;
        public String Database;
        public String Platform;
        public String YardiPropertyId;
        public String InterfaceEntity;
        public String InterfaceLicense;
        public String FirstName;
        public String LastName;
        public String EmailAddress;
        public String PhoneNumber;
        public String ThirdPartyId;
        private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] ServerName_type_info = new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Database_type_info = new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Platform_type_info = new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] YardiPropertyId_type_info = new String[]{'YardiPropertyId','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] InterfaceEntity_type_info = new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] FirstName_type_info = new String[]{'FirstName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] LastName_type_info = new String[]{'LastName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] EmailAddress_type_info = new String[]{'EmailAddress','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] PhoneNumber_type_info = new String[]{'PhoneNumber','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] ThirdPartyId_type_info = new String[]{'ThirdPartyId','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Password','ServerName','Database','Platform','YardiPropertyId','InterfaceEntity','InterfaceLicense','FirstName','LastName','EmailAddress','PhoneNumber','ThirdPartyId'};
      
        public GetYardiGuestActivity_Search_element( String UserName, String Password, String ServerName, String Database, String Platform, String YardiPropertyId, String InterfaceEntity, String InterfaceLicense, String FirstName, String LastName, String EmailAddress, String PhoneNumber, String ThirdPartyId ) {
        	
            this.UserName 			= UserName;
            this.Password 			= Password;
            this.ServerName 		= ServerName;
            this.Database 			= Database;
            this.Platform 			= Platform;
            this.YardiPropertyId 	= YardiPropertyId;
            this.InterfaceEntity 	= InterfaceEntity;
            this.InterfaceLicense 	= InterfaceLicense;
            this.FirstName			= FirstName;
            this.LastName			= LastName;
            this.EmailAddress		= EmailAddress;
            this.PhoneNumber		= PhoneNumber;
            this.ThirdPartyId		= ThirdPartyId;
            
        }
        
        public void populateXmlNode( Dom.XmlNode outerNode ) {
   
            Dom.XmlNode UserNameNode 			= outerNode.addChildElement( 'itf:UserName', null, null );
            Dom.XmlNode PasswordNode 			= outerNode.addChildElement( 'itf:Password', null, null );
            Dom.XmlNode ServerNameNode 			= outerNode.addChildElement( 'itf:ServerName', null, null );
            Dom.XmlNode DatabaseNode 			= outerNode.addChildElement( 'itf:Database', null, null );
            Dom.XmlNode PlatformNode 			= outerNode.addChildElement( 'itf:Platform', null, null );
            Dom.XmlNode YardiPropertyIdNode 	= outerNode.addChildElement( 'itf:YardiPropertyId', null, null );
            Dom.XmlNode InterfaceEntityNode 	= outerNode.addChildElement( 'itf:InterfaceEntity', null, null );
            Dom.XmlNode InterfaceLicenseNode 	= outerNode.addChildElement( 'itf:InterfaceLicense', null, null );
            Dom.XmlNode FirstNameNode			= outerNode.addChildElement( 'itf:FirstName', null, null );
           	Dom.XmlNode LastNameNode 			= outerNode.addChildElement( 'itf:LastName', null, null );
            Dom.XmlNode EmailAddressNode		= outerNode.addChildElement( 'itf:EmailAddress', null, null );
            Dom.XmlNode PhoneNumberNode			= outerNode.addChildElement( 'itf:PhoneNumber', null, null );
            Dom.XmlNode ThirdPartyIdNode		= outerNode.addChildElement( 'itf:ThirdPartyId', null, null );
                       
            UserNameNode.addTextNode( ( this.UserName == null ) ? '' : this.UserName );
            PasswordNode.addTextNode( ( this.Password == null ) ? '' : this.Password );
            ServerNameNode.addTextNode( ( this.ServerName == null ) ? '' : this.ServerName );
			DatabaseNode.addTextNode( ( this.Database == null ) ? '' : this.Database );
            PlatformNode.addTextNode( ( this.Platform == null ) ? '' : this.Platform );
			YardiPropertyIdNode.addTextNode( ( this.YardiPropertyId == null ) ? '' : this.YardiPropertyId );
            InterfaceEntityNode.addTextNode( ( this.InterfaceEntity == null) ? '' : this.InterfaceEntity );
            InterfaceLicenseNode.addTextNode( ( this.InterfaceLicense == null ) ? '' : this.InterfaceLicense );
            FirstNameNode.addTextNode( ( this.FirstName == null ) ? '' : this.FirstName );
            LastNameNode.addTextNode( ( this.LastName == null ) ? '' : this.LastName );
            EmailAddressNode.addTextNode( ( this.EmailAddress == null ) ? '' : this.EmailAddress );
            PhoneNumberNode.addTextNode( ( this.PhoneNumber == null ) ? '' : this.PhoneNumber );
            ThirdPartyIdNode.addTextNode( ( this.ThirdPartyId == null ) ? '' : this.ThirdPartyId );
            
       	}
    }
    
    public class XmlDocument_element {
        
        public String anyElement;
        private String[] anyElement_type_info 	= new String[]{'anyElement','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20','List<DOM.XmlNode>','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20','true','false'};
        private String[] field_order_type_info = new String[]{};
            
       	public void populateXmlNode(Dom.XmlNode outerNode){
                
            Dom.Xmlnode GuestCards = outerNode.addCommentNode(this.anyElement);
        }
    }
    
    public class ImportYardiGuest_Login_element {
        public String UserName;
        public String Password;
        public String ServerName;
        public String Database;
        public String Platform;
        public String InterfaceEntity;
        public String InterfaceLicense;
        public YardiGC20PushWsdltoApexController.XmlDocument_element XmlDocument;
        private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] ServerName_type_info = new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Database_type_info = new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Platform_type_info = new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] InterfaceEntity_type_info = new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] XmlDocument_type_info = new String[]{'XmlDocument','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Password','ServerName','Database','Platform','InterfaceEntity','InterfaceLicense','XmlDocument'};
    
        public ImportYardiGuest_Login_element( String UserName, String Password, String ServerName, String Database, String Platform, String InterfaceEntity,String InterfaceLicense, YardiGC20PushWsdltoApexController.XmlDocument_element GuestCardXml ) {
            
            this.UserName 			= UserName;
            this.Password 			= Password;
            this.ServerName 		= ServerName;
            this.Database 			= Database;
            this.Platform 			= Platform;
            this.InterfaceEntity 	= InterfaceEntity;
            this.InterfaceLicense 	= InterfaceLicense;
            this.XmlDocument 			= GuestCardXml;
        }
        
        public void populateXmlNode( Dom.XmlNode outerNode ){

            Dom.XmlNode UserNameNode 			= outerNode.addChildElement( 'itf:UserName', null, null );
            Dom.XmlNode PasswordNode 			= outerNode.addChildElement( 'itf:Password', null, null );
            Dom.XmlNode ServerNameNode 			= outerNode.addChildElement( 'itf:ServerName', null, null );
            Dom.XmlNode DatabaseNode 			= outerNode.addChildElement( 'itf:Database', null, null );
            Dom.XmlNode PlatformNode 			= outerNode.addChildElement( 'itf:Platform', null, null );
            Dom.XmlNode InterfaceEntityNode 	= outerNode.addChildElement( 'itf:InterfaceEntity', null, null );
            Dom.XmlNode InterfaceLicenseNode 	= outerNode.addChildElement( 'itf:InterfaceLicense', null, null );
            
            UserNameNode.addTextNode( ( this.UserName == null ) ? '' : this.UserName );
            PasswordNode.addTextNode( ( this.Password == null ) ? '' : this.Password );
            ServerNameNode.addTextNode( ( this.ServerName == null ) ? '' : this.ServerName );
			DatabaseNode.addTextNode( ( this.Database == null ) ? '' : this.Database );
            PlatformNode.addTextNode( ( this.Platform == null ) ? '' : this.Platform );
			InterfaceEntityNode.addTextNode( ( this.InterfaceEntity == null) ? '' : this.InterfaceEntity );
            InterfaceLicenseNode.addTextNode( ( this.InterfaceLicense == null ) ? '' : this.InterfaceLicense );
			
            YardiGC20PushWsdltoApexController.XmlDocument_element XmlObj 	= this.XmlDocument;
            Dom.XmlNode GuestCardXmlNode	 				= outerNode.addChildElement( 'itf:XmlDocument', null, null );

            if(XmlObj != null){
                XmlObj.populateXmlNode( GuestCardXmlNode );
            }
        }
     }
  
    public class GetYardiAgentsSourcesResults_Login_element {
        public String UserName;
        public String Password;
        public String ServerName;
        public String Database;
        public String Platform;
        public String YardiPropertyId;
        public String InterfaceEntity;
        public String InterfaceLicense;
        private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] ServerName_type_info = new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Database_type_info = new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Platform_type_info = new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] YardiPropertyId_type_info = new String[]{'YardiPropertyId','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] InterfaceEntity_type_info = new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Password','ServerName','Database','Platform','YardiPropertyId','InterfaceEntity','InterfaceLicense'};
            
         public GetYardiAgentsSourcesResults_Login_element() {} 
        
        public GetYardiAgentsSourcesResults_Login_element( String UserName, String Password, String ServerName, String Database, String Platform, String YardiPropertyId, String InterfaceEntity, String InterfaceLicense ) {
            
            this.UserName 			= UserName;
            this.Password 			= Password;
            this.ServerName 		= ServerName;
            this.Database 			= Database;
            this.Platform 			= Platform;
            this.YardiPropertyId 	= YardiPropertyId;
            this.InterfaceEntity 	= InterfaceEntity;
            this.InterfaceLicense 	= InterfaceLicense;
        }
        
        public void populateXmlNode( Dom.XmlNode outerNode ){
   
            Dom.XmlNode UserNameNode 			= outerNode.addChildElement( 'itf:UserName', null, null );
            Dom.XmlNode PasswordNode 			= outerNode.addChildElement( 'itf:Password', null, null );
            Dom.XmlNode ServerNameNode 			= outerNode.addChildElement( 'itf:ServerName', null, null );
            Dom.XmlNode DatabaseNode 			= outerNode.addChildElement( 'itf:Database', null, null );
            Dom.XmlNode PlatformNode 			= outerNode.addChildElement( 'itf:Platform', null, null );
            Dom.XmlNode YardiPropertyIdNode 	= outerNode.addChildElement( 'itf:YardiPropertyId', null, null );
            Dom.XmlNode InterfaceEntityNode 	= outerNode.addChildElement( 'itf:InterfaceEntity', null, null );
            Dom.XmlNode InterfaceLicenseNode 	= outerNode.addChildElement( 'itf:InterfaceLicense', null, null );
            
            UserNameNode.addTextNode( ( this.UserName == null ) ? '' : this.UserName );
            PasswordNode.addTextNode( ( this.Password == null ) ? '' : this.Password );
            ServerNameNode.addTextNode( ( this.ServerName == null ) ? '' : this.ServerName );
			DatabaseNode.addTextNode( ( this.Database == null ) ? '' : this.Database );
            PlatformNode.addTextNode( ( this.Platform == null ) ? '' : this.Platform );
			YardiPropertyIdNode.addTextNode( ( this.YardiPropertyId == null ) ? '' : this.YardiPropertyId );
            InterfaceEntityNode.addTextNode( ( this.InterfaceEntity == null) ? '' : this.InterfaceEntity );
            InterfaceLicenseNode.addTextNode( ( this.InterfaceLicense == null ) ? '' : this.InterfaceLicense );
		}    
    }
    
    public class GetPropertyConfigurations_element {
        public String UserName;
        public String Password;
        public String ServerName;
        public String Database;
        public String Platform;
        public String InterfaceEntity;
        public String InterfaceLicense;
        private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] ServerName_type_info = new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Database_type_info = new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Platform_type_info = new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] InterfaceEntity_type_info = new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Password','ServerName','Database','Platform','InterfaceEntity','InterfaceLicense'};
    	
        public GetPropertyConfigurations_element( String UserName, String Password, String ServerName, String Database, String Platform, String InterfaceEntity, String InterfaceLicense ) {
            this.UserName 			= UserName;
            this.Password 			= Password;
            this.ServerName 		= ServerName;
            this.Database 			= Database;
            this.Platform 			= Platform;
            this.InterfaceEntity 	= InterfaceEntity;
            this.InterfaceLicense 	= InterfaceLicense;
        }
        public void populateXmlNode( Dom.XmlNode outerNode ){
   
            Dom.XmlNode UserNameNode 			= outerNode.addChildElement( 'itf:UserName', null, null );
            Dom.XmlNode PasswordNode 			= outerNode.addChildElement( 'itf:Password', null, null );
            Dom.XmlNode ServerNameNode 			= outerNode.addChildElement( 'itf:ServerName', null, null );
            Dom.XmlNode DatabaseNode 			= outerNode.addChildElement( 'itf:Database', null, null );
            Dom.XmlNode PlatformNode 			= outerNode.addChildElement( 'itf:Platform', null, null );
            Dom.XmlNode InterfaceEntityNode 	= outerNode.addChildElement( 'itf:InterfaceEntity', null, null );
            Dom.XmlNode InterfaceLicenseNode 	= outerNode.addChildElement( 'itf:InterfaceLicense', null, null );
            
            UserNameNode.addTextNode( ( this.UserName == null ) ? '' : this.UserName );
            PasswordNode.addTextNode( ( this.Password == null ) ? '' : this.Password );
            ServerNameNode.addTextNode( ( this.ServerName == null ) ? '' : this.ServerName );
			DatabaseNode.addTextNode( ( this.Database == null ) ? '' : this.Database );
            PlatformNode.addTextNode( ( this.Platform == null ) ? '' : this.Platform );
			InterfaceEntityNode.addTextNode( ( this.InterfaceEntity == null) ? '' : this.InterfaceEntity );
            InterfaceLicenseNode.addTextNode( ( this.InterfaceLicense == null ) ? '' : this.InterfaceLicense );
		}
     }
    
    public class UnitAvailability_Login_element {
        public String UserName;
        public String Password;
        public String ServerName;
        public String Database;
        public String Platform;
        public String YardiPropertyId;
        public String InterfaceEntity;
        public String InterfaceLicense;
        private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] ServerName_type_info = new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Database_type_info = new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] Platform_type_info = new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] YardiPropertyId_type_info = new String[]{'YardiPropertyId','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] InterfaceEntity_type_info = new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Password','ServerName','Database','Platform','YardiPropertyId','InterfaceEntity','InterfaceLicense'};
            
        public UnitAvailability_Login_element() {}
        
        public UnitAvailability_Login_element( String UserName, String Password, String ServerName, String Database, String Platform, String YardiPropertyId, String InterfaceEntity, String InterfaceLicense ) {
            
            this.UserName 			= UserName;
            this.Password 			= Password;
            this.ServerName 		= ServerName;
            this.Database 			= Database;
            this.Platform 			= Platform;
            this.YardiPropertyId 	= YardiPropertyId;
            this.InterfaceEntity 	= InterfaceEntity;
            this.InterfaceLicense 	= InterfaceLicense;
        }
        
        public void populateXmlNode( Dom.XmlNode outerNode ) {
   
            Dom.XmlNode UserNameNode 			= outerNode.addChildElement( 'itf:UserName', null, null );
            Dom.XmlNode PasswordNode 			= outerNode.addChildElement( 'itf:Password', null, null );
            Dom.XmlNode ServerNameNode 			= outerNode.addChildElement( 'itf:ServerName', null, null );
            Dom.XmlNode DatabaseNode 			= outerNode.addChildElement( 'itf:Database', null, null );
            Dom.XmlNode PlatformNode 			= outerNode.addChildElement( 'itf:Platform', null, null );
            Dom.XmlNode YardiPropertyIdNode 	= outerNode.addChildElement( 'itf:YardiPropertyId', null, null );
            Dom.XmlNode InterfaceEntityNode 	= outerNode.addChildElement( 'itf:InterfaceEntity', null, null );
            Dom.XmlNode InterfaceLicenseNode 	= outerNode.addChildElement( 'itf:InterfaceLicense', null, null );
            
            UserNameNode.addTextNode( ( this.UserName == null ) ? '' : this.UserName );
            PasswordNode.addTextNode( ( this.Password == null ) ? '' : this.Password );
            ServerNameNode.addTextNode( ( this.ServerName == null ) ? '' : this.ServerName );
			DatabaseNode.addTextNode( ( this.Database == null ) ? '' : this.Database );
            PlatformNode.addTextNode( ( this.Platform == null ) ? '' : this.Platform );
			YardiPropertyIdNode.addTextNode( ( this.YardiPropertyId == null ) ? '' : this.YardiPropertyId );
            InterfaceEntityNode.addTextNode( ( this.InterfaceEntity == null) ? '' : this.InterfaceEntity );
            InterfaceLicenseNode.addTextNode( ( this.InterfaceLicense == null ) ? '' : this.InterfaceLicense );
		}
    }
    
    public class ItfILSGuestCard2_0Soap {
        public String endpoint_x = 'https://www.iyardiasp.com/8223thirdqa/webservices/itfilsguestcard20.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20', 'YardiGC20PushWsdltoApexController'};
        
        public String ImportYardiGuest_Login( String UserName,String Password,String ServerName,String Database,String Platform,String InterfaceEntity,String InterfaceLicense,YardiGC20PushWsdltoApexController.XmlDocument_element XmlDoc) {

            String responseXMLString;
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:ImportYardiGuest_Login', null, null);          
            YardiGC20PushWsdltoApexController.ImportYardiGuest_Login_element request_x = new YardiGC20PushWsdltoApexController.ImportYardiGuest_Login_element( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense, XmlDoc );

            request_x.populateXmlNode(methodNode);
			
            String GuestCardFinalXML 	= Doc.toXmlString();
            GuestCardFinalXML 			= GuestCardFinalXML.replace('<!--', '');
			GuestCardFinalXML			= GuestCardFinalXML.replace('-->', '');
            
            DOM.Document FinalDoc		= new DOM.Document();	
            FinalDoc.load(GuestCardFinalXML);
			System.debug( 'GC2.0 Request : '+ GuestCardFinalXML );
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setTimeout(120000);
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20/ImportYardiGuest_Login' );
            request.setBodyDocument( FinalDoc );
            
            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		=  response.getBody();
            
            return responseXMLString;            
        }
        
        public String GetPropertyConfigurations( String UserName,String Password,String ServerName,String Database,String Platform,String InterfaceEntity,String InterfaceLicense ) {
        	
            String responseXMLString;
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:GetPropertyConfigurations', null, null);
            
            YardiGC20PushWsdltoApexController.GetPropertyConfigurations_element request_x = new YardiGC20PushWsdltoApexController.GetPropertyConfigurations_element( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense );
			
            request_x.populateXmlNode(methodNode);

            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setTimeout(120000);
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20/GetPropertyConfigurations' );
            request.setBodyDocument( Doc );
            
            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		=  response.getBody();
           
            return responseXMLString;            
        }
        
        public String GetYardiAgentsSourcesResults_Login( String UserName,String Password,String ServerName,String Database,String Platform,String YardiPropertyId,String InterfaceEntity,String InterfaceLicense ) {
        	
            String responseXMLString;
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:GetYardiAgentsSourcesResults_Login', null, null);          
			
            YardiGC20PushWsdltoApexController.GetYardiAgentsSourcesResults_Login_element request_x = new YardiGC20PushWsdltoApexController.GetYardiAgentsSourcesResults_Login_element( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense );

            request_x.populateXmlNode(methodNode);
			
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setTimeout(120000);
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20/GetYardiAgentsSourcesResults_Login' );
            request.setBodyDocument( Doc );

            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		=  response.getBody();
            
            return responseXMLString;
        }
        
        public String GetYardiGuestActivity_Search( String UserName,String Password,String ServerName,String Database,String Platform,String YardiPropertyId,String InterfaceEntity,String InterfaceLicense,String FirstName,String LastName,String EmailAddress,String PhoneNumber,String ThirdPartyId ) {
        	
            String responseXMLString;
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:GetYardiGuestActivity_Search', null, null);          
            YardiGC20PushWsdltoApexController.GetYardiGuestActivity_Search_element request_x = new YardiGC20PushWsdltoApexController.GetYardiGuestActivity_Search_element( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense, FirstName, LastName, EmailAddress, PhoneNumber, ThirdPartyId );

            request_x.populateXmlNode(methodNode);
			
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setTimeout(120000);
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20/GetYardiGuestActivity_Search' );
            request.setBodyDocument( Doc );
            
            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		= response.getBody();
            
            return responseXMLString;
        }
        
        public String UnitAvailability_Login( String UserName,String Password,String ServerName,String Database,String Platform,String YardiPropertyId,String InterfaceEntity,String InterfaceLicense) {


            String responseXMLString;
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20' ); 
        	
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:UnitAvailability_Login', null, null);    

            YardiGC20PushWsdltoApexController.UnitAvailability_Login_element request_x = new YardiGC20PushWsdltoApexController.UnitAvailability_Login_element( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense );

            request_x.populateXmlNode(methodNode);
			
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setTimeout(120000);
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20/UnitAvailability_Login' );
            request.setBodyDocument( Doc );
            
            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		= response.getBody();
			
            return responseXMLString;     
        }
    }

}