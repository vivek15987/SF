trigger updateagentemail on Appointment__c (after insert,after update)
{
    Appointment__c a= trigger.new[0];
    if(a.Agent_Email__c != null && a.Case__c != null){
        List<Case> CaseList = [select Id, Agent_Email_Address__c From Case Where Id=:a.Case__c LIMIT 1];
        if(CaseList.size() > 0){
            for (Case cc: CaseList)
            {
                cc.Agent_Email_Address__c=a.Agent_Email__c;
                
            }
            Update CaseList;
        } 
    } 
}