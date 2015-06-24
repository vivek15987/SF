public class YardiGCPushWsdltoApexController {
	
    public class GetPropertyConfigurations_element {
        
        public String UserName;
        public String Password;
        public String ServerName;
        public String Database;
        public String Platform;
        public String InterfaceEntity;
        public String InterfaceLicense;
        private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] ServerName_type_info = new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Database_type_info = new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Platform_type_info = new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceEntity_type_info = new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Password','ServerName','Database','Platform','InterfaceEntity','InterfaceLicense'};
    
        public GetPropertyConfigurations_element() {} 
        
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

    public class GetYardiAgentsSourcesResults_Login_element {
        
        public String UserName;
        public String Password;
        public String ServerName;
        public String Database;
        public String Platform;
        public String YardiPropertyId;
        public String InterfaceEntity;
        public String InterfaceLicense;
        private String[] UserName_type_info 		= new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Password_type_info 		= new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] ServerName_type_info 		= new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Database_type_info 		= new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Platform_type_info 		= new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] YardiPropertyId_type_info 	= new String[]{'YardiPropertyId','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceEntity_type_info 	= new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] apex_schema_type_info 		= new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard','true','false'};
        private String[] field_order_type_info 		= new String[]{'UserName','Password','ServerName','Database','Platform','YardiPropertyId','InterfaceEntity','InterfaceLicense'};
    
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
        public String DateOfBirth;
        public String FederalId;
        private String[] UserName_type_info 		= new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Password_type_info 		= new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] ServerName_type_info 		= new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Database_type_info 		= new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Platform_type_info 		= new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] YardiPropertyId_type_info 	= new String[]{'YardiPropertyId','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceEntity_type_info 	= new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] FirstName_type_info 		= new String[]{'FirstName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] LastName_type_info 		= new String[]{'LastName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] EmailAddress_type_info 	= new String[]{'EmailAddress','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] PhoneNumber_type_info 		= new String[]{'PhoneNumber','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] ThirdPartyId_type_info 	= new String[]{'ThirdPartyId','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] DateOfBirth_type_info 		= new String[]{'DateOfBirth','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] FederalId_type_info 		= new String[]{'FederalId','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] apex_schema_type_info 		= new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard','true','false'};
        private String[] field_order_type_info 		= new String[]{'UserName','Password','ServerName','Database','Platform','YardiPropertyId','InterfaceEntity','InterfaceLicense','FirstName','LastName','EmailAddress','PhoneNumber','ThirdPartyId','DateOfBirth','FederalId'};
    
        public GetYardiGuestActivity_Search_element() {} 
        
        public GetYardiGuestActivity_Search_element( String UserName, String Password, String ServerName, String Database, String Platform, String YardiPropertyId, String InterfaceEntity, String InterfaceLicense, String FirstName, String LastName, String EmailAddress, String PhoneNumber, String ThirdPartyId, String DateOfBirth, String FederalId ) {
        	
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
            this.DateOfBirth		= DateOfBirth;
            this.FederalId			= FederalId;
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
            Dom.XmlNode DateOfBirthNode			= outerNode.addChildElement( 'itf:DateOfBirth', null, null );
            Dom.XmlNode FederalIdNode			= outerNode.addChildElement( 'itf:FederalId', null, null );     
            
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
            DateOfBirthNode.addTextNode( ( this.DateOfBirth == null ) ? '' : this.DateOfBirth );
            FederalIdNode.addTextNode( ( this.FederalId == null ) ? '' : this.FederalId );
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
        private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] ServerName_type_info = new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Database_type_info = new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Platform_type_info = new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] YardiPropertyId_type_info = new String[]{'YardiPropertyId','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceEntity_type_info = new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard','true','false'};
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
    
    public class UnitAvailability_LoginByUnit_element {
        public String UserName;
        public String Password;
        public String ServerName;
        public String Database;
        public String Platform;
        public String YardiPropertyId;
        public String UnitTypeCode;
        public String UnitCode;
        public String InterfaceEntity;
        public String InterfaceLicense;
        private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] ServerName_type_info = new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Database_type_info = new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Platform_type_info = new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] YardiPropertyId_type_info = new String[]{'YardiPropertyId','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] UnitTypeCode_type_info = new String[]{'UnitTypeCode','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] UnitCode_type_info = new String[]{'UnitCode','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceEntity_type_info = new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Password','ServerName','Database','Platform','YardiPropertyId', 'UnitTypeCode', 'UnitCode', 'InterfaceEntity','InterfaceLicense'};
    
        public UnitAvailability_LoginByUnit_element() {} 
        
        public UnitAvailability_LoginByUnit_element( String UserName, String Password, String ServerName, String Database, String Platform, String YardiPropertyId, String UnitTypeCode, String UnitCode, String InterfaceEntity, String InterfaceLicense ) {
        	
            this.UserName 			= UserName;
            this.Password 			= Password;
            this.ServerName 		= ServerName;
            this.Database 			= Database;
            this.Platform 			= Platform;
            this.YardiPropertyId 	= YardiPropertyId;
            this.UnitTypeCode		= UnitTypeCode;
            this.UnitCode 			= UnitCode;
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
            Dom.XmlNode UnitTypeCode 			= outerNode.addChildElement( 'itf:UnitTypeCode', null, null );
            Dom.XmlNode UnitCode 				= outerNode.addChildElement( 'itf:UnitCode', null, null );
            Dom.XmlNode InterfaceEntityNode 	= outerNode.addChildElement( 'itf:InterfaceEntity', null, null );
            Dom.XmlNode InterfaceLicenseNode 	= outerNode.addChildElement( 'itf:InterfaceLicense', null, null );
            
            UserNameNode.addTextNode( ( this.UserName == null ) ? '' : this.UserName );
            PasswordNode.addTextNode( ( this.Password == null ) ? '' : this.Password );
            ServerNameNode.addTextNode( ( this.ServerName == null ) ? '' : this.ServerName );
			DatabaseNode.addTextNode( ( this.Database == null ) ? '' : this.Database );
            PlatformNode.addTextNode( ( this.Platform == null ) ? '' : this.Platform );
			YardiPropertyIdNode.addTextNode( ( this.YardiPropertyId == null ) ? '' : this.YardiPropertyId );
            UnitTypeCode.addTextNode( ( this.UnitTypeCode == null ) ? '' : this.UnitTypeCode );
            UnitCode.addTextNode( ( this.UnitCode == null ) ? '' : this.UnitCode );
            InterfaceEntityNode.addTextNode( ( this.InterfaceEntity == null) ? '' : this.InterfaceEntity );
            InterfaceLicenseNode.addTextNode( ( this.InterfaceLicense == null ) ? '' : this.InterfaceLicense );
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
        public YardiGCPushWsdltoApexController.XmlDoc_element XmlDoc;
        private String[] UserName_type_info 		= new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Password_type_info 		= new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] ServerName_type_info 		= new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Database_type_info 		= new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] Platform_type_info 		= new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceEntity_type_info 	= new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] XmlDoc_type_info 			= new String[]{'XmlDoc','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard',null,'0','1','false'};
        private String[] apex_schema_type_info 		= new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard','true','false'};
        private String[] field_order_type_info 		= new String[]{'UserName','Password','ServerName','Database','Platform','InterfaceEntity','InterfaceLicense','XmlDoc'};
    	
        public ImportYardiGuest_Login_element() {}
        
        public ImportYardiGuest_Login_element( String UserName, String Password, String ServerName, String Database, String Platform, String InterfaceEntity,String InterfaceLicense, YardiGCPushWsdltoApexController.XmlDoc_element GuestCardXml ) {
            
            this.UserName 			= UserName;
            this.Password 			= Password;
            this.ServerName 		= ServerName;
            this.Database 			= Database;
            this.Platform 			= Platform;
            this.InterfaceEntity 	= InterfaceEntity;
            this.InterfaceLicense 	= InterfaceLicense;
            this.XmlDoc 			= GuestCardXml;
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
			
            YardiGCPushWsdltoApexController.XmlDoc_element XmlObj 	= this.XmlDoc;
            Dom.XmlNode GuestCardXmlNode 				= outerNode.addChildElement( 'itf:XmlDoc', null, null );
            
            if(XmlObj != null){
                XmlObj.populateXmlNode( GuestCardXmlNode );
            }
        }
    }
  
    public class XmlDoc_element {
        
        public String anyElement;
        private String[] anyElement_type_info 	= new String[]{'anyElement','http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard','List<DOM.XmlNode>','0','1','true'};
        private String[] apex_schema_type_info 	= new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard','true','false'};
        private String[] field_order_type_info 	= new String[]{};
            
        public void populateXmlNode(Dom.XmlNode outerNode){
             
            Dom.Xmlnode GuestCards = outerNode.addCommentNode(this.anyElement);
        }
    }
    
    public class ItfILSGuestCardSoap {
        
        public String endpoint_x = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfilsguestcard.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard', 'YardiGCPushWsdltoApexController'};
        
        public String GetPropertyConfigurations( String UserName,String Password,String ServerName,String Database,String Platform,String InterfaceEntity,String InterfaceLicense ) {
        	
            String responseXMLString;
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:GetPropertyConfigurations', null, null);
            
            YardiGCPushWsdltoApexController.GetPropertyConfigurations_element request_x = new YardiGCPushWsdltoApexController.GetPropertyConfigurations_element( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense );
			
            request_x.populateXmlNode(methodNode);
			
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setTimeout(120000);
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard/GetPropertyConfigurations' );
            request.setBodyDocument( Doc );
            
            Http http 				= new Http();
            
            HTTPResponse response 	= http.send( request );
            responseXMLString 		= response.getBody();
            
            return responseXMLString;            
        }    
            
        public String GetYardiAgentsSourcesResults_Login( String UserName,String Password,String ServerName,String Database,String Platform,String YardiPropertyId,String InterfaceEntity,String InterfaceLicense ) {
        	
            String responseXMLString;
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:GetYardiAgentsSourcesResults_Login', null, null);          
			
            YardiGCPushWsdltoApexController.GetYardiAgentsSourcesResults_Login_element request_x = new YardiGCPushWsdltoApexController.GetYardiAgentsSourcesResults_Login_element( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense );

            request_x.populateXmlNode(methodNode);
            
            System.debug( request_x );
			
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setTimeout(120000);
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard/GetYardiAgentsSourcesResults_Login' );
            request.setBodyDocument( Doc );
           
            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		=  response.getBody();
            
            return responseXMLString;
        }
            
       	public String GetYardiGuestActivity_Search( String UserName,String Password,String ServerName,String Database,String Platform,String YardiPropertyId,String InterfaceEntity,String InterfaceLicense,String FirstName,String LastName,String EmailAddress,String PhoneNumber,String ThirdPartyId,String DateOfBirth,String FederalId ) {
        	
            String responseXMLString;
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:GetYardiGuestActivity_Search', null, null);          
            YardiGCPushWsdltoApexController.GetYardiGuestActivity_Search_element request_x = new YardiGCPushWsdltoApexController.GetYardiGuestActivity_Search_element( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense, FirstName, LastName, EmailAddress, PhoneNumber, ThirdPartyId, DateOfBirth, FederalId );

            request_x.populateXmlNode(methodNode);
			
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setTimeout(120000);
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard/GetYardiGuestActivity_Search' );
            request.setBodyDocument( Doc );
            
            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		= response.getBody();
            
            return responseXMLString;
        }
        
        public String UnitAvailability_Login( String UserName,String Password,String ServerName,String Database,String Platform,String YardiPropertyId,String InterfaceEntity,String InterfaceLicense ) {
            
            String responseXMLString;
            
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:UnitAvailability_Login', null, null);          
            
            YardiGCPushWsdltoApexController.UnitAvailability_Login_element request_x = new YardiGCPushWsdltoApexController.UnitAvailability_Login_element( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense );
				
            request_x.populateXmlNode(methodNode);
			
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setTimeout(120000);
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard/UnitAvailability_Login' );
            request.setBodyDocument( Doc );
            
            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		= response.getBody();
           
            return responseXMLString;
        }
        
        public String UnitAvailability_LoginByUnit( String UserName,String Password,String ServerName,String Database,String Platform,String YardiPropertyId, String UnitTypeCode, String UnitCode, String InterfaceEntity,String InterfaceLicense ) {
            
            String responseXMLString;
            
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:UnitAvailability_LoginByUnit', null, null);          
            
            YardiGCPushWsdltoApexController.UnitAvailability_LoginByUnit_element request_x = new YardiGCPushWsdltoApexController.UnitAvailability_LoginByUnit_element( UserName, Password, ServerName, Database, Platform, YardiPropertyId, UnitTypeCode, UnitCode, InterfaceEntity, InterfaceLicense );
			
            request_x.populateXmlNode(methodNode);
			
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setTimeout(120000);
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard/UnitAvailability_LoginByUnit' );
            request.setBodyDocument( Doc );
            System.debug( Doc.toXmlString() );
            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		= response.getBody();
           
            return responseXMLString;
        }
        
        public String ImportYardiGuest_Login( String UserName,String Password,String ServerName,String Database,String Platform,String InterfaceEntity,String InterfaceLicense,YardiGCPushWsdltoApexController.XmlDoc_element XmlDoc) {
           	
            String responseXMLString;
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:ImportYardiGuest_Login', null, null);          
            YardiGCPushWsdltoApexController.ImportYardiGuest_Login_element request_x = new YardiGCPushWsdltoApexController.ImportYardiGuest_Login_element( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense, XmlDoc );

            request_x.populateXmlNode(methodNode);
			
            String GuestCardFinalXML 	= Doc.toXmlString();
            GuestCardFinalXML 			= GuestCardFinalXML.replace('<!--', '');
			GuestCardFinalXML			= GuestCardFinalXML.replace('-->', '');
            
            DOM.Document FinalDoc		= new DOM.Document();	
            FinalDoc.load(GuestCardFinalXML);
            System.debug('GC4.0 Request : ' + GuestCardFinalXML);
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setTimeout(120000);
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard/ImportYardiGuest_Login' );
            request.setBodyDocument( FinalDoc );

            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		=  response.getBody();
            
            return responseXMLString;            
        }
    }

}