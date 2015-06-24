@isTest
public class TestUpadateAccountLastTaskEvent {
    private static List<Account> testAccountsList;
    static User sysAdminUser;
    private static User userdata;
    private static final Integer acct_cnt = 10;
    static {
        sysAdminUser = [select Id from User
                        where Profile.Name='System Administrator' and IsActive = true
                        limit 1];
    
        System.runAs(sysAdminUser) {
            userRole userroledata = new UserRole(Name = 'Test Executive');
            insert userroledata;
            
            Profile profiledata = [select Id FROM profile where name='System Administrator'];
            
            userdata = new User(alias = 'user1', userroleid = userroledata.Id, email='testroleuser@test.com', emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                localesidkey='en_US', profileid = profiledata.Id, country='United States',
                                timezonesidkey='America/Los_Angeles', username='testroleuser@test.com');
            
            insert userdata;
            system.debug('*** user data' +userdata);
        }
    }
    static testMethod void testUpadateAccountLastTaskEvent() {
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.Account_Manager__c = userdata.Id;
        insert a;
        
        Task task = new Task();
        task.WhatId = a.Id;
        task.OwnerId = userdata.Id;
        task.Status= 'In Progress';        
        insert task;
        
        Task task1 = new Task();
        task1.WhatId = a.Id;
        task1.OwnerId = userdata.Id;
        task1.Status= 'In Progress';        
        insert task1;
        
        task.Status = 'Completed';
        update task;
        
	}
}