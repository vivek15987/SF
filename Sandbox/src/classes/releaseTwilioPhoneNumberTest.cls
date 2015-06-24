@isTest(SeeAllData=true) 
public class releaseTwilioPhoneNumberTest {
	public static String CRON_EXP = '0 0 0 3 9 ? 2022';
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
         c.Enable_SMS_for_ShowPro__c = true;
         c.Twilio_Number_SID__c = 'test';
        
         insert c;
        
         Contact c1 = new Contact();
         c1.Id = c.Id;
         c1.Enable_SMS_for_ShowPro__c = false;
         update c1;
        
        Test.stopTest();
     }
}