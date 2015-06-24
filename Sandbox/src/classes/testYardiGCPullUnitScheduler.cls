@istest
class testYardiGCPullUnitScheduler {
    static testmethod void test() {
   
        String UserName = 'anyonehome-ws';
        String Password = '56559';
        String ServerName = 'sdb17\\SQL2k8_R2';
        String strDatabase = 'afqoml_70dev';
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
        strCredentials.add(strDatabase);
        strCredentials.add(Platform);
        strCredentials.add(InterfaceEntity);
        strCredentials.add(InterfaceLicense);   
      
        Test.startTest();
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Grouping__c gr = new Grouping__c();
        gr.Account__c  = a.Id;
        insert gr;
        
        Integration__c i1 = new Integration__c(); 
        i1.Yardi_ID__c = 'anyonehome-ws';
        i1.Yardi_Password__c = '56559';
        i1.Yardi_Server_Name__c = 'sdb17\\SQL2k8_R2';
        i1.Yardi_Database_Name__c = 'afqoml_70dev';
        i1.Yardi_Platform_Type__c = 'SQL Server';
        i1.Yardi_API_URL__c = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfilsguestcard.asmx';
        i1.Yardi_Version_Number__c = '4';
        i1.Yardi_Integration_Active__c = true;
        i1.Push_Guest_Cards_to_Yardi__c = true;
        i1.Account__c = a.Id;
        i1.Yardi_Availability_Pricing__c = 'Daily';
        i1.Last_Yardi_Pull__c = null;
        i1.Grouping__c = gr.Id;
        insert i1;
        
        Integration__c i2 = new Integration__c(); 
        i2.Yardi_ID__c = 'anyonehome-ws';
        i2.Yardi_Password__c = '56559';
        i2.Yardi_Server_Name__c = 'sdb17\\SQL2k8_R2';
        i2.Yardi_Database_Name__c = 'afqoml_70dev';
        i2.Yardi_Platform_Type__c = 'SQL Server';
        i2.Yardi_API_URL__c = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfilsguestcard20.asmx';
        i2.Yardi_Version_Number__c = '2';
        i2.Yardi_Integration_Active__c = true;
        i2.Push_Guest_Cards_to_Yardi__c = true;
        i2.Account__c = a.Id;
        i2.Yardi_Availability_Pricing__c = 'Daily';
        i2.Last_Yardi_Pull__c = null;
        insert i2;
        
        Property__c p1 = new Property__c();
        p1.Name = 'New Property';
        p1.Account__c = a.Id;
        p1.Customer_Prop_ID__c = 'anyhom5';
        p1.Address_Line_1__c = 'AAAAAAAAA';
        p1.City__c = 'Pune';
        p1.State__c = ' MH';
        p1.Zip_Code__c = '411013';
        p1.Group_Membership__c = gr.Id;
        insert p1;
        
        Floor_Plan__c f1 = new Floor_Plan__c();
        f1.Account__c = a.Id;
        f1.Property__c = p1.Id;
        f1.Floorplan_ID__c = 'anyhom5';
        insert f1;
        
        Unit__c u1 = new Unit__c();
        u1.Account__c = a.Id;
        u1.Property__c = p1.Id;
        u1.Floor_Plan__c = f1.Id;
        u1.Unit_ID__c = 'ANYHOM5';      
        insert u1;
        
        YardiGCPullUnitScheduler objScheduler = new YardiGCPullUnitScheduler(5);
        objScheduler = new YardiGCPullUnitScheduler();
        
        YardiGCPullUnitBatch UnitBatch = new YardiGCPullUnitBatch();
        Database.executeBatch( UnitBatch, 20 );
        
        System.schedule('YardiGCPullUnitScheduler1','0 1 * * * ? ',new YardiGCPullUnitScheduler( 5));
        
        
        Test.stopTest();  
   }
}