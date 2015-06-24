@isTest 
public class TestPropertyQueue {

   
    static testMethod void TestPropertyQueue()
    {
        Test.startTest();
       	Account a = new Account();
        a.name = 'Test Account';
        insert a;
        
        Grouping__c g = NEW Grouping__c();
        g.Account__c = a.Id;
        g.Name = 'Tst Group';
        insert g;
        
        Property__c p = new Property__c();
        p.Account__c = a.Id;
        p.Do_Not_Show__c = true;
        p.Active__c = 'New Property Queue';
        P.Group_Membership__c = g.Id;
        insert p;
        
        Contact c = new Contact();
        c.FirstName = 'Surgaya';
        c.LastName = 'Khundrakpam'; 
        c.Email = 'surgaya.khundrakpam@anyonehome.com';
        c.Anyone_Home_Type__c = 'Agent';
        c.AccountId = a.Id;
        insert c;
        
        Contact c1 = new Contact();
        c1.FirstName = 'Surgaya';
        c1.LastName = 'Khundrakpam'; 
        c1.Email = 'surgaya.khundrakpam@anyonehome.com';
        c1.Anyone_Home_Type__c = 'Agent';
        c1.AccountId = a.Id;
        insert c1;
        
        Contact c2 = new Contact();
        c2.FirstName = 'Chris';
        c2.LastName = 'Gilbert'; 
        c2.Email = 'cg@anyonehome.com';
        c2.Anyone_Home_Type__c = 'Agent';
        c2.AccountId = a.Id;
        insert c2;
        
        Contact c3 = new Contact();
        c3.FirstName = 'Robert';
        c3.LastName = 'Brown'; 
        c3.Email = 'rb@anyonehome.com';
        c3.Anyone_Home_Type__c = 'Agent';
        c3.AccountId = a.Id;
        insert c3;
         
        
        Property_Agent__c pa = new Property_Agent__c();
        pa.Contact__c = c.Id; 
        pa.Roles__c = '';
        pa.Property__c = p.Id; 
        insert pa;
        
        Property_Agent__c pa1 = new Property_Agent__c();
        pa1.Contact__c = c1.Id; 
        pa1.Roles__c = 'Primary Agent';
        pa1.Property__c = p.Id; 
        insert pa1;
        
        Property_Agent__c pa2 = new Property_Agent__c();
        pa2.Contact__c = c.Id; 
        pa2.Roles__c = 'Secondary Agent';
        pa2.Property__c = p.Id; 
        insert pa2; 
        
        Map<String, String> prop_info = new Map<String, String>{'property_id' => p.Id, 'first_agent' => c.Id, 'group_id' => g.Id, 'show_property' => 'true'};
 		Map<String, String> pa_names = new Map<String, String>{'id' => c1.Id, 'role' => '1', 'property_id' => p.Id, 'group_id' => g.Id}; 
                
        PropertyQueueController controller = new PropertyQueueController();
        controller.myMethod(); 
        
        ApexPages.CurrentPage().getparameters().put('pid', p.id);        
        ApexPages.StandardController sc = new ApexPages.StandardController( p );
        PropertyQueueController controller1 = new PropertyQueueController(sc);
        
        PropertyQueueController.getNewActivePropertiesForAccount(a.Id);
        PropertyQueueController.getAllGropings(a.Id); 
        PropertyQueueController.getAllAgents(a.Id);
        PropertyQueueController.updateProperties(a.Id, JSON.serialize(prop_info), JSON.serialize(pa_names));      
         
        Test.stopTest();

    } 
}