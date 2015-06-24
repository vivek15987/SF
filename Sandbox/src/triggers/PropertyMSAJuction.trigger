trigger PropertyMSAJuction on Property__c (before insert, before Update){
 /* for (Property__c p:trigger.new)
{
    if (p.Account_MSA_Junction__c==null)
    {
        if(p.Group_Membership1__c !=null)
        {
            List<Account_MSA_Connection__c> amc=[Select Id,Name,Account1__c,MSA1__c from Account_MSA_Connection__c where Account1__c=:p.Account1__c and MSA1__c=:p.MSA__c and Group__c=:p.Group_Membership1__c];
            for(Account_MSA_Connection__c am:amc)
            {
                p.Account_MSA_Junction__c=am.Id;
            }
        }
        else
        {
            List<Account_MSA_Connection__c> amc=[Select Id,Name,Account1__c,MSA1__c from Account_MSA_Connection__c where Account1__c=:p.Account1__c and MSA1__c=:p.MSA__c];
            for(Account_MSA_Connection__c am:amc)
            {
                p.Account_MSA_Junction__c=am.Id;
            }
        }
    }
    
    //---Modified code start from here-----
    
    if(p.Group_Membership1__c=='CAH-FS(TEMP)')
    {
        p.Active__c='No';
        Account_MSA_Connection__c amc1=[Select Id from Account_MSA_Connection__c where Name='CAH-FS(TEMP)-NO-MSA'];
        p.Account_MSA_Junction__c=amc1.Id;       
    }
}*/
}



/*trigger PropertyMSAJuction on Property__c (before insert, before Update){
for (Property__c p:trigger.new)
{
 if (p.Account_MSA_Junction__c==null)
  {
if(p.Group_Membership1__c !=null)
{
List<Account_MSA_Connection__c> amc=[Select Id,Name,Account1__c,MSA1__c from Account_MSA_Connection__c where Account1__c=:p.Account1__c and MSA1__c=:p.MSA__c and Group__c=:p.Group_Membership1__c];
for(Account_MSA_Connection__c am:amc)
{
p.Account_MSA_Junction__c=am.Id;
}
}
else
{
List<Account_MSA_Connection__c> amc=[Select Id,Name,Account1__c,MSA1__c from Account_MSA_Connection__c where Account1__c=:p.Account1__c and MSA1__c=:p.MSA__c];
for(Account_MSA_Connection__c am:amc)
{
p.Account_MSA_Junction__c=am.Id;
}
}
}
}
}*/