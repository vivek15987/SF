trigger releaseTwilioPhoneNumber on Contact (after update) {
	Contact c = trigger.old[0];
    Contact c1 = trigger.new[0];
      
    if( c1.Enable_SMS_for_ShowPro__c != c.Enable_SMS_for_ShowPro__c && false == c1.Enable_SMS_for_ShowPro__c && NULL != c1.Twilio_Number_SID__c ) {
        Twilio.send( c1.Twilio_Number_SID__c, c1.Id );
    }   
}