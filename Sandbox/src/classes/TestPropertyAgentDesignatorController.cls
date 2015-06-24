@isTest
public class TestPropertyAgentDesignatorController {
    static testMethod void TestPropertyAgentDesignatorController()
    {
        Test.startTest();
       	Account a = new Account();
        a.name = 'Test Account';
        insert a;
        
        Grouping__c g = new  Grouping__c();
        g.Name = 'New group';
        g.Account__c = a.Id;
        insert g;
        
        Property__c p = new Property__c();
        p.Account__c = a.Id;
        p.Group_Membership__c = g.Id;
        insert p;
        
        Contact c = new Contact();
         c.FirstName = 'Surgaya';
         c.LastName = 'Khundrakpam'; 
         c.Email = 'surgaya.khundrakpam@anyonehome.com';
         c.AccountId = a.Id;
         c.Anyone_Home_Type__c = 'Agent';
         insert c;
        
         Contact c1 = new Contact();
         c1.FirstName = 'Surgaya';
         c1.LastName = 'Khundrakpam'; 
         c1.Email = 'surgaya.khundrakpam@anyonehome.com';
         c1.AccountId = a.Id;
         c1.Anyone_Home_Type__c = 'Agent';
         insert c1;
        
         Contact c2 = new Contact();
         c2.FirstName = 'Chris';
         c2.LastName = 'Gilbert'; 
         c2.Email = 'cg@anyonehome.com';
         c2.AccountId = a.Id;
         c2.Anyone_Home_Type__c = 'Agent';
         insert c2;
        
         Contact c3 = new Contact();
         c3.FirstName = 'Robert';
         c3.LastName = 'Brown'; 
         c3.Email = 'rb@anyonehome.com';
         c3.AccountId = a.Id;
         c3.Anyone_Home_Type__c = 'Agent';
         insert c3;
          
        
        Property_Agent__c pa = new Property_Agent__c();
        pa.Contact__c = c.Id; 
        pa.Roles__c = 'Primary Agent';
        pa.Property__c = p.Id; 
        insert pa;
        
        Property_Agent__c pa1 = new Property_Agent__c();
        pa1.Contact__c = c1.Id; 
        pa1.Roles__c = 'Secondary Agent';
        pa1.Property__c = p.Id; 
        insert pa1;
        
        Property_Agent__c pa2 = new Property_Agent__c();
        pa2.Contact__c = c.Id; 
        pa2.Roles__c = 'Primary Agent';
        pa2.Property__c = p.Id; 
        insert pa2;
        
        Property_Agent__c pa3 = new Property_Agent__c();
        pa3.Contact__c = c.Id; 
        pa3.Roles__c = '';
        pa3.Property__c = p.Id; 
        insert pa3; 
        
        
       /* Array<List> item = {}; 
            item['property_id'] = $(this).data('propertyid'); 
        item['first_agent'] = $(this).find('.prop_agent_first').val();
        item['second_agent'] = $(this).find('.prop_agent_second').val();
        item['third_agent']  = $(this).find('.prop_agent_third').val();
        item['fourth_agent'] = $(this).find('.prop_agent_fourth').val(); 
        propertyAgents.push(item); 
       */
        
       
   //  public String JSONString;
   // public example(){
       
          
         
        Map<String, String> pa_names = new Map<String, String>{'property_id' => p.Id, 'first_agent' => c.Id, 'second_agent' => c1.Id, 'third_agent' => c2.Id };
        List<String> prop_Ids = new List<String>(); 
        prop_Ids.add(p.Id);
  
       // pa_names.add(new innerclass(2));
      //  pa_names.add(new innerclass(3));   
   //     JSONString = JSON.serialize(pa_names);   
        System.debug(JSON.serialize(pa_names)); 
        PropertyAgentDesignatorController controller = new PropertyAgentDesignatorController(); 
        
       // ApexPages.CurrentPage().getparameters().put('pid', p.id);        
       // ApexPages.StandardController sc = new ApexPages.StandardController( a );
         
       
        
        PropertyAgentDesignatorController.getAllPropertyNamesForAccount(a.Id);
        PropertyAgentDesignatorController.getAllGroupings(a.Id); 
        List<Contact> ListContacts = PropertyAgentDesignatorController.getAllContactAgents(a.Id);
        List<String> contact_ids =new List<String>();
        for(Contact con : ListContacts){
            contact_ids.add(con.Id);
        }
        PropertyAgentDesignatorController.getAllAgents(a.Id, contact_ids);
        PropertyAgentDesignatorController.getAllActivePropertiesForAccount(a.Id, 10, 0); 
        PropertyAgentDesignatorController.getAssignedPropertyAgents(a.Id, prop_Ids );  
        PropertyAgentDesignatorController.updatePropertyAgents(a.Id, JSON.serialize(pa_names));         
         Test.stopTest();

    }

}