trigger TriggerEDCallout on Emergency_Dispatch__c (after insert) {  
        for (Emergency_Dispatch__c c : Trigger.new) {                   
                    String objectId = c.id;
                    if (!Test.isRunningTest())
                        {
                            //Execute the call
                            CalloutED.EDpost(objectId);
                        }
            }
}