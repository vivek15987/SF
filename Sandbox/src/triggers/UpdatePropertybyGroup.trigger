trigger UpdatePropertybyGroup on Property__c (after insert, after update) {
   
    List<Property__c> arrobjProperties = new List<Property__c>();
    Set<Id> strAccountIDs = new Set<Id>();
    
    for(Property__c p : Trigger.new){
        if( p.Multi_Family_Property__c == true && p.Group_Membership__c == null ) {
            arrobjProperties.add( p );
            strAccountIDs.add(p.Account__c);
        }
    }
    
    List<Grouping__c> arrobjGroups     = [Select Id, Name, Account__c from Grouping__c where Account__c IN : strAccountIDs];
    Map<String, Map<String, String>> AccountGroupNameAndIds = new Map<String, Map<String, String>>();
    
    for( Grouping__c Grp: arrobjGroups ) {
        if( AccountGroupNameAndIds.containsKey(Grp.Account__c) ) {
            Map<String, String> tempGroupNameAndIds = new Map<String, String>();
            tempGroupNameAndIds.putAll( AccountGroupNameAndIds.get( Grp.Account__c ) );
            tempGroupNameAndIds.put( Grp.Name, Grp.Id );
            AccountGroupNameAndIds.put( Grp.Account__c, tempGroupNameAndIds );
        } else {
            AccountGroupNameAndIds.put( Grp.Account__c, new Map<String, String>{ Grp.Name => Grp.Id } );
        }
    }
    
    List<Grouping__c> newGroups = new List<Grouping__c>();
    List<Property__c> arrobjUpdateProperties = new List<Property__c>();
	Map<String, String> PropertyNameAndIds = new Map<String, String>();
    
    for(Property__c p :arrobjProperties) {
        if( AccountGroupNameAndIds.containsKey( p.Account__c ) ) {
            if( AccountGroupNameAndIds.get( p.Account__c ).containsKey( p.Name ) ) {
                Property__c prop = new Property__c();
                prop.Id = p.Id;
                prop.Group_Membership__c = AccountGroupNameAndIds.get( p.Account__c ).get( p.Name );
                arrobjUpdateProperties.add( prop );
            } else {
                Grouping__c newGroup 	= new Grouping__c();
                newGroup.Account__c		= p.Account__c;
                newGroup.Name			= p.Name;
                newGroups.add( newGroup );
                PropertyNameAndIds.put( p.Name, p.Id );
                //add new group
            }
        } else {
            Grouping__c newGroup 	= new Grouping__c();
            newGroup.Account__c		= p.Account__c;
            newGroup.Name			= p.Name;
            newGroups.add( newGroup );
            PropertyNameAndIds.put( p.Name, p.Id );
            //add new group
        }
    }

    upsert newGroups;
    
    for( Grouping__c grp : newGroups ) {
        if( PropertyNameAndIds.containsKey( grp.Name ) ) {
            Property__c prop = new Property__c();
            prop.Id = PropertyNameAndIds.get( grp.Name );
            prop.Group_Membership__c = grp.Id;
            arrobjUpdateProperties.add( prop );
            
        }
    }
    
    upsert arrobjUpdateProperties;
    
}