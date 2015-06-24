@isTest
public class TestYardiGCAgentsResponseController {

    static testMethod void testyardigcpullcontroller() {

        Account a = new Account();
        a.Name	= 'Test';
        insert a;
        
        Integration__c i = new Integration__c();	
        i.Account__c = a.Id;
        i.Yardi_ID__c = 'anyonehome-svrq';
        i.Yardi_Password__c = '58849';
        i.Yardi_Server_Name__c = 'sdb17\\SQL2k8_R2';
        i.Yardi_Database_Name__c = 'afqoml_70dev';
        i.Yardi_Platform_Type__c = 'SQL Server';
        i.Yardi_Version_Number__c = 'Anyone Home-SR';
        insert i;
        
        Property__c p 			= new Property__c();
        p.Account__c 			= a.Id;
        p.Customer_Prop_ID__c 	= 'anyonehome1';
        insert p;
        
        Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;
        
        String InterfaceEntity 												= 'Anyone Home';
        String InterfaceLicence 											= 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
        YardiGC20PushWsdltoApexController.XmlDocument_element requestXML 	= new YardiGC20PushWsdltoApexController.XmlDocument_element();
        String strxml 														= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:itf="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard"> <soapenv:Header/> <soapenv:Body> <itf:GetYardiAgentsSourcesResults_Login>  <itf:UserName>anyonehome-ws</itf:UserName>  <itf:Password>56559</itf:Password>  <itf:ServerName>sdb17\\SQL2k8_R2</itf:ServerName>  <itf:Database>afqoml_70dev</itf:Database>  <itf:Platform>SQL Server</itf:Platform>  <itf:YardiPropertyId>anyhome1</itf:YardiPropertyId>  <itf:InterfaceEntity>Anyone Home</itf:InterfaceEntity>  <itf:InterfaceLicense>MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b</itf:InterfaceLicense> </itf:GetYardiAgentsSourcesResults_Login> </soapenv:Body> </soapenv:Envelope>';
        YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn20 		= new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
        requestXML.anyElement 												= strxml;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpYardiGCPullAgentsResponse());
        String responseXml = yvn20.GetYardiAgentsSourcesResults_Login( i.Yardi_ID__c, i.Yardi_Password__c , i.Yardi_Server_Name__c,i.Yardi_Database_Name__c, i.Yardi_Platform_Type__c, p.Customer_Prop_ID__c , InterfaceEntity, InterfaceLicence );
        YardiGCAgentsSourcesResponseController agentController = new YardiGCAgentsSourcesResponseController(); 
        Map<String, Map<String, Set<String>>> AgentNames = agentController.ParseAgentSourcesXML(new XmlStreamReader(responseXml));
        Test.stopTest();
    }
}