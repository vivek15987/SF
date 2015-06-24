trigger Fill_FloorPlan_and_Unit on Appointment__c (before insert,before update)
{
    Appointment__c app=trigger.New[0];
    List<Case> c1=[Select Id,MSA_Email_3__c,MSA_Email_4__c,Floor_Plan_of_Interest__r.Name,Unit_of_Interest__r.Name from Case where Id=:app.Case__c LIMIT 1];
    for(Case c:c1)
    {
        app.Floorplan_of_Interest_1__c=c.Floor_Plan_of_Interest__r.Name;
        app.Unit_of_Interest_1__c=c.Unit_of_Interest__r.Name;
       // app.Unit_of_Interest_2__c=c.Unit_of_Interest_2__r.Name;
        app.MSA_Email_3__c=c.MSA_Email_3__c;
        app.MSA_Email_4__c=c.MSA_Email_4__c;
    }
   
}