@isTest
private class Test_updatecase {
static testMethod void testupdatecase(){  

Account aa =new Account();
aa.Name='Test';
insert aa;
 
Property__c p1 = new Property__c();
p1.Active__c ='Yes';
p1.Account__c=aa.Id;
p1.Name='Test';
insert p1;

Unit__c u=new unit__c();
u.Name='Test';
u.Property__c=p1.Id;
u.Account__c=aa.Id;
insert u;
 
Case c = new Case();
c.Status='Showing Set';
c.Origin='Email';  
c.Appointment_1_ID__c='';
c.Appointment_1_Unit_ID__c='';
c.Appointment_2_ID__c='';
c.Appointment_2_Unit_ID__c='';
c.Appointment_3_ID__c='';
c.Appointment_3_Unit_ID__c='';
insert c;

/*Case c1 = new Case();
c1.Status='Showing Set';
c1.Origin='Email';  

insert c1;

Case c2 = new Case();
c2.Status='Showing Set';
c2.Origin='Email';  
c2.Appointment_2_ID__c='';
c2.Appointment_2_Unit_ID__c='';
insert c2;*/

Appointment__c a = new Appointment__c();
a.Invite_Status__c ='Invited';
a.Email__c='Email@gmail.com'; 
a.Unit__c=u.Id; 
a.Property__c=p1.Id; 
a.Case__c = c.Id;
a.Appointment_Date__c =system.today();  
insert a;

Appointment__c a1 = new Appointment__c();
a1.Invite_Status__c ='Invited';
a1.Email__c='Email@gmail.com';  
a1.Property__c=p1.Id; 
a1.Unit__c=u.Id; 
a1.Case__c = c.Id;
a1.Appointment_Date__c =system.today();  
insert a1;

Appointment__c a2 = new Appointment__c();
a2.Invite_Status__c ='Invited';
a2.Email__c='Email@gmail.com';  
a2.Property__c=p1.Id; 
a2.Unit__c=u.Id; 
a2.Case__c = c.Id;
a2.Appointment_Date__c =system.today();  
insert a2;

/*Appointment__c a3 = new Appointment__c();
a3.Invite_Status__c ='Invited';
a3.Email__c='Email@gmail.com'; 
a3.Property__c=p1.Id; 
a3.Unit__c=u.Id; 
a3.Case__c = c.Id;
a3.Appointment_Date__c =system.today();  
insert a3;*/


/*Appointment__c a4 = new Appointment__c();
a4.Invite_Status__c ='Invited';
a4.Email__c='Email@gmail.com';  
a4.Property__c=p1.Id; 
//a4.Case__c = c1.Id;
a4.Appointment_Date__c =system.today();  
insert a4;

Appointment__c a5 = new Appointment__c();
a5.Invite_Status__c ='Invited';
a5.Email__c='Email@gmail.com';  
a5.Property__c=p1.Id; 
//a5.Case__c = c.Id;
a5.Appointment_Date__c =system.today();  
insert a5;*/

Test.startTest();
Test.stopTest();
}
}