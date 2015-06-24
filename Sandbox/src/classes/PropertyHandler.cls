/**
 * Class PropertyHandler
 *
 * Trigger Handler for the Property SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public with sharing class PropertyHandler implements ITrigger {	
	
	// Constructor
	public PropertyHandler()
	{
	}

	/**
	 * bulkBefore
	 *
	 * This method is called prior to execution of a BEFORE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	public void bulkBefore()
	{
		// If this a delete trigger Cache a list of Property Id's that are 'in use'
		
	}
	
	public void bulkAfter()
	{
	}
		
	public void beforeInsert( SObject Obj )
	{
        Property__c prop = ( Property__c ) Obj;
        if( prop.Address_Line_1__c != null ) {
            this.PopulateStreetNumber( prop );
        }
	}
	
	public void beforeUpdate( SObject oldObj, SObject Obj ) {

       /* Map<ID, Property__c> NewPropertyPerId = new Map<ID, Property__c>();
        Map<ID, Property__c> OldPropertyPerId = new Map<ID, Property__c>();
        
        for( Property__c NewProp :NewPropertyList ) {
            if( !NewPropertyPerId.containsKey( NewProp.Id ) ) {
                NewPropertyPerId.put( NewProp.Id , NewProp );
            }
        }
        
        for( Property__c OldProp :oldPropertyList ) {
            if( !OldPropertyPerId.containsKey( OldProp.Id ) ) {
                OldPropertyPerId.put( OldProp.Id , OldProp );
            }
        }
        
        for( Property__c NewProp :NewPropertyList ) {
            if( NewProp.Street_Number__c == null && NewProp.Address_Line_1__c != NULL ) {
                this.PopulateStreetNumber( NewProp );
            }

            if( NewPropertyPerId.containsKey( NewProp.Id ) && OldPropertyPerId.containsKey( NewProp.Id ) && NewPropertyPerId.get( NewProp.Id ).Id == OldPropertyPerId.get( NewProp.Id ).Id ) {
                if( NewPropertyPerId.get( NewProp.Id ).Address_Line_1__c != OldPropertyPerId.get( NewProp.Id ).Address_Line_1__c ) {
                    this.PopulateStreetNumber( NewProp );
                }
            } 
        }
        
        this.PropertyMSAJunction( NewPropertyList );*/
	}
	
    public void PopulateStreetNumber( Property__c P ) {
        System.debug('Property -Name : ' + P.Name );
        String strAddress = String.valueOf( p.Address_Line_1__c );
        String[] address = strAddress.split( ' ' );
        p.Street_Number__c = Address[0];
    }
    
    public void PropertyMSAJunction( List<Property__c> NewPropertyList ) {
        
        Map<String,String> PropertyPerAccountGroup 			= new Map<String,String>();
        Map<String,String> PropertyPerGroup 				= new Map<String,String>();
        Map<String,String> PropertyPerMSAGroup 				= new Map<String,String>();
        Map<String,String> PropertyPerAccountWithoutGroup 	= new Map<String,String>();
        Map<String,String> PropertyPerMSAWithoutGroup 		= new Map<String,String>();
        Map<String,String> PropertyIdsPerMSAIds 			= new Map<String,String>();
        Map<String, Property__c > AllPropertiesById 		= new Map<String, Property__c>();
        Set<ID> CAH_FSGroupPropertyIds						= new Set<ID>();

        for( Property__c p:NewPropertyList ) {
            AllPropertiesById.put( p.Id , p );
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
            }
        }
    }
	/**
	 * beforeDelete
	 *
	 * This method is called iteratively for each record to be deleted during a BEFORE
	 * trigger.
	 */
	public void beforeDelete(SObject so)
	{	
	}
	
	public void afterInsert(SObject so)
	{
	}
	
    public void afterUpdate( List<Property__c> oldPropertyList, List<Property__c>NewPropertyList ) {
		this.updateAppointment( oldPropertyList, NewPropertyList );
    }
    
    public void updateAppointment( List<Property__c> oldPropertyList, List<Property__c>NewPropertyList ) {
        
        Set<ID> AllPropertyIds = new Set<Id>();
        
        for( Property__c p : NewPropertyList ) {
            if( p.Active__c == 'No' )
                AllPropertyIds.add( p.Id );
        }
        
        System.debug('AllPropertyIds - ' + AllPropertyIds);
        List<Appointment__c> Appointments = [ Select Id,Invite_Status__c,CanceledRejected_By__c  From Appointment__c where Property__c IN :AllPropertyIds and Appointment_Date__c >= today AND ( Invite_Status__C = 'Invited' OR Invite_Status__C = 'Accepted' ) ];
        List<Appointment__c> NeedToUpdateAppointments = new List<Appointment__c>();
        
        System.debug('Appointments - ' + Appointments);
        if( Appointments.size()>0 ) {
            for( Appointment__c aa:Appointments ) {
                aa.Invite_Status__c='Canceled' ;
                aa.CanceledRejected_By__c='Automated System (home leased)';
                NeedToUpdateAppointments.add( aa );
            }
        }
        
        if( !NeedToUpdateAppointments.isEmpty() )
            update NeedToUpdateAppointments;
    }
    
    public void afterDelete(SObject so)
    {
    }
	
	/**
	 * andFinally
	 *
	 * This method is called once all records have been processed by the trigger. Use this 
	 * method to accomplish any final operations such as creation or updates of other records.
	 */
	public void andFinally()
	{
		// insert any audit records
		//if (!m_audits.isEmpty())
		//{
			//insert m_audits;
		//}
	}
}