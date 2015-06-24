trigger Service_Technician_in_WOD on Service_Technician__c (after insert, after update)
{
Service_Technician__c st=trigger.New[0];
    List<Work_Order_Dispatch__c> wod=[Select Id, Name from Work_Order_Dispatch__c where Id=:st.Work_Order_Dispatch__c];
    for(Work_Order_Dispatch__c wd:wod)
    {
        wd.Service_Technician__c=st.Id;
        update wd;
    }
}