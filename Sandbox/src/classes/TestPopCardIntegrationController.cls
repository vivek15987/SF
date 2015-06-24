@isTest
public class TestPopCardIntegrationController {

    static testMethod void testPopCardIntegration() {
        
        Account a 	= new Account();
        a.Name		= 'Test';
        insert a;

        Property__c p 					= new Property__c();
        p.Account__c 					= a.Id;
        p.Name							= 'Test Property';
        p.Enable_PopCard_Integration__c = true;
        insert p; 
        
        Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;
        
        Source__c source 		= new Source__c();
        source.Source_Type__c 	= 'Internet-Hotpads.com';
        source.Email__c 		= 'azdas@azfz.asds';
        source.Account__c 		= a.Id;
        source.Property__c 		= p.Id;
        insert source;
        
        Contact cnt 				= new Contact();
        cnt.FirstName				= 'Test';
        cnt.LastName 				= 'Testing';
        cnt.AccountId 				= a.Id;
        cnt.Email					= 'test@gmail.com';
        cnt.MailingStreet 			= 'MailingStreet';
        cnt.MailingCity 			= 'MailingCity';
        cnt.MailingState 			= 'MailingState';
        cnt.MailingCountry 			= 'MailingCountry';
        cnt.MailingPostalCode 		= '234123';
        cnt.OtherPhone 				= '1234567890';
        cnt.Phone 					= '1233241245';
        insert cnt;
       
        Contact cnct = new Contact();
        cnct.FirstName = 'Test1';
        cnct.LastName = 'Testing1';
        cnct.AccountId =  a.Id;
        insert cnct;
        
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
        c.Property_of_Interest__c = p.Id;
        c.Subject = 'Subject';
        c.Notes__c = 'Notes';
        c.Guest_Card_Status__c 			= 'Sent via Workflow';
        c.IC_Call_Answered_by_AH__c = true;
        c.Ad_Source2__c = source.Id;
        c.ContactId = cnt.Id;    
        insert c;     

        Appointment__c ap = new Appointment__c();
        ap.Case__c = c.Id;
        ap.From__c = '1:30 p.m.';
        ap.To__c = '3:00 p.m.';
        ap.Appointment_Date__c =  Date.today();
        ap.Invite_Status__c = 'Accepted';
        ap.Contact__c = cnct.Id;
        insert ap;
        
        Test.startTest();
        PopCardIntegrationScheduler scheduler = new PopCardIntegrationScheduler();
        System.schedule( 'PopCardIntegrationScheduler' , '0 0 * * * ?', new PopCardIntegrationScheduler( 2 ) );
        
        PopCardIntegrationBatch popcardBatch = new PopCardIntegrationBatch();
        Database.executeBatch( popcardBatch, 20 );
                
        Test.stopTest();

    }
    
}