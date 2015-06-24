@isTest
 private class Test_updateagentemail {
 static testMethod void UnitTestagentemail()
 {   
 Appointment__c A = new Appointment__c();
 A.Invite_Status__c ='Invited';
 A.Email__c='Email@gmail.com'; 
 A.Agent_Email__c='Email@gmail.com'; 
 A.Appointment_Date__c=Date.Parse('7/12/2013');
 insert A;
 
 Case c=new Case(); 
 c.Status='Test';
 insert c;
 
 Appointment__c A1 = new Appointment__c();
 A1.Case__C =c.Id;
 A1.Invite_Status__c ='Invited';
 A1.Email__c='Email@gmail.com'; 
 A1.Agent_Email__c='Email@gmail.com'; 
 A1.Appointment_Date__c=Date.Parse('7/12/2013');
 insert A1;
 
 List<Case> CaseList = [select Id, Agent_Email_Address__c From Case Where Id=:A1.Case__C];
for (Case cc: CaseList)
{
cc.Agent_Email_Address__c=A1.Agent_Email__c;
update cc;
}
Test.startTest();
Test.stopTest();
 }
 }