@isTest(SeeAllData=true)
public class updateAssignLeadToAgent {
	static testMethod void validateupdateAssignLeadToAgent() {
         Account a=new Account();
         a.Name ='TEST';
         a.Phone='9999999';
         a.Type='Test ABC';
         insert a;
        
         Property__c p = new Property__c();
         p.Account__c = a.Id;
         insert p;
         
         Contact c = new Contact();
         c.FirstName = ' TEST PQR';
         c.LastName = 'User';
         c.AccountId = a.Id;
         insert c;
        
         Contact Agent = new Contact();
         Agent.FirstName = ' TEST agent';
         Agent.LastName = 'User';
         Agent.AccountId = a.Id;
         insert Agent;
        
         Case ca = new Case();
         ca.AccountId = a.Id;
         ca.ContactId = c.Id;
         ca.Status = 'Inquiry';
         ca.Property_of_Interest__c = p.Id;
  		 ca.Bed_Count_Pref__c = '2';
         ca.Bath_Count_Pref__c = '1'; 
         ca.Desired_Rent_Start__c = 1000;
         ca.Desired_Rent_Range_End__c = 1200;
         ca.Desired_Lease_length__c = 10;
         ca.Pet_Type__c = 'Dog';
         ca.Pet_Name__c = 'Bullet';
         ca.Pet_Count__c = 3;
         ca.Of_Occupants__c = 3;
         ca.Affordable_Inquiry__c = 'Yes';
         ca.Realtor_Inquiry__c = true;
         ca.Reasons_For_Not_Setting_a_Showing__c = 'Other';
         ca.Reason_for_Moving__c = 'Closer to work';
         ca.Realtor_Name__c = 'Re';
         ca.Notes__c = 'This is test run';
         ca.Breed__c = 'Dog';
         insert ca;
        
         Appointment__c app = new Appointment__c();
         app.Case__c = ca.Id;
         app.Contact__c = Agent.Id;
         Date d = Date.newInstance(2015, 01, 03);
    	 app.Appointment_Date__c = d;
         insert app;
        
         Test.startTest();
  		 Test.stopTest(); 

     }
}