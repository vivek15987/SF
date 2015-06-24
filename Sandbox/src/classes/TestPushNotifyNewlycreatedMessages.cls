@isTest
public class TestPushNotifyNewlycreatedMessages {
	static testMethod void createcase() {
        
        Account a = new Account();
       	a.Name = 'Test Account';
       	insert a;
        
        Contact c = new Contact();
        c.FirstName = 'Test6';
        c.LastName = 'Test6';
        c.AccountId = a.Id;        
        c.Anyone_Home_Type__c = 'Guest';
        c.MobilePhone = '11111';
        c.Email = 'aaaaaa@s.com';
        c.Phone	= '222';
        insert c;
        
		Contact c1 = new Contact();
        c1.FirstName = 'Agent';
        c1.LastName = 'Test6';
        c1.AccountId = a.Id;        
        c1.Anyone_Home_Type__c = 'Agent';
        c1.MobilePhone = '11111';
        c1.Email = 'aaaaaa@s.com';
        c1.Phone	= '222';
        insert c1;
		
       	Communication__c co = new Communication__c();
        co.Prospect__c = c.Id;
        co.Agent__c = c1.Id;
        co.Type__c = 'Email';
        co.Subject__c = 'Test';
        co.Replied_By_Prospect__c = true;
        insert co;
    }
}