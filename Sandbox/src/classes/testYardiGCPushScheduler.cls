@istest
class testYardiGCPushScheduler {

   static testmethod void test() {
   		
       Test.startTest();
	    /*String UserName = 'anyonehome-ws';
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
       
       
       	List<String> strCredentials = new List<String>();
       	strCredentials.add(UserName);
       	strCredentials.add(Password);
       	strCredentials.add(ServerName);
       	strCredentials.add(Database);
       	strCredentials.add(Platform);
       	strCredentials.add(InterfaceEntity);
       	strCredentials.add(InterfaceLicense);   
      
        Test.startTest();
        
       	YardiGCPushwsdlToApexController.ItfILSGuestCardSoap yvn = new YardiGCPushwsdlToApexController.ItfILSGuestCardSoap();      
       	YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn2 = new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
        
        YardiGCPushController controller = new YardiGCPushController();
       
        controller.yvn = yvn;
        controller.yvn20 = yvn2;
              	
       	Test.setMock(HttpCalloutMock.class, new TestCOGCPropertyConfigurations());
    	String strGetPropertyConfigurations	= yvn.GetPropertyConfigurations( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense);
        
      // controller.GetPropertyConfigurations( strCredentials, '4' );
       	
       	Test.setMock(HttpCalloutMock.class, new TestCOGCPropertyConfigurations());
    	String strGetPropertyConfigurations2  					= yvn2.GetPropertyConfigurations( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense);
        
       //	controller.GetPropertyConfigurations( strCredentials, '2' );
       
       //	controller.findAppointment('abc');
       
       	Test.setMock(HttpCalloutMock.class, new TestCOGCYardiGuestActivity_Search());
        String strGetYardiGuestActivity_Search 					= yvn.GetYardiGuestActivity_Search( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense, FirstName, LastName, EmailAddress, PhoneNumber, ThirdPartyId, DateOfBirth, FederalId );
    	
       //	controller.GetYardiGuestActivity_Search( strCredentials, YardiPropertyId, ThirdPartyId, EmailAddress, PhoneNumber );
       	
       	Test.setMock(HttpCalloutMock.class, new TestCOGCYardiGuestActivity_Search(2));
        String strGetYardiGuestActivity_Search2 					= yvn2.GetYardiGuestActivity_Search( UserName, Password, ServerName, Database, Platform, YardiPropertyId, InterfaceEntity, InterfaceLicense, FirstName, LastName, EmailAddress, PhoneNumber, ThirdPartyId );
    	       
       //	controller.GetYardiGuestActivity_Search20( strCredentials, YardiPropertyId, ThirdPartyId, EmailAddress, PhoneNumber );
       //	controller.GetYardiGuestActivity_Search20( strCredentials, YardiPropertyId, ThirdPartyId, 'Test@gmail.com', '123456' );
       
       
       	Account a = new Account();
       	a.Name = 'Test Account';
       	insert a;
           
       	Grouping__c g = new Grouping__c();
       	g.Account__c = a.Id;
       	g.Name = 'Group Name';
       	insert g;
       
       	/*Contact c = new Contact();
        c.AccountId = a.Id;
        c.FirstName = 'Test';
        c.LastName = 'Demo';
       	insert c;
       
        Case ca = new Case();
        ca.AccountId = a.Id;
        ca.ContactId = c.Id;
        insert ca;
       
       	controller.getCase(a.Name, null);
       	
       	controller.getCase(a.Name, g.Name);
       
       // controller.findAppointment('Test appointment');
       
      /* 	String jobId = System.schedule('testYardiSRScheduler','0 1 * * * ? ',new YardiGCPushScheduler(5));
       	YardiGCPushScheduler.scheduleMe(); */
       
       	Test.stopTest();  
   }
}