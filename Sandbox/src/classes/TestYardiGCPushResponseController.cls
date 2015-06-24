@isTest
public class TestYardiGCPushResponseController {

	static testMethod void testyardigcpushresponse() {

        Account a = new Account();
        a.Name	= 'Test';
        insert a;
        
        Integration__c i = new Integration__c();	
        i.Account__c = a.Id;
        i.Yardi_SR_ID__c = 'anyonehome-svrq';
        i.Yardi_SR_Password__c = '58849';
        i.Yardi_SR_Server_Name__c = 'sdb17\\SQL2k8_R2';
        i.Yardi_SR_Database_Name__c = 'afqoml_70dev';
        i.Yardi_SR_Platform_Type__c = 'SQL Server';
        i.Yardi_SR_Version_Number__c = 'Anyone Home-SR';
        insert i;
        
        String InterfaceLicence = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
       // String endpoint_x = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfilsguestcard.asmx'; //Dev
        YardiGC20PushWsdltoApexController.XmlDocument_element requestXML = new YardiGC20PushWsdltoApexController.XmlDocument_element();
        String strxml = '<LeadManagement> <Prospects> <Prospect> <TransactionData> <Identification IDType="prospect" IDScopeType="sender" IDRank="other"> <IDValue>00593228</IDValue> <OrganizationName>Anyone Home</OrganizationName> </Identification> <OriginatingLeadSource>Internet</OriginatingLeadSource> <OriginatingLeadChannel>Other</OriginatingLeadChannel> </TransactionData> <Customers> <MITS:Customer xmlns:MITS="http://my-company.com/namespace" Type="prospect"> <MITS:CustomerID /> <MITS:Property> <MITS:PrimaryID>anyhome1</MITS:PrimaryID> <MITS:MarketingName /> </MITS:Property> <MITS:Name> <MITS:FirstName>Vishal</MITS:FirstName> <MITS:LastName>Seth</MITS:LastName> </MITS:Name> <MITS:Address Type="property"> <MITS:Address1>PropForGuestCardNano</MITS:Address1> <MITS:Address2>NA</MITS:Address2> <MITS:City>Sitka</MITS:City> <MITS:State>AL</MITS:State> <MITS:PostalCode>99835</MITS:PostalCode> <MITS:Email /> </MITS:Address> <MITS:Phone Type="home"> <MITS:PhoneNumber>98989898</MITS:PhoneNumber> </MITS:Phone> </MITS:Customer> </Customers> <CustomerPreferences> <TargetMoveInDate>2014-11-29</TargetMoveInDate> <DesiredFloorplan /> <DesiredNumBedrooms Exact="0" /> <Comment /> </CustomerPreferences> <Events> <Event EventDate="2014-11-27T12:53:25" EventType="CallFromProspect"> <Agent> <AgentName> <FirstName>Anyone Home</FirstName> <LastName>Anyone Home</LastName> </AgentName> </Agent> <FirstContact>true</FirstContact> <Comments>First contact</Comments> <Messages xmlns=""><Message messageType="Error">ssss</Message></Messages></Event> </Events> </Prospect> </Prospects> </LeadManagement>';
        requestXML.anyElement = strxml;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCOMYardiGCPushResponse());
        YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn20 = new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap() ;
        String responseXml = yvn20.ImportYardiGuest_Login(i.Yardi_SR_ID__c,i.Yardi_SR_Password__c,i.Yardi_SR_Server_Name__c,i.Yardi_SR_Database_Name__c,i.Yardi_SR_Platform_Type__c,i.Yardi_SR_Version_Number__c, InterfaceLicence, requestXML);
        YardiGCPushResponseController g = new YardiGCPushResponseController(); 
        YardiGCPushResponseController.GuestCard GuestCard = g.parseGuestCards(new XmlStreamReader(responseXml));
        Test.stopTest();
    }
}