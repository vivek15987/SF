@isTest
private class Test_Update_Appointment_Invite_Status {
static testMethod void test_apexbatch()
{
Account a = new Account();
a.Name='Test Account';
a.Phone='2130456';
a.Type='Test Tyep';
a.Auto_Reject_Showings__c=true;
a.Number_of_Hours_Before_Auto_Reject__c=24;
insert a;

Case c=new Case();
c.Status='Test';
c.AccountId=a.Id;
insert c;

List <Appointment__c> apoin = new list<Appointment__c>();
Appointment__c ap=new Appointment__c();
ap.Case__c=c.Id;
ap.Invite_Status__c='Invited';
ap.Appointment_Date__c=Date.parse('12/07/2014');
apoin.add(ap);
insert apoin;
 
Update_Appointment_Invite_Status ua = new Update_Appointment_Invite_Status();
Database.executeBatch(ua);
ua.start(null); 
//ua.execute(null,apoin);
ua.finish(null);      
}
}