@isTest
private class Test_WorkOrderDailyEdit {
static testMethod void testScheDailyEdit()
{
Test.startTest();
Account a = new Account();
a.Name='Test Account';
a.Phone='2130456';
a.Type='Test Tyep';
insert a;

MSA__c msa=new MSA__c();
msa.Name='Test ma';
msa.County_Number__c=decimal.valueof('456');
msa.MSA_No__c='msan';
msa.State__c='sss';
insert msa; 

Work_Order_Dispatch__c w=new Work_Order_Dispatch__c();
w.Name='Test';
w.Account__c=a.Id;
w.Emergency_Classification__c='Test Class';
w.MSA__c=msa.Id;
w.Daily_Edit__c=Boolean.valueof('True');
insert w;

WorkOrderDailyEdit wod=new WorkOrderDailyEdit(); 
wod.execute(null);
wod.UpdateDailyEdit();

}
}