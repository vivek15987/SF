trigger pushNotifyNewlyCreatedMessages on Communication__c (after insert) {
	Communication__c c = trigger.new[0];
    
    if ( true == c.Replied_By_Prospect__c ) {
        String authKey = '3197438ab902e4441134';
        String authSecret = 'f33564a5699c3102cf51';
        String appId = '109299';
        
        List<Contact> lstContact =[ Select 
                                         Name
                                    FROM 
                                         Contact
                                    WHERE 
                                         Id =: c.Prospect__c];
        Map<String,String> message = new Map<String,String>{
            'id' => c.Id,
            'agent_id' => c.Agent__c,
            'prospect' => lstContact[0].Name,
            'type' => c.Type__c,
            'subject' => c.Subject__c
        };
        
        Pusher.push( authKey, authSecret, appId, 'communication', 'new_message', JSON.serialize(message));
    }
}