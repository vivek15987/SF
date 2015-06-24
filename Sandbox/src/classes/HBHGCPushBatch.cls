global class HBHGCPushBatch implements Database.Batchable<Case>, Database.AllowsCallouts {
    public List<Case> arrobjCases 			= new List<Case>();
    
    public HBHGCPushBatch() {}
    
    global Iterable<Case> start(Database.BatchableContext BC) {
        String strSql = 'SELECT Id, CaseNumber, Property_of_Interest__r.HBH_Prop_Id__c, ContactId FROM Case WHERE GC_Entered__c = false AND Guest_Card_Status__c = \'Sent via Workflow\' AND Integration_Failed__c = false AND Property_of_Interest__r.HBH_Prop_Id__c != null AND LastModifiedDate = LAST_N_DAYS:5';
        
        if( !Test.isRunningTest() ) {
            strSql += ' AND AccountId = \'001i000000Aj5Kn\'';
        }
        strSql += ' ORDER BY LastModifiedDate DESC';
        
        arrobjCases = (List<Case>) Database.query( strSql );
        /*arrobjCases = [ SELECT 
        Id, CaseNumber, Property_of_Interest__r.HBH_Prop_Id__c, ContactId 
        FROM 
        Case
        WHERE 
        GC_Entered__c = false 
        AND Guest_Card_Status__c = 'Sent via Workflow'
        AND Integration_Failed__c = false 
        AND Property_of_Interest__r.HBH_Prop_Id__c != null 
        AND LastModifiedDate = LAST_N_DAYS:5
        AND AccountId = '001i000000Aj5Kn'
        //AND Account1__c  = 'Nano Account'
        ORDER BY 
        LastModifiedDate DESC
        ];*/
        
        return arrobjCases;
    }
    
    global void execute(Database.BatchableContext BC, List<Case> Cases){
        Set<ID> CaseIds			= new Set<ID>();
        
        for( Case objCase : Cases )	{
            CaseIds.add( objCase.Id );
        }	
        
        HBHGCPushController HBH = new HBHGCPushController();
        HBH.CaseIds = CaseIds;
        HBH.pushGuestCards();
        System.debug( HBH.strResponse );
        if( !HBH.arrGuestCardsResponse.isEmpty() ) {
            try {
                List<case> arrobjCases = new List<Case>();
                Set<String> ContactIds = new Set<String>();
                List<Contact> contacts = new List<Contact>();
                for( Case cs : Cases ) {
                    Integer CaseNumber = ( !Test.isRunningTest() ) ? Integer.valueOf( cs.CaseNumber ) : 831765;
                    
                    if( HBH.arrGuestCardsResponse.containsKey( CaseNumber ) ) {
                        if( HBH.arrGuestCardsResponse.get( CaseNumber ).containsKey( 'Status' ) ) {
                            if( 'Success' == HBH.arrGuestCardsResponse.get( CaseNumber ).get( 'Status' ) ) {
                                if( true == HBH.NeedToupdateAppointmentsPerCase.containsKey( CaseNumber ) && NULL != HBH.NeedToupdateAppointmentsPerCase.get( CaseNumber ) ){
                                   update HBH.NeedToupdateAppointmentsPerCase.get( CaseNumber ); 
                                }
                                cs.GC_Entered__c = true;
                                cs.Is_First_Contact_Entered__c = true;
                                cs.integration_fail_success_message__c = 'Success';
                            } else if( 'Error' == HBH.arrGuestCardsResponse.get( CaseNumber ).get( 'Status' ) ) {
                                cs.GC_Entered__c = false;
                                cs.Integration_Failed__c =  true;
                                cs.integration_fail_success_message__c = 'Error';
                                if( HBH.arrGuestCardsResponse.get( CaseNumber ).containsKey( 'Message' ) ) {
                                    cs.integration_fail_success_message__c = HBH.arrGuestCardsResponse.get( CaseNumber ).get( 'Message' );
                                }
                            }
                        }
                        
                        if( HBH.arrGuestCardsResponse.get( CaseNumber ).containsKey( 'RentalStatId' ) ) { 
                            cs.Yardi_Guest_Card_ID__c = HBH.arrGuestCardsResponse.get( CaseNumber ).get( 'RentalStatId' );
                            if( null != cs.ContactId && !ContactIds.contains( cs.ContactId ) ) {
                                Contact c = new Contact();
                                c.Prospect_ID__c = HBH.arrGuestCardsResponse.get( CaseNumber ).get( 'RentalStatId' );
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

    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
    
}