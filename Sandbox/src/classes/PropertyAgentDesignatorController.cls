public class PropertyAgentDesignatorController {
   public  PropertyAgentDesignatorController() {  

    }
    
    public  PropertyAgentDesignatorController(ApexPages.StandardController stc) {

    }   
    
    @RemoteAction 
     public static List<Property__c> getAllPropertyNamesForAccount( String accountId ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
        System.debug('Finding Property Names');
         List<Property__c> properties = [ SELECT 
                                         Id, Active__c, Name, Group_Membership__c, Zip_Code__c,City__c 
                                         FROM Property__c 
                                         WHERE Account__c =: accountId 
                                         ORDER BY Name ASC  ];
         
         return properties;  
    }
    @RemoteAction 
	public static List<Property__c> getAllActivePropertiesForAccount( String accountId, Integer total_count, Integer offset_start ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
        
        List<Property__c> properties = new List<Property__c>();
        List<Property__c> newProperties = new List<Property__c>(); 
         
        if(offset_start < 2000 ){ 
      		properties = [ SELECT 
                                        Active__c, Id, Name, Group_Membership__c, Zip_Code__c,City__c 
                                        FROM Property__c 
                                        WHERE Account__c =: accountId 
                                        ORDER BY Name ASC 
                                        LIMIT :total_count OFFSET :offset_start];
             
             return properties;
      
        } else { 
            properties = [ SELECT 
                          Id, Active__c, Name, Group_Membership__c, Zip_Code__c,City__c 
                          FROM Property__c 
                          WHERE Account__c =: accountId 
                          ORDER BY Name ASC ];
            Integer prop_count = properties.size();
            if(properties.size() > 0){  
                total_count = total_count + offset_start;
                for(Integer i = offset_start; i < total_count; i++){  
                    if( i >= prop_count   ) {
                        break;
                    }
                    
                    Property__c newSubProperty = new Property__c();
                    
                    newSubProperty.Id = properties[i].Id;
                    newSubProperty.Active__c =  properties[i].Active__c; 
                    newSubProperty.Name =  properties[i].Name; 
                    newSubProperty.Group_Membership__c  =  properties[i].Group_Membership__c; 
                    newSubProperty.Zip_Code__c =  properties[i].Zip_Code__c; 
                    newSubProperty.City__c =  properties[i].City__c;  
                    
                    newProperties.add(newSubProperty);  
                }
            } 
            return newProperties;    
        } 
    } 
    
    @RemoteAction 
   public static List<Grouping__c> getAllGroupings( String accountId) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        }  
        
       List<Grouping__c> groupings = [ SELECT Id, Name FROM Grouping__c WHERE Account__c =: accountId ORDER BY Name ASC];   
       return groupings;   
    } 
    
    
    @RemoteAction
    public static  List<Contact> getAllContactAgents( String accountId ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
        
        List<Contact> contactsAgents = [ SELECT Id,Name 
                                        FROM Contact 
                                        WHERE Anyone_Home_Type__c = 'Agent' 
                                        AND AccountId =: accountId 
                                        ORDER BY Name ASC
                                       ];
        return contactsAgents;
    }    
    
    @RemoteAction
    public static  List<Property_Agent__c> getAllAgents( String accountId, List<String> allagentContactIds ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
       
        List<Property_Agent__c> pa = [ SELECT Property__c, Property__r.Group_Membership__c, Zip_Code__c, Contact__c, Contact__r.Name FROM  Property_Agent__c WHERE Contact__c IN :allagentContactIds ORDER BY Contact__c ASC]; 
        return pa;
         
    }
    @RemoteAction
    public static  List<Property_Agent__c> getAssignedPropertyAgents( String accountId,  List<String> property_ids ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        }  
       
        List<Property_Agent__c> pa = new List<Property_Agent__c>();
        if(property_ids.size() > 0){ 
            pa = [ SELECT Contact__c, Contact__r.Name, Contact__r.Anyone_Home_Type__c, Id, Property__c, Property__r.Name, Name, Roles__c, Property__r.Group_Membership__r.Name, Property__r.Zip_Clean__c , Property_ID__c, Zip_Code__c 
                  FROM  Property_Agent__c
                  WHERE Contact__r.Anyone_Home_Type__c = 'Agent' AND Property__r.Id IN :property_ids ORDER BY Property__r.Name ASC
                 ];
        }
         
      return pa;        
    }
       
    @RemoteAction 
   public static void updatePropertyAgents( String accountId, String propertyAgentJson ) { 
        JSONParser parser =  JSON.createParser( propertyAgentJson );
        List<PropertyAgentNames> propertyAgentsList = new List<PropertyAgentNames>(); 
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        PropertyAgentNames pa = (PropertyAgentNames)parser.readValueAs(PropertyAgentNames.class);
                        propertyAgentsList.add(pa); 
                    }
                }
            } 
        } 
         String sql  = '';
         List<Property_Agent__c> agents = new List<Property_Agent__c>();
         
        List<String> prop_ids = new List<String> ();
        for ( PropertyAgentNames pa:  propertyAgentsList ) {  
            prop_ids.add( pa.property_id );
        } 
       List<Property_Agent__c> prop_agent_records = [
                   SELECT Id, Property_ID__c 
                   FROM  Property_Agent__c
                   WHERE Property_ID__c IN: prop_ids 
               ]; 
        
        if( prop_agent_records.size() > 0 ) {
            for( Property_Agent__c prop_agent_lst : prop_agent_records ) {
                //delete prop_agent_lst; 
                agents.add(prop_agent_lst);
            } 
            delete agents; 
        }
       	agents.clear();
        for ( PropertyAgentNames pa:  propertyAgentsList ) {    
           
            if('' !=  pa.first_agent){
                Property_Agent__c tmpAgent1 = new Property_Agent__c();
                tmpAgent1.Contact__c = pa.first_agent;
                tmpAgent1.Property__c = pa.property_id;
                tmpAgent1.Roles__c = null;  
                agents.add(tmpAgent1);
            }   
            if( '' !=  pa.second_agent ) { 
                Property_Agent__c tmpAgent2 = new Property_Agent__c();
                tmpAgent2.Contact__c = pa.second_agent;
                tmpAgent2.Property__c = pa.property_id;
                tmpAgent2.Roles__c = 'Primary Agent';  
                agents.add(tmpAgent2);
            }
            if( '' !=  pa.third_agent ) {
                
                Property_Agent__c tmpAgent3 = new Property_Agent__c();
                tmpAgent3.Contact__c = pa.third_agent;
                tmpAgent3.Property__c = pa.property_id;
                tmpAgent3.Roles__c = 'Secondary Agent';  
                agents.add(tmpAgent3);
            } 
        }
       if(agents.size() > 0){
 			insert agents;
       }
    } 
     
   public class Agents {
       public String Id;
       public String Name;
       public String properties;
       public String zips;
       public String groups; 
  } 
     public class PropertyAgentNames { 
         public String property_id; 
         public String first_agent; 
         public String second_agent; 
         public String third_agent; 
        // public String fourth_agent;
      
  } 
    
    public class PropertyAgent {
        public String Id;
        public String property_id;
        public Integer role;
        
    } 
     
    public class SubListProperty {  
        public String Active;
        public String Id;
        public String Name; 
        public String GroupMembership;
        public String ZiCode;
        public String City;  
    }
   
}