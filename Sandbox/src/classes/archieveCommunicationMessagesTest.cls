@isTest(SeeAllData=true) 
public class archieveCommunicationMessagesTest {
	static testMethod void validateAutoArchieveCommunicationMessages() {
         Test.startTest();
        
         Account a=new Account();
         a.Name ='TEST';
         a.Phone='9999999';
         a.Type='Test Rohan';
         insert a;
        
         Property__c p = new Property__c();
         p.Account__c = a.Id;
         insert p;
         
         Contact c = new Contact();
         c.FirstName = 'Rohan';
         c.LastName = 'Patil'; 
         c.AccountId = a.Id;
         c.Auto_Expire_Past_Due_Tasks__c = '2';
         insert c;
        
        Communication__c le = new Communication__c();
         le.Name = 'Communication 1';
         le.Agent__c = c.Id;       
         le.Date__c =  Date.today().addDays(-3);
         insert le;
        
         Contact c1 = new Contact();
          c1.Id = c.Id;
          c1.Auto_Archive_Read_Emails_After_Days__c = 10;
          update c1;
        
         Test.stopTest();

     }
}