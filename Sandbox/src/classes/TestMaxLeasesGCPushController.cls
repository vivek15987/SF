@isTest
public class TestMaxLeasesGCPushController {

    static testMethod void testHBHgcpushcontroller() {

        Account a = new Account();
        a.Name	= 'Test Account';
        insert a;

        Property__c p 						= new Property__c();
        p.Account__c 						= a.Id;
        p.Max_Lease_Property_Id__c			= '1234';
        p.Address_Line_1__c 				= 'AAAAAAAAA';
        p.City__c 							= 'Pune';
        p.State__c 							= ' MH';
        p.Zip_Code__c 						= '411013';
        insert p;
        
        Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;

        Source__c sc = new Source__c();
       	sc.Account__c = a.id;
       	sc.Property__c = p.Id;       
       	sc.Customer_Service_Source__c = true;
       	sc.Source_Type__c = 'Rent.com';
       	insert sc;
        
        Unit__c unit = new Unit__c();
        unit.Account__c = a.id;
       	unit.Property__c = p.Id;   
        unit.Unit_ID__c = '100';
        insert unit;
        
        Contact c1 							= new Contact();
        c1.FirstName						= 'Test';
        c1.LastName 						= 'Testing';
        c1.AccountId 						= a.Id;
        c1.Email							= 'test@gmail.com';
        c1.MobilePhone						= '1911';
        c1.Anyone_Home_Type__c 				= 'Agent';
        c1.LeadSource 						= 'Other';
        c1.ShowPro_User__c 					= false;
        insert c1;
        
        Case cs = new Case();
        cs.GC_Entered__c 					= false;
        cs.AccountId						= a.Id;
        cs.ContactId						= c1.Id;
        cs.Property_of_Interest__c			= p.Id;
        cs.Origin 							= 'Email';
       	cs.Move_in_Date__c 					= date.today();
        cs.Date_Time_Sent_Via_Workflow__c 	= date.today();
       	cs.Ad_Source2__c 					= sc.Id;
        cs.Guest_Card_Status__c 			= 'Sent via Workflow';
        cs.Desired_Rent_Start__c 			= 2;
        cs.Desired_Lease_length__c 			= 2;
        cs.Bed_Count_Pref__c 				= '2';
        cs.Notes__c 						= 'Test Notes';
        cs.Desired_Rent_Range_End__c 		= 2.0;
        cs.Unit_of_Interest__c 				= unit.Id;
        cs.Multi_Family_Case__c 			= true;
        cs.Integration_Failed__c 			= false;
        insert cs;

        Appointment__c app = new Appointment__c();
        app.Appointment_Date__c = Date.today();
        app.From__c = '10:00 a.m.';
        app.Is_Event_Synced__c = false;
        app.Case__c = cs.Id;
        app.Unit__c = unit.Id;
        Insert app;

        Integration__c I = new Integration__c();
        I.MaxLeases_Integration_Active__c = true;
 		I.MaxLeases_Push_Guest_Card__c = true;
        I.MaxLease_API_URL__c = 'testURL';
        I.Name = 'Test Integrations';
        I.Account__c = a.Id;
        insert I;
        
        Integration__c I1 = new Integration__c();
        I1.Grouping__c = g.Id;
        I1.MaxLeases_Integration_Active__c = true;
 		I1.MaxLeases_Push_Guest_Card__c = true;
        I1.MaxLease_API_URL__c = 'testURL';
        I1.Name = 'Test Integrations';
        I1.Account__c = a.Id;
        insert I1;
        
        test.startTest();
     /*   MaxLeasesGCPushController cntrol1 = new MaxLeasesGCPushController();
        cntrol1.CaseIds.add( cs.Id );
        cntrol1.pushGuestCards();*/
        
        MaxLeasesGCPushBatch GCPushBatch1 = new MaxLeasesGCPushBatch();
        MaxLeasesGCPushBatch ObjBatch = new MaxLeasesGCPushBatch();
        Database.executeBatch( ObjBatch, 30 ); 

        System.schedule( 'MaxLeasesGCPushScheduler', '00 23 14 03 02 ?', new MaxLeasesGCPushScheduler( 2 ) );
        
        
        
        test.stopTest();
    }
}