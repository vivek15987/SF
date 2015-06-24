@isTest
public class TestPushCaseToMysql {
	static testMethod void createcase() {
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
        
        Case c = new Case();
        c.Bath_Count_Pref__c = '2';
        c.Bed_Count_Pref__c = '2';
        c.Created_Date_and_Time__c =  date.today();
        c.Description = 'Description';
        c.Desired_Rent_Range_End__c = 3.0; 
        c.Desired_Rent_Start__c = 2.0;
        c.Email_Content__c = 'Email Content';
        c.Move_in_Date__c = date.today();
        c.Of_Occupants__c = 4;
        c.Origin = 'Email';
        c.Pet_Count_Other__c = 2;
        c.Pop_Card_Entered_in_PMS__c = FALSE;
        c.Subject = 'Subject';
        c.Notes__c = 'Notes';
        c.Guest_Card_Status__c 	= 'Sent via Workflow';
        c.Agent_Created_via_ShowPro__c = false;
        c.ContactId = c1.Id;    
        insert c;     
    }
}