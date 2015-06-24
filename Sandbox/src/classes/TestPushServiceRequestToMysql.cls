@isTest
public class TestPushServiceRequestToMysql {
	static testMethod void createsr() {
		Account a = new Account();
       	a.Name = 'Test Account';
       	insert a;
        
        Contact c1 = new Contact();
        c1.FirstName = 'Test6';
        c1.LastName = 'Test6';
        c1.AccountId = a.Id;        
        c1.Anyone_Home_Type__c = 'Agent';
        c1.MobilePhone = '11111';
        c1.Email = 'aaaaaa@s.com';
        c1.Phone	= '222';
        insert c1;
        
        Service_Request1__c s = new Service_Request1__c();
        s.Account_Name__c = a.Id;
        s.Status__c = 'In Progress';
        s.Case_Origin__c = 'Email';
        insert s;
    }
}