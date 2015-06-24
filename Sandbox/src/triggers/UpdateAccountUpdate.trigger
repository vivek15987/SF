trigger UpdateAccountUpdate on Property__c (after insert, after update) 
{
    Set<id>accId=new Set<id>();
    List<Account> accs=new List<Account>();
    for(Property__c u: Trigger.new)
    {
        if( !accId.contains( u.Account__c ) )
            accId.add( u.Account__c );
    }
    List<Account> acc=[SELECT Id,Manual_Updates_Required__c FROM Account WHERE Id IN :accId AND Manual_Updates_Required__c=True];
    List<Property__c> propList=[SELECT Id,Manual_Dedupe_Completed__c FROM Property__c WHERE Account__c IN:acc];
    for (Account uacc:acc){     
        if (propList.size()>0)
        {                        
            List <Datetime> dateList=new List<Datetime>();
            Datetime finalDate;
            for (Property__c p:propList)
            {
                dateList.add(p.Manual_Dedupe_Completed__c);
            }
            dateList.sort();
            finalDate=dateList.get(0);
            uacc.Last_Manual_Update_Completed__c=finalDate;
            accs.add(uacc);
        }                                 
    }
    update accs;
}