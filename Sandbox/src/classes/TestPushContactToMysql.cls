@isTest
public class TestPushContactToMysql {
	static testMethod void createcase() {
		Account a = new Account();
       	a.Name = 'Test Account';
       	insert a;
        
        Contact c = new Contact();
        c.FirstName = 'Test6';
        c.LastName = 'Test6';
        c.AccountId = a.Id;        
        c.Anyone_Home_Type__c = 'Agent';
        c.MobilePhone = '11111';
        c.Email = 'aaaaaa@s.com';
        c.Phone	= '222';
        insert c;
    }
}