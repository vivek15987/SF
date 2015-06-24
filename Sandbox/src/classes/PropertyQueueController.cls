public with sharing class PropertyQueueController {
    
    public  PropertyQueueController() {  

    } 
    public  PropertyQueueController(ApexPages.StandardController stc) {

    }  
    public PageReference myMethod(){       
        return null;
    } 
    
    @RemoteAction
    public static List<Property__c> getNewActivePropertiesForAccount( String accountId ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
         
        List<Property__c> properties = [ Select Id, Active__c, Name, Do_Not_Show__c, Group_Membership__c, Zip_Code__c from Property__c where  Account__c =: accountId ORDER BY Name asc];
        
        return properties;          
    }
    
    @RemoteAction
    public static List<Grouping__c> getAllGropings( String accountId ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
        
        List<Grouping__c> groupings = [ Select Id, Name from Grouping__c where Account__c =: accountId ORDER BY Name asc];
       
        return groupings;       
    }
    
    @RemoteAction
    public static  List<Agents> getAllAgents( String accountId ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        }  
        
        List<Contact> agents = [ SELECT Id,Name 
                                         FROM Contact 
                                         WHERE Anyone_Home_Type__c = 'Agent' 
                                         AND AccountId =: accountId
                                         ORDER BY Name asc
                                       ];
        List<Agents> lstAgent = new List<Agents>();
        for( Contact ca : agents ){
             List<Property_Agent__c> pa = [
                                             SELECT Roles__c,Property__r.Group_Membership__r.Name,Property__r.Zip_Clean__c, Property__r.Zip_Code__c
                                             FROM  Property_Agent__c
                                             WHERE Contact__c =: ca.Id
                                        ];
            Agents agent = new Agents();
            agent.Id = ca.Id;
            agent.Name = ca.Name;
            if( pa != null ) {
                agent.properties = pa;    
            } else
            {
                agent.properties = null;
            }
            
            lstAgent.add( agent );
             
        }  
        
        return lstAgent;        
    }
    
    @RemoteAction
    public static void updateProperties( String accountId,String propertyjson,String strjson ) { 
        JSONParser parser1 =  JSON.createParser( propertyjson );
        List<PropertyGroup> propertyGroups = new List<PropertyGroup>();
        while (parser1.nextToken() != null) {
            if (parser1.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser1.nextToken() != null) {
                    if (parser1.getCurrentToken() == JSONToken.START_OBJECT) {
                        PropertyGroup groups = (PropertyGroup)parser1.readValueAs(PropertyGroup.class);
                        propertyGroups.add(groups);
                    
                        parser1.skipChildren();
                    }
                }
            }
        }
            
        List<Property__c> properties = [ Select Id,Active__c,Name from Property__c where 
                                         Active__c IN ( 'New Property Queue','Newly Active Queue','Prep')
                                         AND Account__c =: accountId
                                        ];
        
        List<Property__c> props = new List<Property__c>();
        for(Property__c p: properties ) {
            for( PropertyGroup pg : propertyGroups ) {
                if( p.id == pg.property_id ) {
                    p.Active__c = 'Yes';
                    if( pg.group_id != null ) {
                        p.Group_Membership__c = pg.group_id;
                    }
                    p.Do_Not_Show__c  = pg.show_property;
                    props.add( p );
                }
            }      
        }   
       
         upsert props;
               
        JSONParser parser =  JSON.createParser( strjson );
        List<PropertyAgent> propertyAgents = new List<PropertyAgent>();
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        PropertyAgent pa = (PropertyAgent)parser.readValueAs(PropertyAgent.class);
                        propertyAgents.add(pa);
                        parser.skipChildren();
                    }
                }
            }
        }
        
        List<String> prop_ids = new List<String> ();
        for ( PropertyAgent pa:  propertyAgents ) {  
            prop_ids.add( pa.property_id );
        } 
        
        List<Property_Agent__c> prop_agent_records = [ SELECT Id, Property__c FROM  Property_Agent__c  WHERE Property_ID__c IN: prop_ids ORDER BY Property_ID__c ]; 
        
        if( prop_agent_records.size() > 0 ) { 
            for( Property_Agent__c prop_agent_lst : prop_agent_records ) {
                delete prop_agent_lst; 
            }
        }
        
        List<Property_Agent__c> agents = new List<Property_Agent__c>();
        for ( PropertyAgent pa:  propertyAgents ) {
            
            if( 0 != pa.role ) {
                Property_Agent__c tmpAgent = new Property_Agent__c();
                tmpAgent.Contact__c = pa.id;
                tmpAgent.Property__c = pa.property_id; 
                
                if( 1 ==  pa.role ) {
                    tmpAgent.Roles__c = null;
                } else if( 2 == pa.role ) {
                    tmpAgent.Roles__c = 'Primary Agent';
                } else if ( 3 == pa.role ) {
                     tmpAgent.Roles__c = 'Secondary Agent';
                } 
                agents.add( tmpAgent );
            }
            
        }
        
      insert agents;  
            
    }
    
    public class PropertyGroup {
        public String property_id;
        public String group_id; 
        public Boolean show_property;
        public PropertyGroup(String property_id, String group_id, Boolean show_property) {
           this.property_id = property_id; 
           this.group_id = group_id;
           this.show_property = show_property;
        }
    }
     
    public class PropertyAgent {
        public String id;
        public String property_id;
        public Integer role;
       
        public PropertyAgent(String id, String property_id, Integer role) {
            this.id = id;
            this.property_id = property_id;
            this.role = role;
        }
    } 
    
   public class Agents {
        public String id;
        public String name;
        public List<Property_Agent__c> properties; 
    } 
}