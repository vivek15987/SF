trigger PushNotifyNewlyCreatedServiceRequest on Service_Request1__c (after insert, after update) {
    Service_Request1__c sr = trigger.new[0];
    Service_Request1__c sr_old = new Service_Request1__c();
    
    if ( false == sr.Created_by_ShowPro_User__c ) {
        String callAnswered;
        String authKey = '3197438ab902e4441134';
        String authSecret = 'f33564a5699c3102cf51';
        String appId = '109299';
        
        if( true == sr.IC_Call_Answered_by_AH__c ) {
            callAnswered = 'true';
        } else {
            callAnswered = 'false';
        }
        
        Map<String,String> message = new Map<String,String>{
            'id' => sr.Id,
            'name' => sr.Contact_Name_Text__c,
            'property' => sr.Property_Interest__c,
            'account_id' => sr.Account_Name__c,
            'property_id'=> sr.Property_of_Interest__c,
            'unit' => sr.Unit_Name__c,
            'status' => sr.Status__c,
            'IC_Call_Answered_by_AH__c' => callAnswered
        };
            
        if( true == Trigger.IsInsert && ( ( callAnswered == 'true' && sr.Status__c == 'Request Sent' ) || callAnswered == 'false' ) ) {
            Pusher.push( authKey, authSecret, appId, 'service_request', 'new_service_request', JSON.serialize(message));
        }
        
        if( true == Trigger.IsUpdate ) {
            sr_old = trigger.old[0];
        }
        
        if( true == Trigger.IsUpdate && ( (sr.IC_Call_Answered_by_AH__c != sr_old.IC_Call_Answered_by_AH__c || sr.Status__c != sr_old.Status__c) && ( callAnswered == 'true' && sr.Status__c == 'Request Sent' ) ) ) {
            if(Trigger.isBefore){
                if(HelperClass.firstRun){
                    Pusher.push( authKey, authSecret, appId, 'service_request', 'new_service_request', JSON.serialize(message));
                    HelperClass.firstRun = false;
                }
            }
        }
    }
}