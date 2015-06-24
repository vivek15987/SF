trigger upsertMarketNameOnCase on Case (before insert, before update) {
  
    list<Account_MSA_Connection__c> junctionObjList = [Select Name, Id, Account__c, MSA__c, MSA__r.Name from Account_MSA_Connection__c]; 
    map<String, Account_MSA_Connection__c> junctionObjMap = new map<String, Account_MSA_Connection__c>();
    for(Account_MSA_Connection__c msaObj: junctionObjList ){
        junctionObjMap.put(msaObj.MSA__r.Name, msaObj);
    }
    
    for(Case caseObj: Trigger.New){
       if(caseObj.Property_of_Interest__c != null){
           if(caseObj.Property_Of_Interest_MSA__c != null){
               if(caseObj.AccountID != null){
                   caseObj.Account_MSA_Junction__c = junctionObjMap.get(caseObj.Property_Of_Interest_MSA__c).id;      
                   system.debug(LoggingLevel.DEBUG,'Case, Final Output :' + caseObj.Account_MSA_Junction__c );           
               }
           }
       }
    }
}