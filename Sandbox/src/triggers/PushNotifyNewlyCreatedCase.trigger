trigger PushNotifyNewlyCreatedCase on Case (after insert, after update) {
	Case c = trigger.new[0];
    Case c_old = new Case();

    if ( false == c.Agent_Created_via_ShowPro__c ) {
        
        String callAnswered;
        String authKey = '3197438ab902e4441134';
        String authSecret = 'f33564a5699c3102cf51';
        String appId = '109299';
        
        if( true == c.IC_Call_Answered_by_AH__c ) {
            callAnswered = 'true';
        } else {
            callAnswered = 'false';
        }
        
        Map<String,String> message = new Map<String,String>{
            'id' => c.Id,
            'name' => c.ContactNameAPI__c,
            'contact_id' => c.ContactId,
            'property' => c.Property_Name__c,
            'IC_Call_Answered_by_AH__c' => callAnswered,
            'Guest_Card_Status__c' => c.Guest_Card_Status__c,
            'Origin' => c.Origin,
            'account_id' => c.AccountId,
            'property_id'=> c.Property_of_Interest__c
        };
        
        if( true == Trigger.IsInsert && ( ( callAnswered == 'true' && c.Guest_Card_Status__c == 'Sent via Workflow' ) || callAnswered == 'false' ) ) {
            Pusher.push( authKey, authSecret, appId, 'case', 'new_case', JSON.serialize(message));
        }
        
        if( true == Trigger.IsUpdate ) {
            c_old = trigger.old[0];
        }
        
        if( true == Trigger.IsUpdate && ( (c.IC_Call_Answered_by_AH__c != c_old.IC_Call_Answered_by_AH__c || c.Guest_Card_Status__c != c_old.Guest_Card_Status__c) && ( callAnswered == 'true' && c.Guest_Card_Status__c == 'Sent via Workflow' ) ) ) {
            if(Trigger.isBefore){
                if(HelperClass.firstRun){
                    Pusher.push( authKey, authSecret, appId, 'case', 'new_case', JSON.serialize(message));
                    HelperClass.firstRun = false;
                }
            }
        }
    }
}