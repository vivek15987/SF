global class Update_Appointment_Invite_Status implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String status='Invited';
        String query ='SELECT Id,Name,Invite_Status__c,CanceledRejected_By__c,Createddate,Number_of_Hours_Before_Auto_Reject__c from Appointment__c where Auto_Reject_Showings__c=True and Invite_Status__c=:status';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Appointment__c> scope)
    {
        List <Appointment__c> apoin = new list<Appointment__c>();
        for(Appointment__c a : scope)
        {
            Double timelaps = Math.Floor(Double.valueOf((datetime.Now().getTime() - a.Createddate.getTime())/ (1000*60*60)));
            if(timelaps >=a.Number_of_Hours_Before_Auto_Reject__c) 
            {
                a.Invite_Status__c='Rejected';
                a.CanceledRejected_By__c='Automated System (invite expired)';
                apoin.add(a);
            } 
        }
        ProcessorControl.inFutureContext = true;
        update apoin;
    }
    global void finish(Database.BatchableContext BC)
    {
    }
}