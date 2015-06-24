@isTest
public class TestYardiGC20PushWsdltoApexController {
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
        
        YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn = new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
        
        Test.startTest();
        
      	Test.setMock(HttpCalloutMock.class, new TestCOGCPropertyConfigurations());
    	String strGetPropertyConfigurations  					= yvn.GetPropertyConfigurations( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense);
        Test.setMock(HttpCalloutMock.class, new TestCOGCYardiAgentsSourcesResults());
        String strGetYardiAgentsSourcesResults_Login 			= yvn.GetYardiAgentsSourcesResults_Login( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense );
    	Test.setMock(HttpCalloutMock.class, new TestCOGCYardiGuestActivity_Search(2));
        String strGetYardiGuestActivity_Search 					= yvn.GetYardiGuestActivity_Search( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense, FirstName, LastName, EmailAddress, PhoneNumber, ThirdPartyId );
    	
        Test.setMock(HttpCalloutMock.class, new TestCOGCImportYardiGuest());
        YardiGC20PushWsdltoApexController.XmlDocument_element XmlDoc 	= new YardiGC20PushWsdltoApexController.XmlDocument_element();
        XmlDoc.anyElement										= '<LeadManagement> <Prospects> <Prospect> <TransactionData> <Identification IDType="prospect" IDScopeType="sender" IDRank="other"> <IDValue>00593228</IDValue> <OrganizationName>Anyone Home</OrganizationName> </Identification> <OriginatingLeadSource>Internet</OriginatingLeadSource> <OriginatingLeadChannel>Other</OriginatingLeadChannel> </TransactionData> <Customers> <MITS:Customer xmlns:MITS="http://my-company.com/namespace" Type="prospect"> <MITS:CustomerID /> <MITS:Property> <MITS:PrimaryID>anyhome1</MITS:PrimaryID> <MITS:MarketingName /> </MITS:Property> <MITS:Name> <MITS:FirstName>Vishal</MITS:FirstName> <MITS:LastName>Seth</MITS:LastName> </MITS:Name> <MITS:Address Type="property"> <MITS:Address1>PropForGuestCardNano</MITS:Address1> <MITS:Address2>NA</MITS:Address2> <MITS:City>Sitka</MITS:City> <MITS:State>AL</MITS:State> <MITS:PostalCode>99835</MITS:PostalCode> <MITS:Email /> </MITS:Address> <MITS:Phone Type="home"> <MITS:PhoneNumber>98989898</MITS:PhoneNumber> </MITS:Phone> </MITS:Customer> </Customers> <CustomerPreferences> <TargetMoveInDate>2014-11-29</TargetMoveInDate> <DesiredFloorplan /> <DesiredNumBedrooms Exact="0" /> <Comment /> </CustomerPreferences> <Events> <Event EventDate="2014-11-27T12:53:25" EventType="CallFromProspect"> <Agent> <AgentName> <FirstName>Anyone Home</FirstName> <LastName>Anyone Home</LastName> </AgentName> </Agent> <FirstContact>true</FirstContact> <Comments>First contact</Comments> </Event> </Events> </Prospect> </Prospects> </LeadManagement>';
        String strImportYardiGuest_Login_element 				= yvn.ImportYardiGuest_Login( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense, XmlDoc );
        
        Test.stopTest();  
            	
    }
}