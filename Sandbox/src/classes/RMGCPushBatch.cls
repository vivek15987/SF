global class RMGCPushBatch implements Database.Batchable<Case>, Database.AllowsCallouts, Database.Stateful{
    
    public Boolean isTestRMGCPushScheduler   = false;
    public Boolean isShowProUser       = false;
    
    public RMGCPushController RMGCController= new RMGCPushController();
    
    public Map<String, Object> result    = new Map<String, Object>();
    public Map<String, String> hours        = new Map<String, String>();
    public Map<String, String> arrCases   = new Map<String, String>();
    
    public List<Case> updatedCases       = new List<Case>();
    public List<Case> cases         = new List<Case>();
    public List<Appointment__c> apps    = new List<Appointment__c>();
    
    public List<Map<String, String>> updatedAppointments = new List<Map<String, String>>();
    
    public Map<String, Map<String, String>> IntegrationsCredentialsPerAccount = new Map<String, Map<String, String>>();
    
    public RMGCPushBatch(){
    }
    
    public RMGCPushBatch( Boolean isShowProUser ) {
        this.isShowProUser = isShowProUser;
        hours.put( '0' ,'00:00:00' );
        hours.put( '1' ,'23:00:00' );
        hours.put( '2' ,'22:30:00' );
        hours.put( '3' ,'22:00:00' );
        hours.put( '4' ,'21:30:00' );
        hours.put( '5' ,'21:00:00' );
        hours.put( '6' ,'20:30:00' );
        hours.put( '7' ,'20:00:00' );
        hours.put( '8' ,'19:30:00' );
        hours.put( '9' ,'19:00:00' );
        hours.put( '10' ,'18:30:00' );
        hours.put( '11' ,'18:00:00' );
        hours.put( '12' ,'17:30:00' );
        hours.put( '13' ,'17:00:00' );
        hours.put( '14' ,'16:30:00' );
        hours.put( '15' ,'16:00:00' );
        hours.put( '16' ,'15:30:00' );
        hours.put( '17' ,'15:00:00' );
        hours.put( '18' ,'14:30:00' );
        hours.put( '19' ,'14:00:00' );
        hours.put( '20' ,'13:30:00' );
        hours.put( '21' ,'13:00:00' );
        hours.put( '22' ,'12:30:00' );
        hours.put( '23' ,'12:00:00' );
        hours.put( '24' ,'11:30:00' );
        hours.put( '25' ,'11:00:00' );
        hours.put( '26' ,'10:30:00' );
        hours.put( '27' ,'10:00:00' );
        hours.put( '28' ,'09:30:00' );
        hours.put( '29' ,'09:00:00' );
        hours.put( '30' ,'08:30:00' );
        hours.put( '31' ,'08:00:00' );
        hours.put( '32' ,'07:30:00' );
        hours.put( '33' ,'07:00:00' );
        hours.put( '34' ,'06:30:00' );
        hours.put( '35' ,'06:00:00' );
    }
    
    global Iterable<Case> start(Database.BatchableContext BC) {
        
        try {
            String strSql = 'SELECT AccountId FROM Case WHERE GC_Entered__c = false AND Guest_Card_Status__c = \'Sent via Workflow\' AND Integration_Failed__c = false AND Property_of_Interest__r.ResMan_Property_Id__c != null' + ( !Test.isRunningTest() ? ' AND LastModifiedDate = LAST_N_DAYS:5 ' : ' ' );
            
            if( true == this.isShowProUser ) {
                strSql += ' AND CreatedById = \'005i0000004xfgdAAA\'';
            }
            strSql += ' GROUP BY AccountId';
            
            List<AggregateResult> AggregateResults = (List<AggregateResult>) Database.query( strSql );
            
            if( AggregateResults.isEmpty() ) {
                return cases;
            }
            
            Set<String> AccountIds           = new Set<String>();
            Set<String> WithGroupAccountIds     = new Set<String>();        
            Set<String> WithOutGroupAccountIds     = new Set<String>();
            Set<String> GroupingNames         = new Set<String>();
            
            for( AggregateResult result: AggregateResults ) {
                AccountIds.add( String.valueOf( result.get( 'AccountId' ) ) );      
            }
            
            List<Integration__c> searchList = [ SELECT 
                                               Id,
                                               Name,
                                               Account__c,
                                               ResMan_API_URL__c,
                                               ResMan_API_Key__c,
                                               ResMan_Integration_Partner_ID__c,
                                               ResMan_Account_Id__c,
                                               Grouping__c,
                                               Grouping__r.Name
                                               FROM
                                               Integration__c
                                               WHERE
                                               ResMan_Integration_Active__c = true
                                               AND Push_Guest_Card_to_ResMan__c = true
                                               AND ResMan_Account_Id__c != NULL
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
                        strCredentials.put( 'ResManAccountId' , I.ResMan_Account_Id__c );
                        strCredentials.put( 'ResManIntegrationPartner' , I.ResMan_Integration_Partner_ID__c );
                        strCredentials.put( 'ResManAPIKey' , I.ResMan_API_Key__c );
                        strCredentials.put( 'ResManAPIUrl' , I.ResMan_API_URL__c );
                        IntegrationsCredentialsPerAccount.put( I.Account__c , strCredentials );
                    }
                }
                
                String strWithGroupAccountIds     = SetToSOQLCompatible( WithGroupAccountIds );
                String strwithoutGroupAccounts     = SetToSOQLCompatible( WithOutGroupAccountIds );
                String strGroupingNames       = SetToSOQLCompatible( GroupingNames );
                
                String AdditionalWheresql;
                if( null != strWithGroupAccountIds && null != strGroupingNames ) {
                    AdditionalWheresql    = ' AND ( ( AccountId IN ( ' + strWithGroupAccountIds + ' ) AND Group_Membership__c IN ( ' + strGroupingNames + ' ) )';
                } else {
                    AdditionalWheresql    = ' AND ';
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
                
                String sqlWhere           = ' WHERE GC_Entered__c = false AND Guest_Card_Status__c = \'Sent via Workflow\' AND Integration_Failed__c = false AND Property_of_Interest__r.ResMan_Property_Id__c != null '+ AdditionalWheresql + ( !Test.isRunningTest() ? ' and LastModifiedDate = LAST_N_DAYS:5 ' : ' ' ) + ( true == this.isShowProUser ? ' and CreatedById = \'005i0000004xfgdAAA\'' : '' );
                String sql             = ' SELECT Id, CaseNumber, PMS_Applicant_ID__c, External_First_Contact_Id__c, Is_First_Contact_Entered__c, Yardi_Guest_Card_ID__c, GC_Entered__c, Account1__c, AccountId, Cust_Prop_id__c, Address_Line_2__c, Address_Line_1__c, ContactPhoneAPI__c, ContactNameAPI__c, Property_of_Interest1__c, Property_of_Interest__r.Name,Property_of_Interest__r.ResMan_Property_Id__c, City__c, Origin, State__c, Zip_code__c, Contact_Mobile_Email_template__c, Contact_Email_Email_template__c, Move_in_Date__c, Desired_Rent_Start__c, Desired_Rent_Range_End__c, Bed_Count_Pref__c, Desired_Lease_length__c, Date_Time_Sent_Via_Workflow__c, Notes__c, Ad_Source_Type__c, Guest_Card_Status__c, Integration_Failed__c, Realtor_Inquiry__c, Affordable_Inquiry__c, Multi_Family_Case__c,  Group_Membership__c, Contact.ResMan_Agent_Id__c , Contact.FirstName, Contact.LastName, Contact.MobilePhone, Contact.Phone, Contact.Id, Contact.Email, Floor_Plan_of_Interest__r.ResMan_Floor_Plan_ID__c, Unit_of_Interest__c, Unit_of_Interest__r.ResMan_Unit_ID__c, Property_of_Interest__r.ResMan_Agent_Id__c FROM Case' + ( !Test.isRunningTest() ? sqlWhere : ' ') + ' ORDER BY LastModifiedDate DESC ';
                system.debug('sql - ' + sql);
                cases               = ( List<Case> ) Database.query( sql );
            }
            
        } catch ( Exception e ) {
            System.Debug( e.getMessage() );
            System.Debug( e.getStackTraceString() );
        }
        
        return cases;
    }
    
    global void execute(Database.BatchableContext BC, List<Case> cases){
        
        try {
            RMGCController.ValidateCases            = cases;
            RMGCController.IntegrationsCredentialsPerAccount   = IntegrationsCredentialsPerAccount;
            List<Case> NeedToUpdateCases             = RMGCController.pushGuestCards();
            update NeedToUpdateCases;
            
            List<Contact> contacts      = new List<Contact>();
            Set<String> ContactIds       = new Set<String>();
            System.debug('Execute Cases Count : ' + NeedToUpdateCases.size()); //V.R.S
            for( Case cs : NeedToUpdateCases ) {
                if( null != cs.ContactId && !ContactIds.contains( cs.ContactId ) ) {
                    Contact c = new Contact();
                    c.ResMan_Prospect_Id__c = cs.Yardi_Guest_Card_ID__c;
                    c.Id = cs.ContactId;
                    contacts.add(c); 
                    ContactIds.add(cs.ContactId );
                } 
            }
            
            system.debug( ' Contact count - '+ ContactIds.size());
            if( !contacts.isEmpty() && ContactIds.size() > 0 ) {
                update contacts;
            }
            
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