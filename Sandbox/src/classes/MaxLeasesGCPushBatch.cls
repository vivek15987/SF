global class MaxLeasesGCPushBatch implements Database.Batchable<Case>, Database.AllowsCallouts, Database.Stateful {

    public Map<String, Map<String, String>> IntegrationsCredentials    = new Map<String, Map<String, String>>();
    
    public MaxLeasesGCPushBatch() {}
    
    global Iterable<Case> start(Database.BatchableContext BC) {
        
        List<Case> cases = new List<Case>();
        try {

            String strSql = 'SELECT AccountId FROM Case WHERE GC_Entered__c = false AND Guest_Card_Status__c = \'Sent via Workflow\' AND Integration_Failed__c = false AND Property_of_Interest__r.Max_Lease_Property_Id__c != NULL ' + ( !Test.isRunningTest() ? ' AND LastModifiedDate = LAST_N_DAYS:5 ' : '' ) ;

            strSql += ' GROUP BY AccountId';
            
            List<AggregateResult> AggregateResults = ( List<AggregateResult> ) Database.query( strSql );
            
            if( AggregateResults.isEmpty() ) {
                return cases;
            }
            
            Set<String> AccountIds = new Set<String>();
            Set<String> WithGroupAccountIds = new Set<String>();
            Set<String> WithOutGroupAccountIds = new Set<String>();
            Set<String> GroupingIds = new Set<String>();
            
            for( AggregateResult result: AggregateResults ) {
                AccountIds.add( String.valueOf( result.get( 'AccountId' ) ) );      
            }
            
            List<Integration__c> searchList = [ SELECT 
                                               Account__c, Name, Id, MaxLease_API_URL__c, Grouping__c
                                               FROM
                                               Integration__c
                                               WHERE
                                               //Id = 'a18f0000001y2am'
                                               MaxLeases_Integration_Active__c = true
                                               AND MaxLeases_Push_Guest_Card__c = true
                                               AND Account__c IN :AccountIds
                                              ];
            
            if( !searchList.isEmpty() ) {
                
                System.debug('searchList - ' + searchList);
                for( Integration__c I :searchList ) {

                    Map<String, String> strCredentials = new Map<String, String>();
                    strCredentials.put( 'Name' , I.Name );
                    strCredentials.put( 'Id' , I.Id );
                    strCredentials.put( 'MaxLeaseAPIURL' , I.MaxLease_API_URL__c );
 
                    if( I.Grouping__c != null ) {
                        GroupingIds.add( I.Grouping__c );     
                        WithGroupAccountIds.add(  I.Account__c );
                        IntegrationsCredentials.put( I.Grouping__c , strCredentials );
                    } else {
                        WithOutGroupAccountIds.add( I.Account__c);
                        IntegrationsCredentials.put( I.Account__c , strCredentials );
                    }
                }

                System.debug('IntegrationsCredentials batch - ' + IntegrationsCredentials);
                String strWithGroupAccountIds 			= SetToSOQLCompatible( WithGroupAccountIds );
                String strwithoutGroupAccounts 			= SetToSOQLCompatible( WithOutGroupAccountIds );
                String strGroupingIds 					= SetToSOQLCompatible( GroupingIds );
                
                String AdditionalWheresql;
                if( null != strWithGroupAccountIds && null != strGroupingIds ) {
                    AdditionalWheresql		= ' AND ( ( AccountId IN ( ' + strWithGroupAccountIds + ' ) AND Property_of_Interest__r.Group_Membership__c IN ( ' + strGroupingIds + ' ) )';
                } else {
                    AdditionalWheresql		= ' AND ';
                }
                
                if( null != strwithoutGroupAccounts ) {
                    if( null != strWithGroupAccountIds && null != strGroupingIds ) {
                        AdditionalWheresql = AdditionalWheresql + ' OR ( AccountId IN ( ' + strwithoutGroupAccounts +  ' ) AND Property_of_Interest__r.Group_Membership__c = null ) ) ';
                    } else {
                        AdditionalWheresql = AdditionalWheresql + ' ( AccountId IN ( ' + strwithoutGroupAccounts +  ' ) Property_of_Interest__r.Group_Membership__c = null ) ';
                    }
                } else {
                    if( null != strWithGroupAccountIds && null != strGroupingIds ) {
                        AdditionalWheresql = AdditionalWheresql + ' ) ';
                    } else {
                        AdditionalWheresql = '';
                    }
                }
                
                String sqlWhere	= ' WHERE GC_Entered__c = false AND Guest_Card_Status__c = \'Sent via Workflow\' AND Integration_Failed__c = false AND Property_of_Interest__r.Max_Lease_Property_Id__c != null '+ AdditionalWheresql + ( !Test.isRunningTest() ? ' AND LastModifiedDate = LAST_N_DAYS:5 ' : ' ' );
				//String sqlWhere	= 'WHERE Id =\'500f0000006AM1m\' ';                
                String sql   	= 'SELECT Id, CaseNumber, Yardi_Guest_Card_ID__c, Is_First_Contact_Entered__c, GC_Entered__c, Account1__c, AccountId, Cust_Prop_id__c, Address_Line_1__c, ContactPhoneAPI__c, ContactNameAPI__c, Property_of_Interest1__c, Property_of_Interest__r.Name, City__c, Origin, State__c, Zip_code__c, Contact_Mobile_Email_template__c, Contact_Email_Email_template__c, Move_in_Date__c, Desired_Rent_Start__c, Desired_Rent_Range_End__c, Bed_Count_Pref__c, Desired_Lease_length__c, Date_Time_Sent_Via_Workflow__c, Notes__c, Ad_Source_Type__c, Realtor_Inquiry__c, Affordable_Inquiry__c, Multi_Family_Case__c,  Group_Membership__c, Contact.Prospect_ID__c, Property_Of_Interest__r.Customer_Prop_ID__c, Floor_Plan_of_Interest__r.Floorplan_ID__c, Floor_Plan_of_Interest__r.Property__c, Unit_of_Interest__c, Unit_of_Interest__r.Unit_ID__c, Unit_of_Interest__r.Property__c, Property_of_Interest__r.Group_Membership__c, Bath_Count_Pref__c, Property_of_Interest__r.Max_Lease_Property_Id__c  FROM Case ' +  ( !Test.isRunningTest() ? sqlWhere : ' ' ) + ' ORDER BY LastModifiedDate DESC';
                
                system.debug('sql - ' + sql);
                cases   						= ( List<Case> ) Database.query( sql );
                System.debug('cases - ' + cases);
            }
        } catch( Exception e ) {
            System.debug( e.getMessage() );
            system.debug( e.getStackTraceString() );
        }

        return cases;
    }
    
    global void execute( Database.BatchableContext BC, List<Case> Cases ){
     
        MaxLeasesGCPushController MaxLeaseController			= new MaxLeasesGCPushController();
        MaxLeaseController.arrobjCases							= cases;
        MaxLeaseController.IntegrationsCredentialsPerAccount 	= IntegrationsCredentials;
        MaxLeaseController.pushGuestCards();
        System.debug( MaxLeaseController.strResponse );
        if( !MaxLeaseController.arrGuestCardsResponse.isEmpty() ) {
            try {
                List<case> arrobjCases = new List<Case>();
                Set<String> ContactIds = new Set<String>();
                List<Contact> contacts = new List<Contact>();
                for( Case cs : Cases ) {
                     Integer CaseNumber = ( !Test.isRunningTest() ) ? Integer.valueOf( cs.CaseNumber ) : 831765;
                    
                    if( MaxLeaseController.arrGuestCardsResponse.containsKey( CaseNumber ) ) {
                        if( MaxLeaseController.arrGuestCardsResponse.get( CaseNumber ).containsKey( 'Status' ) ) {
                            if( 'Success' == MaxLeaseController.arrGuestCardsResponse.get( CaseNumber ).get( 'Status' ) ) {
                                if( true == MaxLeaseController.NeedToupdateAppointmentsPerCase.containsKey( CaseNumber ) && NULL != MaxLeaseController.NeedToupdateAppointmentsPerCase.get( CaseNumber ) ){
                                   update MaxLeaseController.NeedToupdateAppointmentsPerCase.get( CaseNumber ); 
                                }
                                cs.GC_Entered__c = true;
                                cs.Is_First_Contact_Entered__c = true;
                                cs.integration_fail_success_message__c = 'Success';
                            } else if( 'Error' == MaxLeaseController.arrGuestCardsResponse.get( CaseNumber ).get( 'Status' ) ) {
                                cs.GC_Entered__c = false;
                                cs.Integration_Failed__c =  true;
                                cs.integration_fail_success_message__c = 'Error';
                                if( MaxLeaseController.arrGuestCardsResponse.get( CaseNumber ).containsKey( 'Message' ) ) {
                                    cs.integration_fail_success_message__c = MaxLeaseController.arrGuestCardsResponse.get( CaseNumber ).get( 'Message' );
                                }
                            }
                        }
                        
                        if( MaxLeaseController.arrGuestCardsResponse.get( CaseNumber ).containsKey( 'RentalStatId' ) ) { 
                            cs.Yardi_Guest_Card_ID__c = MaxLeaseController.arrGuestCardsResponse.get( CaseNumber ).get( 'RentalStatId' );
                            if( null != cs.ContactId && !ContactIds.contains( cs.ContactId ) ) {
                                Contact c = new Contact();
                                c.Prospect_ID__c = MaxLeaseController.arrGuestCardsResponse.get( CaseNumber ).get( 'RentalStatId' );
                                c.Id = cs.ContactId;
                                contacts.add(c); 
                                ContactIds.add(cs.ContactId );
                            }
                        }
                        arrobjCases.add( cs );
                    }                
                }
                
                upsert arrobjCases;
                
                if( !contacts.isEmpty() )
					upsert contacts;
                
            } catch( Exception e ) {
                System.debug( e.getMessage() );
                System.debug( e.getStackTraceString() );
            }
            
        }
    }

    global void finish( Database.BatchableContext info ){
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