global class YardiGCPushBatch implements Database.Batchable<Case>, Database.AllowsCallouts, Database.Stateful{
    
    public String strInterfaceEntity 		= 'Anyone Home';
    public String strInterfaceLicense 		= 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
    public Boolean isShowProUser 			= false;
    public YardiGCPushController YardiController;
    public Map<String, Map<String, String>> IntegrationsCredentials    = new Map<String, Map<String, String>>();
    
    global YardiGCPushBatch( Boolean isShowProUser ) {
        this.isShowProUser = isShowProUser;
    }
    
    global Iterable<Case> start(Database.BatchableContext BC) {
        
        List<Case> cases = new List<Case>();
        try {
            String strSql = 'SELECT AccountId FROM Case WHERE GC_Entered__c = false AND Guest_Card_Status__c = \'Sent via Workflow\' AND Integration_Failed__c = false AND Cust_Prop_id__c != NULL ' + ( !Test.isRunningTest() ? ' AND LastModifiedDate = LAST_N_DAYS:5 ' : '' ) ;
            
            if( true == this.isShowProUser ) {
                strSql += ' and CreatedById = \'005i0000004xfgdAAA\'';
            }
            strSql += ' GROUP BY AccountId';
            
            List<AggregateResult> AggregateResults = (List<AggregateResult>) Database.query( strSql );
            
            if( AggregateResults.isEmpty() ) {
                return cases;
            }
            
            Set<String> AccountIds = new Set<String>();
            Set<String> WithGroupAccountIds = new Set<String>();
            Set<String> WithOutGroupAccountIds = new Set<String>();
            Set<String> GroupingNames = new Set<String>();
            
            for( AggregateResult result: AggregateResults ) {
                AccountIds.add( String.valueOf( result.get( 'AccountId' ) ) );      
            }
            
            List<Integration__c> searchList = [ SELECT 
                                               Account__c, Name, Yardi_Database_Name__c, Push_Guest_Cards_to_Yardi__c, Yardi_Integration_Active__c, Yardi_Server_Name__c, Yardi_ID__c, Yardi_Password__c, Yardi_Platform_Type__c, Yardi_API_URL__c, Yardi_SR_API_URL__c, Grouping__c, Yardi_Version_Number__c, Grouping__r.Name, Send_Waitlist__c
                                               FROM
                                               Integration__c
                                               WHERE
                                               Yardi_Integration_Active__c = true 
                                               AND Push_Guest_Cards_to_Yardi__c = true
                                               AND Account__c IN :AccountIds
                                              ];
            
            if( !searchList.isEmpty() ) {
                
                System.debug('searchList - ' + searchList);
                for( Integration__c I :searchList ) {

                    Map<String, String> strCredentials = new Map<String, String>();
                    strCredentials.put( 'Name' , I.Name );
                    strCredentials.put( 'YardiVersionNumber' , I.Yardi_Version_Number__c );
                    strCredentials.put( 'YardiAPIUrl' , I.Yardi_API_URL__c );
                    strCredentials.put( 'YardiUserName' , I.Yardi_ID__c );
                    strCredentials.put( 'YardiPassword' , I.Yardi_Password__c );
                    strCredentials.put( 'YardiServerName' , I.Yardi_Server_Name__c );
                    strCredentials.put( 'YardiDBName' , I.Yardi_Database_Name__c );
                    strCredentials.put( 'YardiPlatform' , I.Yardi_Platform_Type__c );
                    strCredentials.put( 'SendWaitlist' , ( true == I.Send_Waitlist__c ? 'YES' : 'NO' ) );
                    strCredentials.put( 'YardiInterfaceEntity' , strInterfaceEntity );
                    strCredentials.put( 'YardiInterfaceLicense' , strInterfaceLicense );
                    if( I.Grouping__c != null ) {
                        GroupingNames.add( I.Grouping__r.Name );     
                        WithGroupAccountIds.add(  I.Account__c );
                        IntegrationsCredentials.put( I.Grouping__c , strCredentials );
                    } else {
                        WithOutGroupAccountIds.add( I.Account__c);
                        IntegrationsCredentials.put( I.Account__c , strCredentials );
                    }
                }

                String strWithGroupAccountIds 			= SetToSOQLCompatible( WithGroupAccountIds );
                String strwithoutGroupAccounts 			= SetToSOQLCompatible( WithOutGroupAccountIds );
                String strGroupingNames 				= SetToSOQLCompatible( GroupingNames );
                
                String AdditionalWheresql;
                if( null != strWithGroupAccountIds && null != strGroupingNames ) {
                    AdditionalWheresql		= ' AND ( ( AccountId IN ( ' + strWithGroupAccountIds + ' ) AND Group_Membership__c IN ( ' + strGroupingNames + ' ) )';
                } else {
                    AdditionalWheresql		= ' AND ';
                }
                
                if( null != strwithoutGroupAccounts ) {
                    if( null != strWithGroupAccountIds && null != strGroupingNames ) {
                        AdditionalWheresql = AdditionalWheresql + ' OR ( AccountId IN ( ' + strwithoutGroupAccounts +  ' ) AND Group_Membership__c = null ) ) ';
                    } else {
                        AdditionalWheresql = AdditionalWheresql + ' ( AccountId IN ( ' + strwithoutGroupAccounts +  ' ) AND Group_Membership__c = null ) ';
                    }
                } else {
                    if( null != strWithGroupAccountIds && null != strGroupingNames ) {
                        AdditionalWheresql = AdditionalWheresql + ' ) ';
                    } else {
                        AdditionalWheresql = '';
                    }
                }
                
                String sqlWhere   			= ' WHERE GC_Entered__c = false AND Guest_Card_Status__c = \'Sent via Workflow\' AND Integration_Failed__c = false AND Cust_Prop_id__c != null '+ AdditionalWheresql + ( !Test.isRunningTest() ? ' AND LastModifiedDate = LAST_N_DAYS:5 ' : ' ' ) + ( true == this.isShowProUser ? ' and CreatedById = \'005i0000004xfgdAAA\'' : '' );
                
                String sql   					= 'SELECT Id, CaseNumber, Yardi_Guest_Card_ID__c, Is_First_Contact_Entered__c, GC_Entered__c, Account1__c, AccountId, Cust_Prop_id__c, Address_Line_1__c, ContactPhoneAPI__c, ContactNameAPI__c, Property_of_Interest1__c, Property_of_Interest__r.Name, City__c, Origin, State__c, Zip_code__c, Contact_Mobile_Email_template__c, Contact_Email_Email_template__c, Move_in_Date__c, Desired_Rent_Start__c, Desired_Rent_Range_End__c, Bed_Count_Pref__c, Desired_Lease_length__c, Date_Time_Sent_Via_Workflow__c, Notes__c, Ad_Source_Type__c, Appointment_1_ID__c, Appointment_2_ID__c, Appointment_3_ID__c, Appointment_1_Unit_ID__c, Appointment_2_Unit_ID__c, Appointment_3_Unit_ID__c, Guest_Card_Status__c, Integration_Failed__c, Realtor_Inquiry__c, Affordable_Inquiry__c, Multi_Family_Case__c,  Group_Membership__c, Contact.Prospect_ID__c, Property_Of_Interest__r.Customer_Prop_ID__c, Floor_Plan_of_Interest__r.Floorplan_ID__c, Floor_Plan_of_Interest__r.Property__c, Unit_of_Interest__c, Unit_of_Interest__r.Unit_ID__c, Unit_of_Interest__r.Property__c, Property_of_Interest__r.Group_Membership__c FROM Case ' +  ( !Test.isRunningTest() ? sqlWhere : ' ' ) + ' ORDER BY LastModifiedDate DESC';
                
                system.debug('sql - ' + sql);
                cases   						= ( List<Case> ) Database.query( sql );
            }
        } catch( Exception e ) {
            System.debug( e.getMessage() );
            system.debug( e.getStackTraceString() );
        }
        return cases;
    }
    
    global void execute(Database.BatchableContext BC, List<Case> cases ){
        
        YardiController 									= new YardiGCPushController();
        YardiController.cases 								= cases;
        YardiController.IntegrationsCredentialsPerAccount 	= IntegrationsCredentials;
        List<Case> NeedToUpdateCases 						= YardiController.pushGuestCards();
        try {
            
            update NeedToUpdateCases;
            
            List<Contact> Contacts				= new List<Contact>();
            Set<String> ContactIds 				= new Set<String>();
            System.debug('Execute Cases Count : ' + NeedToUpdateCases.size() ); //V.R.S
            for( Case cs : NeedToUpdateCases ) {
                if( null != cs.ContactId && !ContactIds.contains( cs.ContactId ) ) {
                    Contact c = new Contact();
                    c.Prospect_ID__c = cs.Yardi_Guest_Card_ID__c;
                    c.Id = cs.ContactId;
                    Contacts.add(c); 
                    ContactIds.add( cs.ContactId );
                }   
            }
            
            System.debug('Contacts count - ' + Contacts.size());
            if( !Contacts.isEmpty() )
                update Contacts;
        } catch ( Exception e ) { 
            System.Debug( e.getMessage() );
            System.Debug( e.getStackTraceString() );
        }
    }
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
    public String SetToSOQLCompatible( Set<String>Sets ) {
        
        if( Sets.isEmpty() )
            return null;
        
        String Compatible;
        Integer count = 1;
        for( String Individual:Sets ) {
            if( null != Individual ) {
                Compatible = (null != Compatible ? Compatible : '' ) + '\'';
                Compatible = Compatible + Individual ;
                Compatible = Compatible + '\'';
                if( count != Sets.size() ) {
                    Compatible = Compatible + ',';
                } else {
                    break;
                }
                count++;
            }
        }
        return Compatible;
    }
}