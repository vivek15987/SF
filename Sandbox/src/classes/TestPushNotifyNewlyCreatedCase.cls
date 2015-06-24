@isTest
public class TestPushNotifyNewlyCreatedCase {
	static testMethod void createcase() {
        
        Account a = new Account();
       	a.Name = 'Test Account';
       	insert a;
        
        Property__c p1 = new Property__c();
        p1.Name = 'New Property';
        p1.Account__c = a.id;
        p1.Address_Line_1__c = 'AAAAAAAAA';
        p1.City__c = 'Pune';
        p1.State__c = ' MH';
        p1.Zip_Code__c = '411013';
        p1.PSI_Prop_ID__c = '104143';
       	insert p1;
        
        Contact c = new Contact();
        c.FirstName = 'Test6';
        c.LastName = 'Test6';
        c.AccountId = a.Id;        
        c.Anyone_Home_Type__c = 'Agent';
        c.MobilePhone = '11111';
        c.Email = 'aaaaaa@s.com';
        c.Phone	= '222';
        insert c;
        
        Case cs = new Case();
        cs.ContactId = c.Id;
        cs.Origin = 'Email';
       	cs.Move_in_Date__c = date.today();
        cs.Date_Time_Sent_Via_Workflow__c = date.today();
        cs.Guest_Card_Status__c = 'Sent via Workflow';
        cs.Integration_Failed__c = false;
        cs.Property_of_Interest__c = p1.Id;
        cs.GC_Entered__c = false;
        cs.Desired_Rent_Start__c = 2;
        cs.Desired_Lease_length__c = 2;
        cs.Notes__c = 'Hello Hi iiiiii ';
        cs.Of_Occupants__c = 2;
        insert cs;
    }
}