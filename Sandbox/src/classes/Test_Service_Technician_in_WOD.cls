@isTest
private class Test_Service_Technician_in_WOD {
static testMethod void TestService_in_WOD()
{
Account a=new Account();
a.Name='Test';
insert a;

MSA__c mc=new MSA__c();
mc.Name='Test ma';
mc.County_Number__c=decimal.valueof('456');
mc.MSA_No__c='msan';
mc.State__c='sss';
insert mc;

Work_Order_Dispatch__c wd=new Work_Order_Dispatch__c();
wd.Name='Test WOD';
wd.Account__c=a.Id;
wd.MSA__c=mc.Id;
insert wd;

Service_Technician__c st= new Service_Technician__c();
st.Work_Order_Dispatch__c=wd.Id;
insert st;

Test.StartTest();
Test.StopTest();
}
}