@isTest
public class TestUpdatePropertybyGroup {
    @isTest static void updateproperty() {
       Test.startTest();
        Account a = new Account(Name ='Test');
        insert a;
               
         Property__c p = new Property__c(Name ='Testing',Account__c=a.id, Active__c = 'ýes', Price__c =1,Square_Footage__c = 1,Bed_Count__c =1, Bath_Count__c =1, Pet_Policy__c ='No',Lease_Terms__c = 1,Address_Line_1__c = 'Test', City__c ='Test', State__c='Test', Zip_Code__c ='1',Concurrent_Showings_Allowed__c= 'no', Default_Appointment_Length__c ='no', Default_Buffer_Before_Appointments__c ='no');
        insert p;
        
        Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;
        Test.stopTest();
    }
    
    @isTest static void updatepropertyelse() {
       Test.startTest();
        Account a = new Account(Name ='Test');
        insert a;
        
         Grouping__c g = new Grouping__c(Name = 'Testing',Account__c=a.id);
        insert g;
        
         Property__c p = new Property__c(Name ='Testing',Account__c=a.id, Active__c = 'ýes', Price__c =1,Square_Footage__c = 1,Bed_Count__c =1, Bath_Count__c =1, Pet_Policy__c ='No',Lease_Terms__c = 1,Address_Line_1__c = 'Test', City__c ='Test', State__c='Test', Zip_Code__c ='1',Concurrent_Showings_Allowed__c= 'no', Default_Appointment_Length__c ='no', Default_Buffer_Before_Appointments__c ='no');
        insert p;        
        Test.stopTest();
    }
}