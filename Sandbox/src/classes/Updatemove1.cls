public class Updatemove1 {

public Updatemove1(ApexPages.StandardController controller) {}

public PageReference specialoffer()
{
/*for(List<Move_in_Special__c> ms :[Select Id,Name,Account1__c,MSA1__c,Days_Vacant_End__c,Days_Vacant_Start__c,Special_Expiration__c,Special_Start_Date__c,Special_Trigger__c,
Move_in_Special_Description__c From Move_in_Special__c where Special_Start_Date__c <=today and Special_Expiration__c >=today])
{  
for(Move_in_Special__c m:ms) 
{                             
for(List<Property__c> p:[Select Id,Name,Account1__c,MSA__c,Days_on_Market__c,Active__c from Property__c where Active__c='Yes' and MSA__c !='']) 
{
for(Property__c pp:p)
{
if(m.Special_Trigger__c == 'Account' && pp.Account1__c==m.Account1__c &&  pp.Days_on_Market__c >=m.Days_Vacant_Start__c && pp.Days_on_Market__c <=m.Days_Vacant_End__c) 
{ 
pp.Move_in_Special1__c=m.Move_in_Special_Description__c;
update pp;    
}
else if(m.Special_Trigger__c == 'MSA' && pp.MSA__c==m.MSA1__c && pp.Account1__c==m.Account1__c &&  pp.Days_on_Market__c >=m.Days_Vacant_Start__c && pp.Days_on_Market__c <=m.Days_Vacant_End__c) 
{
pp.Move_in_Special1__c=m.Move_in_Special_Description__c;
update pp;  
}                                                                    
} 
}
}
}
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Update Successfully!'));  */                        
return null;
}
}