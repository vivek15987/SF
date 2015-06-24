@isTest
private class Test_updateappointment {
static testMethod void MyUnitTestapp(){  
 
Property__c p1 = new Property__c();
p1.Active__c ='Yes';
p1.Name='Test';
p1.Address_Line_1__c='123 Text';
insert p1;
  
Appointment__c a = new Appointment__c();
a.Invite_Status__c ='Invited';
a.Email__c='Email@gmail.com';  
a.Property__c=p1.Id; 
a.Appointment_Date__c =system.today();  
insert a;
  
p1.Active__c='No';
p1.Address_Line_1__c='123 Test';
update p1; 
 
Case c1 = new Case();
c1.Status='new';
c1.Origin='Email';  
list<Case> caselist = new list < Case>();          
caselist.add(c1);
insert caselist;
update caselist; 
 
Appointment__c app = new Appointment__c();
app.Invite_Status__c ='Invited';
app.Email__c='Email@gmail.com';
app.Appointment_Date__c = system.today();
app.Case__c = c1.Id;
//list<Appointment__c> Aplist = new list <Appointment__c>();
//Aplist.add(app);  
insert app;
update app;
 
//Testing 
Test.startTest();
Test.stopTest();
}
}