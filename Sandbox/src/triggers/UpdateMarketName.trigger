trigger UpdateMarketName on Case (before insert,before update) 
{
Case c= trigger.new[0];
if(c.Account1__c!='' && c.Property_of_Interest1__c!='' && c.Property_Of_Interest_MSA__c!='' )
{
List<Account_MSA_Connection__c> amc=[Select Id,Name,Account1__c,MSA1__c from Account_MSA_Connection__c 
                                     where Account1__c=:c.Account1__c and MSA1__c=:c.Property_Of_Interest_MSA__c];
                                     for(Account_MSA_Connection__c am:amc)
                                     {
                                     c.Account_MSA_Junction__c = am.Id;                                                                          
                                     }
}
}