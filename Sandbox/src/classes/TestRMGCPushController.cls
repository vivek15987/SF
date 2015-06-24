@isTest
public class TestRMGCPushController {

    static testMethod void testrmgcpushcontroller() {

        Account a = new Account();
        a.Name	= 'Test';
        insert a;

        Integration__c i 					= new Integration__c();	
        i.Account__c						= a.Id;
      	i.ResMan_API_URL__c					= 'www.test.com';
        i.ResMan_API_Key__c					= 'apiKey';
        i.ResMan_Integration_Active__c		= true;
        i.ResMan_Integration_Partner_ID__c	= '1234';
        i.Get_ResMan_Agent_Info__c			= 'Hourly';
        i.ResMan_Account_Id__c				= '1231';
        i.Push_Guest_Card_to_ResMan__c		= true;
        insert i;

        Grouping__c g = new Grouping__c();
        g.Account__c = a.Id;
        g.Name = 'Group A';
        insert g;
        
        MSA__c msa = new MSA__c();
        msa.State__c = 'AK';
        msa.MSA_No__c = '99002';
        msa.Name = 'AK NONMETROPOLITAN AREA';
        msa.County_Number__c = 16;
        insert msa;
        
        Property__c p 						= new Property__c();
        p.Account__c 						= a.Id;
        p.ResMan_Property_Id__c				= 'b342e58c-f5ba-4c63-b050-cf44439bb37d';
        p.Group_Membership__c 				= g.Id;
        p.Address_Line_1__c 				= 'AAAAAAAAA';
        p.City__c 							= 'Pune';
        p.State__c 							= ' MH';
        p.Zip_Code__c 						= '411013';
        insert p;

        Source__c sc = new Source__c();
       	sc.Account__c = a.id;
       	sc.Property__c = p.Id;       
       	sc.Customer_Service_Source__c = true;
       	sc.Source_Type__c = 'Rent.com';
       	insert sc;
        
        Floor_Plan__c fp = new Floor_Plan__c();
        fp.Account__c = a.id;
       	fp.Property__c = p.Id;   
        fp.Floorplan_ID__c = '100';
        insert fp;

        Unit__c unit = new Unit__c();
        unit.Account__c = a.id;
       	unit.Property__c = p.Id;   
        unit.Unit_ID__c = '100';
        unit.Floor_Plan__c = fp.Id;
        insert unit;
        
        Contact c1 							= new Contact();
        c1.FirstName						= 'Test';
        c1.LastName 						= 'Testing';
        c1.AccountId 						= a.Id;
        c1.Email							= 'test@gmail.com';
        //c1.MobilePhone						= '1911';
        c1.Phone							= '1231231231';
        c1.ResMan_Agent_Id__c 				= '4f937793-baf9-4a72-bcc3-3fd06653cecd';
        c1.Anyone_Home_Type__c 				= 'Agent';
        c1.LeadSource 						= 'Other';
        c1.ShowPro_User__c 					= false;
        insert c1;
        
        Case cs = new Case();
        cs.GC_Entered__c 			= false;
        cs.AccountId						= a.Id;
        cs.Yardi_Guest_Card_ID__c			= '4f937793-baf9-4a72-bcc3-3fd06653cecd';
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
        cs.Floor_Plan_of_Interest__c 		= fp.Id;
        cs.Desired_Rent_Range_End__c 		= 2.0;
        cs.Unit_of_Interest__c 				= unit.Id;
        cs.Multi_Family_Case__c 			= true;
        insert cs;
        
        Appointment__c ap = new Appointment__c();

        ap.Invite_Status__c = 'Accepted';
        ap.ResMan_Event_ID__c = 'TestId';
        ap.Unit__c = unit.Id;
        ap.Case__c = cs.Id;
        ap.Appointment_Date__c = date.today(); 
        ap.Comments__c = 'ssdfsdfsd';
        insert ap;
        
        Appointment__c ap1 = new Appointment__c();

        ap1.Invite_Status__c = 'Rejected';
        ap.ResMan_Event_ID__c = 'TestId';
        ap1.Unit__c = unit.Id;
        ap1.Case__c = cs.Id;
        ap1.Appointment_Date__c = date.today();  
        ap1.CanceledRejected_By__c = 'Prospect';
        ap1.Comments__c = 'ssdfsdfsd';
        insert ap1;

        test.startTest();
        RMGCPushController cntrol1 = new RMGCPushController();

        RMGCPushBatch GCPushBatch1 = new RMGCPushBatch();
        RMGCPushBatch ObjBatch = new RMGCPushBatch( false );

        RMGCPushScheduler scheduler13 = new RMGCPushScheduler(2);
        RMGCPushScheduler scheduler14 = new RMGCPushScheduler(2, false);
        
        System.schedule( 'RMGCPushScheduler', '00 23 14 03 02 ?', new RMGCPushScheduler( 2, false ) );
        
        
        Database.executeBatch( ObjBatch, 30 ); 
        test.stopTest();
    }
}