trigger UpdateWorkOrder on Service_Request1__c (before insert,before update) {
Service_Request1__c s = trigger.new[0];
If(s.Property_Of_Interest_Market__c != '' && s.Account__c != '' && s.Request_Category__c != '' && s.Request_Classification_LU__c != '')
{
List<Work_Order_Dispatch__c> wo=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Emergency_Classification__c from Work_Order_Dispatch__c];
for(Work_Order_Dispatch__c w:wo)
{
if(w.Account_Name__c==s.Account__c && w.MSA_Name__c==s.Property_Of_Interest_Market__c && w.Request_Category1__c==s.Request_Category__c && w.Emergency_Classification__c==s.Request_Classification_LU__c)
{
s.Work_Order_Dispatch__c=w.Id;
}
else if(w.Account_Name__c==s.Account__c && w.MSA_Name__c==s.Property_Of_Interest_Market__c && w.Request_Category1__c==s.Request_Category__c && w.Emergency_Classification__c=='All Requests')
{
s.Work_Order_Dispatch__c=w.Id;
}
else
{
}
}
}
}