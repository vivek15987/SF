trigger UpdatePopCardIntegrationToEnable on Account (after insert,after update) {
   
    //Apex Trigger for PopCard Mass Edit Setting from Account
    
    Account a = trigger.new[0]; 
   
    List<Property__c> props = [SELECT Name,Enable_PopCard_Integration__c FROM Property__c WHERE Account__c =:a.Id];
    
    for(Property__c p:props) {               
        if( true == a.Enable_PopCard_Integration__c ) {
            p.Enable_PopCard_Integration__c = true;           
        } else {            
            p.Enable_PopCard_Integration__c = false;       
        }        
        update p;
    }
}