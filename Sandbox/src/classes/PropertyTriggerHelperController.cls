public class PropertyTriggerHelperController {
    
    public List<Property__c> PopulateStreetNumber( List<Property__c> PropertyListNewValues, List<Property__c> PropertyListOldValues ) {
        List<Property__c> NeedToUpdateProperties = new List<Property__c>();
        
        return NeedToUpdateProperties;
    }
    
    public List<Property__c> PropertyMSAJuction( List<Property__c> PropertyList ) {
        
        Map<String,String> PropertyPerAccountGroup 			= new Map<String,String>();
        Map<String,String> PropertyPerGroup 				= new Map<String,String>();
        Map<String,String> PropertyPerMSAGroup 				= new Map<String,String>();
        Map<String,String> PropertyPerAccountWithoutGroup 	= new Map<String,String>();
        Map<String,String> PropertyPerMSAWithoutGroup 		= new Map<String,String>();
        Map<String,String> PropertyIdsPerMSAIds 			= new Map<String,String>();
        List<Property__c> NeedToUpdateProperties			= new List<Property__c>();
        Map<String, Property__c > AllPropertiesById 		= new Map<String, Property__c>();
        Set<ID> CAH_FSGroupPropertyIds						= new Set<ID>();
        
        for (Property__c p:PropertyList) {
            AllPropertiesById.put( p.Id , p);
            if( p.Group_Membership__c != null ) {
                PropertyPerAccountGroup.put( p.Id , p.Account1__c );
                PropertyPerMSAGroup.put( p.Id , p.MSA__c );
                PropertyPerGroup.put( p.Id , p.Group_Membership1__c );
            } else {
                PropertyPerAccountWithoutGroup.put(p.Id, p.Account1__c);
                PropertyPerMSAWithoutGroup.put(p.Id, p.MSA__c);
            }
        }
        
        List<Account_MSA_Connection__c> AllAMCWithGroups = [Select Id,Name,Account1__c,MSA1__c from Account_MSA_Connection__c where Account1__c IN :PropertyPerAccountGroup.values() and MSA1__c IN :PropertyPerMSAGroup.values() and Group__c IN :PropertyPerGroup.values() ];
        List<Account_MSA_Connection__c> AllAMCWithoutGroups = [Select Id,Name,Account1__c,MSA1__c from Account_MSA_Connection__c where Account1__c IN :PropertyPerAccountWithoutGroup.values() and MSA1__c IN :PropertyPerMSAWithoutGroup.values() ];
        
        Map<String, Account_MSA_Connection__c> MSAObjs = new Map<String, Account_MSA_Connection__c>();
        for( Account_MSA_Connection__c AMCObj : AllAMCWithGroups ) {
            for( String PropertyId :PropertyPerGroup.keySet() ) {
                if( null != PropertyPerGroup.get( PropertyId ) && AMCObj.MSA1__c == PropertyPerMSAGroup.get( PropertyId ) ) {
                    MSAObjs.put( PropertyPerGroup.get( PropertyId ) , AMCObj );
                    PropertyIdsPerMSAIds.put( PropertyId , AMCObj.Id );
                }
                if( PropertyPerGroup.get( PropertyId ) == 'CAH-FS(TEMP)' ) {
                    CAH_FSGroupPropertyIds.add( PropertyId );
                    Account_MSA_Connection__c amc1=[Select Id from Account_MSA_Connection__c where Name='CAH-FS(TEMP)-NO-MSA'];
                    PropertyIdsPerMSAIds.put( PropertyId , amc1.Id );
                }
            }
        }
        
        for( Account_MSA_Connection__c AMCObj : AllAMCWithoutGroups ) {
            for( String PropertyId :PropertyPerMSAWithoutGroup.keySet() ) {
                if( null != PropertyPerMSAWithoutGroup.get( PropertyId ) && AMCObj.MSA1__c == PropertyPerMSAWithoutGroup.get( PropertyId ) ) {
                    MSAObjs.put( PropertyPerMSAWithoutGroup.get( PropertyId ) , AMCObj );
                    PropertyIdsPerMSAIds.put( PropertyId , AMCObj.Id );
                }
            }
        }
        System.debug('PropertyMSAJuction Trigger All MSAObjs - ' + MSAObjs);
        
        for( String PropertyId: PropertyIdsPerMSAIds.keySet() ) {
            if( AllPropertiesById.containsKey( PropertyId ) ) {
                Property__c NeedToUpdateProperty = new Property__c();
                NeedToUpdateProperty = AllPropertiesById.get( PropertyId );
                NeedToUpdateProperty.Account_MSA_Junction__c = PropertyIdsPerMSAIds.get(PropertyId);
                if( CAH_FSGroupPropertyIds.contains( PropertyId ) ) {
                    NeedToUpdateProperty.Active__c = 'No';
                }
                NeedToUpdateProperties.add( NeedToUpdateProperty );
            }
        }
        return NeedToUpdateProperties;
    }
}