global class WorkOrderDailyEdit Implements Schedulable
{                       
global void execute(SchedulableContext sc)
{
UpdateDailyEdit();
}
public void UpdateDailyEdit()
{
List<Work_Order_Dispatch__c> wod=[Select Id,Name,Daily_Edit__c from Work_Order_Dispatch__c ];
for(Work_Order_Dispatch__c w:wod)
{
w.Daily_Edit__c=True;
update w;
}
}                            
                            
}