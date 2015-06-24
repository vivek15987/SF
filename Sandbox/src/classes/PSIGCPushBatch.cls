global class PSIGCPushBatch implements Database.Batchable<Case>, Database.AllowsCallouts, Database.Stateful {
    
    public PSIGCPushController PSI 		= new PSIGCPushController();
    public List<Case> NeedtoUpdateCases	= new List<Case>();
    public List<Case> Cases 			= new List<Case>();
    public Map<String, Map<String, String>> IntegrationsCredentialsPerAccount = new Map<String, Map<String, String>>();
    
    public PSIGCPushBatch() {
    }
    
    global Iterable<Case> start(Database.BatchableContext BC) {
        
        try {
            String strSql = 'SELECT AccountId FROM Case WHERE GC_Entered__c = false and Guest_Card_Status__c = \'Sent via Workflow\' and Integration_Failed__c = false and Property_of_Interest__r.PSI_Prop_ID__c != null '+ ( !Test.isRunningTest() ? ' and LastModifiedDate = LAST_N_DAYS:5 ' : ' ' ) + ' GROUP BY AccountId ';
            
            List<AggregateResult> AggregateResults = (List<AggregateResult>) Database.query( strSql );
            
            if( AggregateResults.isEmpty() ) {
                return Cases;
            }
            
            Set<String> AccountIds 					= new Set<String>();
            Set<String> WithGroupAccountIds 		= new Set<String>();        
            Set<String> WithOutGroupAccountIds 		= new Set<String>();
            Set<String> GroupingNames 				= new Set<String>();
            
            for( AggregateResult result: AggregateResults ) {
                AccountIds.add( String.valueOf( result.get( 'AccountId' ) ) );      
            }
            
            List<Integration__c> searchList = [SELECT 
                                               Account__c, Name, Grouping__c,
                                               PSI_Password__c, PSI_Username__c,
                                               PSI_API_URL__c, Grouping__r.Name
                                               FROM
                                               Integration__c
                                               WHERE
                                               PSI_Integration_Active__c = true 
                                               AND Push_Guest_Cards_to_PSI__c = true
                                               AND Account__c IN :AccountIds
                                              ];
            System.debug('searchList - ' + searchList);
            if( !searchList.isEmpty() ) {
                
                for( Integration__c I :searchList ) {
                    
                    if( I.Grouping__c != null ) {
                        GroupingNames.add( I.Grouping__r.Name );     
                        WithGroupAccountIds.add(  I.Account__c );
                    } else {
                        WithOutGroupAccountIds.add( I.Account__c);
                    }
                    
                    if( !IntegrationsCredentialsPerAccount.containsKey( I.Account__c ) ) {
                        
                        Map<String, String> strCredentials = new Map<String, String>();
                        strCredentials.put( 'PSIAPIUrl' , I.PSI_API_URL__c );
                        strCredentials.put( 'PSIUserName' , I.PSI_Username__c );
                        strCredentials.put( 'PSIPassword' , I.PSI_Password__c );
                        IntegrationsCredentialsPerAccount.put( I.Account__c , strCredentials );
                    }
                }
                
                String strWithGroupAccountIds 		= SetToSOQLCompatible( WithGroupAccountIds );
                String strwithoutGroupAccounts 		= SetToSOQLCompatible( WithOutGroupAccountIds );
                String strGroupingNames 			= SetToSOQLCompatible( GroupingNames );
                
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
                
                String sqlWhere   				= ' WHERE GC_Entered__c = false and Guest_Card_Status__c = \'Sent via Workflow\' and Integration_Failed__c = false and Property_of_Interest__r.PSI_Prop_ID__c != null '+ AdditionalWheresql + ( !Test.isRunningTest() ? ' and LastModifiedDate = LAST_N_DAYS:5 ' : ' ' );
                String sql   					= ' SELECT Id, AccountId, CaseNumber, Property_of_Interest__r.PSI_Prop_ID__c, CreatedDate, ContactPhoneAPI__c, ContactNameAPI__c, Contact_Mobile_Email_template__c, Contact_Email_Email_template__c, Move_in_Date__c, Desired_Rent_Start__c, Desired_Rent_Range_End__c, Bed_Count_Pref__c, Bath_Count_Pref__c, Of_Occupants__c, Desired_Lease_length__c, Date_Time_Sent_Via_Workflow__c, Ad_Source_Type__c, Ad_Source_DNIS__c, Appointment_1_ID__c, Appointment_2_ID__c, Appointment_3_ID__c, Appointment_1_Unit_ID__c, Appointment_2_Unit_ID__c, Appointment_3_Unit_ID__c, IC_Call_Duration__c, Integration_Failed__c, Multi_Family_Case__c,  Group_Membership__c, Contact.Prospect_ID__c, Floor_Plan_of_Interest__r.PSI_Floor_Plan_ID__c, Unit_of_Interest__c, Unit_of_Interest__r.PSI_Unit_ID__c, Unit_of_Interest__r.Name, Unit_of_Interest__r.Floor_Plan__c, Unit_of_Interest__r.Bedrooms__c, Unit_of_Interest__r.Bathrooms__c, Unit_of_Interest__r.Square_Feet__c, Unit_of_Interest__r.Maximum_Rent__c, Unit_of_Interest__r.Market_Rent__c FROM Case ' + sqlWhere + ' ORDER BY LastModifiedDate DESC';
                system.debug('sql - ' + sql);
                Cases   								= ( List<Case> ) Database.query( sql );
                PSI.Cases								= Cases;
                PSI.IntegrationsCredentialsPerAccount	= IntegrationsCredentialsPerAccount;
                NeedtoUpdateCases						= PSI.pushGuestCards();                
                
            }
        } catch ( Exception e ) {
            System.Debug( e.getMessage() );
            System.Debug( e.getStackTraceString() );
        }
        return NeedtoUpdateCases;
    }
    
    global void execute(Database.BatchableContext BC, List<Case> Cases ){
        
        try {
            update Cases;
            
            List<Contact> contacts			= new List<Contact>();
            Set<String> ContactIds 			= new Set<String>();
            
            for( Case cs : cases ) {
                if( !ContactIds.contains( cs.ContactId ) ) {
                    Contact c = new Contact();
                    c.Prospect_ID__c = cs.Yardi_Guest_Card_ID__c;
                    c.Id = cs.ContactId;
                    contacts.add(c); 
                    ContactIds.add(cs.ContactId );
                }   
            }
            
            update contacts;
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
        for( String Indivualset:Sets ) {
            if( null != Indivualset ) {
                Compatible = (null != Compatible ? Compatible : '' ) + '\'';
                Compatible = Compatible + Indivualset ;
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