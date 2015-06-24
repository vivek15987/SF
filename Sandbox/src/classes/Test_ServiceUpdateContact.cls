@isTest
private class Test_ServiceUpdateContact {
static testMethod void MyTestService()
{ 
Account a=new Account();
a.Name ='Test';
a.Phone='2130456';
a.Type='Test Tyep';
insert a;

MSA__c mc=new MSA__c();
mc.Name='Test ma';
mc.County_Number__c=decimal.valueof('456');
mc.MSA_No__c='msan';
mc.State__c='sss';
insert mc;

Work_Order_Dispatch__c w= new Work_Order_Dispatch__c();
w.Name ='Test';
w.Account__c=a.Id;
w.MSA__c=mc.Id;
insert w;

Service_Request_Type__c sr=new Service_Request_Type__c();
sr.Name='service request';
sr.Repair_Category__c = 'Electrical';
sr.Request_Classification__c = 'Emergency';
sr.Account__c=a.Id;
insert sr;

Contact c=new Contact();
c.FirstName='Test Name'; 
c.LastName='Tst Last';
c.MobilePhone='21345684';
c.Email='manish@gmail.com';
insert c; 

Service_Request1__c s=new Service_Request1__c();
s.Contact_Name__c=c.Id;
s.Account_Name__c=a.Id;
s.Work_Order_Dispatch__c=w.Id;
s.Service_Request_Type__c=sr.Id;
s.Corrected_First_Name__c='Text';
s.Corrected_Last_Name__c='Test2';
s.Corrected_Mobile_Phone__c='22222';
s.Corrected_Email__c='test@gmail.com';
insert s;

Test.startTest();
Test.stopTest();
}
}