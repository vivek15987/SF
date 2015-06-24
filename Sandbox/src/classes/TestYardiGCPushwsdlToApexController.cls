@isTest
public class TestYardiGCPushwsdlToApexController {
    static testMethod void testYardiGCPushwsdlToApex() {
        String UserName = 'anyonehome-ws';
        String Password = '56559';
        String ServerName = 'sdb17\\SQL2k8_R2';
        String Database = 'afqoml_70dev';
        String Platform = 'SQL Server';
        String InterfaceEntity = 'Anyone Home';
        String InterfaceLicense = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
        String YardiPropertyId = 'anyhome1';
        String FirstName = 'Test6';
        String LastName = 'Test6';
        String EmailAddress = '';
        String PhoneNumber = '';
        String ThirdPartyId = '00593290';
        String DateOfBirth = '';
        String FederalId = '';
        
        YardiGCPushwsdlToApexController.ItfILSGuestCardSoap yvn = new YardiGCPushwsdlToApexController.ItfILSGuestCardSoap();
        
        Test.startTest();
        
      	Test.setMock(HttpCalloutMock.class, new TestCOGCPropertyConfigurations());
    	String strGetPropertyConfigurations  					= yvn.GetPropertyConfigurations( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense);
        Test.setMock(HttpCalloutMock.class, new TestCOGCYardiAgentsSourcesResults());
        String strGetYardiAgentsSourcesResults_Login 			= yvn.GetYardiAgentsSourcesResults_Login( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense );
    	Test.setMock(HttpCalloutMock.class, new TestCOGCYardiGuestActivity_Search());
        String strGetYardiGuestActivity_Search 					= yvn.GetYardiGuestActivity_Search( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense, FirstName, LastName, EmailAddress, PhoneNumber, ThirdPartyId, DateOfBirth, FederalId );
    	Test.setMock(HttpCalloutMock.class, new TestCOGCImportYardiGuest());
        YardiGCPushWsdltoApexController.XmlDoc_element XmlDoc 	= new YardiGCPushWsdltoApexController.XmlDoc_element();
        XmlDoc.anyElement										= '<LeadManagement xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Prospects><Prospect><Customers><Customer Type="prospect"><Identification IDValue="00593291" IDType="ThirdPartyID" OrganizationName="AnyoneHome" /><Identification IDValue="anyhome1" IDType="PropertyID" OrganizationName="AnyoneHome" /><Name><FirstName>Test6</FirstName><LastName>Test6</LastName></Name><Address AddressType="current"><AddressLine1>2906 Halibut Point Rd</AddressLine1><AddressLine2>NA</AddressLine2><City>Sitka</City><State>AL</State><PostalCode>99835</PostalCode></Address><Phone PhoneType="home"><PhoneNumber /></Phone><Phone PhoneType="cell"><PhoneNumber>(992) 222-9922</PhoneNumber></Phone><Email>nano.nano@af.com</Email><Lease><ExpectedMoveInDate>2014-12-02</ExpectedMoveInDate></Lease></Customer></Customers><CustomerPreferences><TargetMoveInDate>2014-12-02</TargetMoveInDate><DesiredUnit><MarketingName /></DesiredUnit><DesiredRent /><DesiredNumBedrooms Exact="0" /><DesiredLeaseTerms></DesiredLeaseTerms><Comment /></CustomerPreferences><Events><Event EventDate="2014-12-02T13:08:04" EventType="Email"><EventID IDValue="0" /><Agent><AgentName><FirstName>AnyoneHome</FirstName><LastName>AnyoneHome</LastName></AgentName></Agent><EventReasons>Still Looking</EventReasons><FirstContact>false</FirstContact><Comments></Comments><TransactionSource>Drive By</TransactionSource></Event></Events></Prospect></Prospects></LeadManagement>';
        String strImportYardiGuest_Login_element 				= yvn.ImportYardiGuest_Login( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense, XmlDoc );
        
        Test.stopTest();  
            	
    }
}