@isTest
public class TestYardiGCPullAgentsController {

    static testMethod void testyardigcpullcontroller() {

        Account a = new Account();
        a.Name	= 'Test';
        insert a;

        Integration__c i 			= new Integration__c();	
        i.Yardi_ID__c 				= 'anyonehome-svrq';
        i.Yardi_Password__c 		= '58849';
        i.Yardi_Server_Name__c 		= 'sdb17\\SQL2k8_R2';
        i.Yardi_Database_Name__c 	= 'afqoml_70dev';
        i.Yardi_Platform_Type__c 	= 'SQL Server';
        i.Yardi_Version_Number__c 	= '2';
        i.Account__c 				= a.Id;
        i.Yardi_Integration_Active__c = true;
        i.Push_Guest_Cards_to_Yardi__c = true;
        i.Get_Yardi_Agent_Info__c = 'Daily';
        insert i;

        Integration__c i1 			= new Integration__c();	
        i1.Yardi_ID__c 				= 'anyonehome-svrq';
        i1.Yardi_Password__c 		= '58849';
        i1.Yardi_Server_Name__c 		= 'sdb17\\SQL2k8_R2';
        i1.Yardi_Database_Name__c 	= 'afqoml_70dev';
        i1.Yardi_Platform_Type__c 	= 'SQL Server';
        i1.Yardi_Version_Number__c 	= '4';
        i1.Account__c 				= a.Id;
        i1.Yardi_Integration_Active__c = true;
        i1.Push_Guest_Cards_to_Yardi__c = true;
        insert i1;

        Property__c p 			= new Property__c();
        p.Account__c 			= a.Id;
        p.Customer_Prop_ID__c 	= 'anyonehome1';
        insert p;

        Contact c = new Contact();
        c.FirstName = 'Nil';
        c.LastName = 'Mukesh';
        c.AccountId = a.Id;
        insert c;

        Contact c1 = new Contact();
        c1.FirstName = 'Joe';
        c1.LastName = 'Black';
        c1.AccountId = a.Id;
        insert c1;

        String InterfaceEntity 												= 'Anyone Home';
        String InterfaceLicence 											= 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
        YardiGC20PushWsdltoApexController.XmlDocument_element requestXML 	= new YardiGC20PushWsdltoApexController.XmlDocument_element();
        String strxml 														= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:itf="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard"> <soapenv:Header/> <soapenv:Body> <itf:GetYardiAgentsSourcesResults_Login>  <itf:UserName>anyonehome-ws</itf:UserName>  <itf:Password>56559</itf:Password>  <itf:ServerName>sdb17\\SQL2k8_R2</itf:ServerName>  <itf:Database>afqoml_70dev</itf:Database>  <itf:Platform>SQL Server</itf:Platform>  <itf:YardiPropertyId>anyhome1</itf:YardiPropertyId>  <itf:InterfaceEntity>Anyone Home</itf:InterfaceEntity>  <itf:InterfaceLicense>MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b</itf:InterfaceLicense> </itf:GetYardiAgentsSourcesResults_Login> </soapenv:Body> </soapenv:Envelope>';
        YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn20 		= new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
        requestXML.anyElement 												= strxml;
        Map<String, List<Contact>> AllContacts 								= new Map<String, List<Contact>>();

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpYardiGCPullAgentsResponse());
        YardiGCPullAgentsController agentController 					= new YardiGCPullAgentsController();
        agentController.GetYardiAgentsSourcesResults_Login_responseXML 	= '<GetYardiAgentsSourcesResults_LoginResult> <Properties xmlns=""> <Property> <PropertyCode>anyhome1</PropertyCode> <PropertyRequiredFields> <Agents> <AgentName>Joe Black</AgentName> <AgentName>Tom Jones</AgentName> <AgentName InactiveDate="2012-03-30">John Smith</AgentName> <AgentName>Joseph Smith</AgentName> <AgentName>Richard Green</AgentName> <AgentName>AnyoneHome AnyoneHome</AgentName> <AgentName>Anyone Home Anyone Home</AgentName> </Agents> <Sources> <SourceName>Drive by</SourceName> <SourceName>Internet</SourceName> <SourceName>Referral</SourceName> <SourceName>Newspaper</SourceName> </Sources> <Results> <Result>Still Looking</Result> <Result>Too Expensive</Result> <Result>Pets</Result> <Result>Pricing</Result> <Result>Location</Result> <Result>Follow Up</Result> <Result>Cancel Reason</Result> <Result>Credit History</Result> <Result>Size</Result> </Results> </PropertyRequiredFields> </Property> </Properties> </GetYardiAgentsSourcesResults_LoginResult>';
        agentController.strPropertiesXml								= '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <GetPropertyConfigurationsResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20"> <GetPropertyConfigurationsResult> <Properties xmlns=""> <Property> <Code>7376</Code> <MarketingName>Ponderosa Villas</MarketingName> <AddressLine1>1539 S. Galena Way</AddressLine1> <AddressLine2/> <AddressLine3/> <City>Denver</City> <State>CO</State> <PostalCode>80247</PostalCode> </Property> </Properties> </GetPropertyConfigurationsResult> </GetPropertyConfigurationsResponse> </soap:Body> </soap:Envelope>';
        AllContacts = agentController.PullYardiAgentsSourcesResults(true);
        
        YardiGCPullAgentsScheduler Pushscheduler = new YardiGCPullAgentsScheduler( 5 );
        System.schedule( 'YardiGCPullAgentsScheduler', '0 0 * * * ?', new YardiGCPullAgentsScheduler( 3, false ) );
        
        YardiGCPullAgentsBatch ObjBatch = new YardiGCPullAgentsBatch( false );
        ObjBatch = new YardiGCPullAgentsBatch( false );
        Test.stopTest();
    }
}