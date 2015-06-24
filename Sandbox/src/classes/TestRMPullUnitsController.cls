@istest
class TestRMPullUnitsController {
	static testmethod void testPullUnitsController() {
   		Test.startTest();
        
        Account a = new Account();
       	a.Name = 'Test Account';
       	insert a;
        
        Grouping__c Gr = new Grouping__c();
        Gr.Account__c = a.Id;
        insert Gr;
        
        Integration__c i 					= new Integration__c();	
        i.Account__c 						= a.Id;
        i.ResMan_API_URL__c 				= 'https://api.myresman.com/';
        i.ResMan_API_Key__c 				= 'a262bb82902b4e3491807044e0c6986e';
        i.ResMan_Integration_Partner_ID__c 	= '1076';
        i.ResMan_Account_Id__c				= '400';
        i.Get_ResMan_Unit_Availability__c	= 'Daily';
        i.ResMan_Integration_Active__c 		= true;
        i.New_LRO_Setting__c				= 'Price and Availability';
        i.Grouping__c						= Gr.Id;
        insert i;
        
        Grouping__c Gr2 = new Grouping__c();
        Gr2.Account__c = a.Id;
        insert Gr2;
        
       	Integration__c i1 					= new Integration__c();	
        i1.Account__c 						= a.Id;
        i1.ResMan_API_URL__c 				= 'https://api.myresman.com/';
        i1.ResMan_API_Key__c 				= 'a262bb82902b4e3491807044e0c6986e';
        i1.ResMan_Integration_Partner_ID__c = '1076';
        i1.ResMan_Account_Id__c				= '400';
        i1.Get_ResMan_Unit_Availability__c	= 'Daily';
        i1.ResMan_Integration_Active__c 	= true;
        i1.New_LRO_Setting__c				= null;
        i1.Grouping__c						= Gr2.Id;
        insert i1;
        
        Property__c p 			= new Property__c();
        p.Account__c 			= a.Id;
        p.ResMan_Property_Id__c = 'B342E58C-F5BA-4C63-B050-CF44439BB37D';
        p.Group_Membership__c = Gr.Id;
        insert p;
        
        Property__c p2 			= new Property__c();
        p2.Account__c 			= a.Id;
        p2.ResMan_Property_Id__c = 'B342E58C-F5BA-4C63-B050-CF44439BB37D';
        p2.Group_Membership__c = Gr2.Id;
        insert p2;

        Floor_Plan__c f1 = new Floor_Plan__c();
        f1.Account__c = a.Id;
        f1.Property__c = p.Id;
        f1.ResMan_Floor_Plan_ID__c = 'A2';
        insert f1;
        
        Floor_Plan__c f2 = new Floor_Plan__c();
        f2.Account__c = a.Id;
        f2.Property__c = p2.Id;
        f2.ResMan_Floor_Plan_ID__c = 'A2';
        insert f2;
		
		Unit__c u1 = new Unit__c();
		u1.Account__c = a.Id;
		u1.Property__c = p.Id;
		u1.Floor_Plan__c = f1.Id;
		u1.ResMan_Unit_ID__c = '13103';      
        insert u1;
        
        Unit__c u2 = new Unit__c();
		u2.Account__c = a.Id;
		u2.Property__c = p2.Id;
		u2.Floor_Plan__c = f2.Id;
		u2.ResMan_Unit_ID__c = '13103';      
        insert u2;
         
        
        RMPullUnitsScheduler scheduler = new RMPullUnitsScheduler( 3 );
        scheduler = new RMPullUnitsScheduler();
        
        System.schedule( 'RMPullUnitsScheduler', '0 0 * * * ?', new RMPullUnitsScheduler(3) );
        
        RMPullUnitsBatch UnitBatch = new RMPullUnitsBatch();
        UnitBatch = new RMPullUnitsBatch();
        Database.executeBatch( UnitBatch, 6 );
       
        Test.stopTest();  
   }
}