@isTest 
public class TestYardiGCPushController {

    static testMethod void yardigcpush() {
        
        String InterfaceEntity = 'Anyone Home';
        String InterfaceLicense = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
        String YardiPropertyId = 'anyhome1';
        String FirstName = 'Test6';
        String LastName = 'Test6';
        String EmailAddress = '';
        String PhoneNumber = '';
        String ThirdPartyId = '00593290';
        String DateOfBirth = '';
        String FederalId = ''; 

        Test.startTest();

        Account a = new Account();
        a.Name = 'Colony American Homes';
        insert a;
        
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
      
        Property__c p1 = new Property__c();
        p1.Name = 'New Property';
        p1.Account__c = a.id;
        p1.Group_Membership__c = g.Id;
        p1.Customer_Prop_ID__c = 'abc';
        p1.Address_Line_1__c = 'AAAAAAAAA';
        p1.City__c = 'Pune';
        p1.State__c = ' MH';
        p1.Zip_Code__c = '411013';
        insert p1;
       
        Source__c sc = new Source__c();
        sc.Account__c = a.id;
        sc.Property__c = p1.Id;       
        sc.Customer_Service_Source__c = true;
        sc.Source_Type__c = 'Rent.com';
        insert sc;
               
        Contact c = new Contact();
        c.FirstName = 'Test6';
        c.LastName = 'Test6';
        c.AccountId = a.Id;        
        c.Anyone_Home_Type__c = 'Agent';
        c.MobilePhone = '11111';
        c.Email = 'aaaaaa@s.com';
        c.Phone = '222';
        c.Status__c = 'Showing Set';
        insert c;            
        
        Contact c1 = new Contact();
        c1.FirstName = 'Test6';
        c1.LastName = 'Test6';
        c1.AccountId = a.Id;        
        c1.Anyone_Home_Type__c = 'Agent';
        c1.MobilePhone = '11111';
        c1.Email = 'aaaaaa@s.com';
        c1.Phone    = '222';
        c1.Status__c = 'Showing Completed';
        insert c1;   
        
        Floor_Plan__c fp = new Floor_Plan__c();
        fp.Account__c = a.id;
        fp.Property__c = p1.Id;   
        fp.Floorplan_ID__c = '100';
        insert fp;

        Unit__c unit = new Unit__c();
        unit.Account__c = a.id;
        unit.Property__c = p1.Id;   
        unit.Unit_ID__c = '100';
        unit.Floor_Plan__c = fp.Id;
        insert unit;

        Case cs = new Case();
        cs.ContactId = c.Id;
        cs.Origin = 'Email';
        cs.Move_in_Date__c = date.today();
        cs.Date_Time_Sent_Via_Workflow__c = date.today();
        cs.Ad_Source2__c = sc.Id;
        cs.Guest_Card_Status__c = 'Sent via Workflow';
        cs.Integration_Failed__c = false;
        cs.Property_of_Interest__c = p1.Id;
        cs.GC_Entered__c = false;
        cs.Desired_Rent_Start__c = 2;
        cs.Origin = 'Phone';
        cs.Desired_Lease_length__c = 2;
        cs.Bed_Count_Pref__c = '2';
        cs.Notes__c = 'Hello Hi iiiiii ';
        cs.Floor_Plan_of_Interest__c = fp.Id;
        cs.Desired_Rent_Range_End__c = 2.0;
        cs.Unit_of_Interest__c = unit.Id;
        cs.Multi_Family_Case__c = true;
        cs.Is_First_Contact_Entered__c = true;
       
        insert cs;
        
        Appointment__c ap = new Appointment__c();
        ap.Contact__c = c.Id; 
        ap.Invite_Status__c = 'Invited';
        ap.Unit__c = unit.Id;
        ap.Appointment_Date__c = date.today();           
        insert ap;
        
        Appointment__c ap1 = new Appointment__c();
        ap1.Contact__c = c.Id; 
        ap1.Invite_Status__c = 'Invited';
        ap1.Unit__c = unit.Id;
        ap1.Appointment_Date__c = date.today();           
        insert ap1;

        Integration__c i1 = new Integration__c(); 
        I1.Grouping__c = g.Id;
        i1.Yardi_ID__c = 'anyonehome-ws';
        i1.Yardi_Password__c = '56559';
        i1.Yardi_Server_Name__c = 'sdb17\\SQL2k8_R2';
        i1.Yardi_Database_Name__c = 'afqoml_70dev';
        i1.Yardi_Platform_Type__c = 'SQL Server';
        i1.Yardi_API_URL__c = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfilsguestcard.asmx';
        i1.Yardi_Version_Number__c = '4';
        i1.Yardi_Integration_Active__c = true;
        i1.Push_Guest_Cards_to_Yardi__c = true;
        i1.Send_Waitlist__c = true;
        i1.Account__c = a.Id;
        insert i1;
        
        YardiGCPushController controller1 = new YardiGCPushController();
        controller1.PropertyCodes.add('abc');
        controller1.responseXml = '<ImportYardiGuest_LoginResult><Messages xmlns=""><Message messageType="Error">Invalid or missing ResultName.</Message><Message messageType="Error">00593122:First Contact Event Failed to Post</Message></Messages></ImportYardiGuest_LoginResult>';
        controller1.strPropertiesXml = '<GetPropertyConfigurationsResult><Properties><Property><Code>abc</Code><MarketingName>Anyone Home 1 Test Prop</MarketingName><AddressLine1>430 South Fairview Avenue</AddressLine1><AddressLine2 /><AddressLine3 /><City>Goleta</City><State>CA</State><PostalCode>93117</PostalCode></Property></Properties></GetPropertyConfigurationsResult>';                    
        controller1.strYardiAgentsSourcesResults = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <GetYardiAgentsSourcesResults_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20"> <GetYardiAgentsSourcesResults_LoginResult> <Properties xsi:noNamespaceSchemaLocation="" xmlns=""> <Property> <PropertyCode>10alme</PropertyCode> <PropertyRequiredFields> <Agents> <AgentName>Rover</AgentName> <AgentName InactiveDate="2014-03-02">New Site Setup</AgentName> <AgentName>Property Solutions</AgentName> <AgentName>Rent Cafe</AgentName> <AgentName>Z Do Not Use</AgentName> <AgentName>Vanessa Leimback</AgentName> <AgentName>Carrie Otto</AgentName> <AgentName>Madison Young</AgentName> <AgentName>Jessica Sneed</AgentName> <AgentName>Anyone Home</AgentName> <AgentName>Anyone Home Anyone Home</AgentName> </Agents> <Sources> <SourceName>Apt. Guide Mag</SourceName> <SourceName>Apt. Showcase</SourceName> <SourceName>Locator</SourceName> <SourceName>Non-Res Ref</SourceName> <SourceName>ParaRentar Mag</SourceName> <SourceName>Yellow Pages</SourceName> <SourceName>Apts. 24/7</SourceName> <SourceName>Apts.com Nwsp</SourceName> <SourceName>Competitor Ref</SourceName> <SourceName>Corp. Housing</SourceName> <SourceName>Echo Mag</SourceName> <SourceName>For Rent Mag.</SourceName> <SourceName>Home Builder</SourceName> <SourceName>New Mkt Svcs</SourceName> <SourceName>Off Site Mktg</SourceName> <SourceName>PB Bell Ref</SourceName> <SourceName>RE Agent</SourceName> <SourceName>Resident Ref</SourceName> <SourceName>Tuc Nwsp</SourceName> <SourceName>Y Mas</SourceName> <SourceName>Drive By</SourceName> <SourceName>For Rent Online</SourceName> <SourceName>ParaRentar Online</SourceName> <SourceName>Rent.com</SourceName> <SourceName>The Independent</SourceName> <SourceName>Winter Visitor</SourceName> <SourceName>Apt. Guide Online</SourceName> <SourceName>Aptfinders.com</SourceName> <SourceName>Apts.com Mag</SourceName> <SourceName>Apts.com Online</SourceName> <SourceName>Move.com</SourceName> <SourceName>Craigs List</SourceName> <SourceName>Nurse/Intern Housing.com</SourceName> <SourceName>mynewplace.com</SourceName> <SourceName>New Site Set Up</SourceName> <SourceName>Corp Mkting</SourceName> <SourceName>Property Solutions</SourceName> <SourceName>Realtor.com</SourceName> <SourceName>luxe List</SourceName> <SourceName>Google</SourceName> <SourceName>RENTCafe</SourceName> <SourceName>PB Bell Transfer</SourceName> <SourceName>Former Resident Ref</SourceName> <SourceName>Zillow.com</SourceName> <SourceName>RentMineOnline.com</SourceName> <SourceName>RentAdvisors</SourceName> <SourceName>Linked</SourceName> <SourceName>Facebook</SourceName> <SourceName>PBBell.com</SourceName> <SourceName>AptRatings</SourceName> <SourceName>AptSearch.com</SourceName> <SourceName>Yelp</SourceName> <SourceName>Banner</SourceName> <SourceName>Hotpads.com</SourceName> <SourceName>Rentbits.com</SourceName> <SourceName>Trulia.com</SourceName> <SourceName>Pref Employer</SourceName> <SourceName>Community Website</SourceName> <SourceName>Apartment List</SourceName> <SourceName>Employee Network</SourceName> <SourceName>Local First</SourceName> <SourceName>E-Blast</SourceName> <SourceName>Mobile Website</SourceName> <SourceName>Google Ads</SourceName> <SourceName>Google Plus</SourceName> <SourceName>AZ Central Print</SourceName> <SourceName>Print Editorial</SourceName> <SourceName>AZ Central Online</SourceName> <SourceName>TV/Radio Ad</SourceName> <SourceName>Internet Other</SourceName> </Sources> <Results> <Result>Residency, Criminal &amp; Financia</Result> <Result>Community Amenities</Result> <Result>Community Location</Result> <Result>Community Price</Result> <Result>Community Apartment Size</Result> <Result>Financial Reasons</Result> <Result>Job Transfer</Result> <Result>Marital / Roommate</Result> <Result>Criminal</Result> <Result>Employment</Result> <Result>Financial</Result> <Result>Criminal &amp; Employment</Result> <Result>Criminal &amp; Financial</Result> <Result>Employment &amp; Financial</Result> <Result>Criminal, Financial &amp; Employme</Result> <Result>Show - Rented</Result> <Result>Show - Did Not Rent</Result> <Result>Show - Not Qualified</Result> <Result>Site Unseen - Rented</Result> <Result>Phone Call - Made Appt.</Result> <Result>Phone Call - No Appt.</Result> <Result>Residency</Result> <Result>Residency &amp; Employment</Result> <Result>Residency &amp; Criminal</Result> <Result>Residency, Criminal &amp; Employme</Result> <Result>Email/Internet - Made Appt.</Result> <Result>Email/Internet - No Appt.</Result> <Result>Phone Call - Not Qualified</Result> <Result>Entered Twice</Result> <Result>Email/Internet - Not Qualified</Result> <Result>Cancel Transfer</Result> <Result>Did Not Meet Conditional Appro</Result> <Result>General Correspondence</Result> <Result>Thank You Letter</Result> <Result>Return Visit</Result> <Result>Reassign to Waitlist</Result> <Result>Walk In - No Show</Result> <Result>Did not Appear for Move In</Result> <Result>No Availability for Waitlist</Result> <Result>Health</Result> <Result>Residency &amp; Financial</Result> </Results> </PropertyRequiredFields> </Property> </Properties> </GetYardiAgentsSourcesResults_LoginResult> </GetYardiAgentsSourcesResults_LoginResponse> </soap:Body> </soap:Envelope>';

        YardiGCPushScheduler Pushscheduler1 = new YardiGCPushScheduler( 5 );
        System.schedule( 'YardiGCPushScheduler', '0 0 * * * ?', new YardiGCPushScheduler( 3, false ) );
        
        YardiGCPushBatch ObjBatch1 = new YardiGCPushBatch( false );
        ObjBatch1 = new YardiGCPushBatch( false );
        
        ObjBatch1.YardiController = controller1;
        Database.executeBatch( ObjBatch1, 20 );

        LIST<case> cases1 = controller1.pushGuestCards();
        
        Test.stopTest();
    }
     static testMethod void yardigcpush1() {
 		Test.startTest();
        Account a1 = new Account();
        a1.Name = 'Test Account';
        insert a1;
        
        Grouping__c g1 = new Grouping__c();
        g1.Account__c = a1.Id;
        g1.Name = 'Group A';
        insert g1;
        
        MSA__c msa1 = new MSA__c();
        msa1.State__c = 'CA';
        msa1.MSA_No__c = '123';
        msa1.Name = 'AK NONMETROPOLITAN AREA';
        msa1.County_Number__c = 12;
        insert msa1;
      
        Property__c p11 = new Property__c();
        p11.Name = 'New Property';
        p11.Account__c = a1.id;
        p11.Group_Membership__c = g1.Id;
        p11.Customer_Prop_ID__c = 'abc';
        p11.Address_Line_1__c = 'AAAAAAAAA';
        p11.City__c = 'Pune';
        p11.State__c = ' MH';
        p11.Zip_Code__c = '411013';
        insert p11;
       
        Source__c sc1 = new Source__c();
        sc1.Account__c = a1.id;
        sc1.Property__c = p11.Id;       
        sc1.Customer_Service_Source__c = true;
        sc1.Source_Type__c = 'Rent.com';
        insert sc1;
               
        Contact c12 = new Contact();
        c12.FirstName = 'Test26';
        c12.LastName = 'Test26';
        c12.AccountId = a1.Id;        
        c12.Anyone_Home_Type__c = 'Agent';
        c12.MobilePhone = '11111';
        c12.Email = 'aaaaaa@s.com';
        c12.Phone   = '222';
        c12.Status__c = 'Showing Set';
        insert c12;            
        
        Contact c11 = new Contact();
        c11.FirstName = 'Test16';
        c11.LastName = 'Test16';
        c11.AccountId = a1.Id;        
        c11.Anyone_Home_Type__c = 'Agent';
        c11.MobilePhone = '11111';
        c11.Email = 'aaaaaa@s.com';
        c11.Phone   = '222';
        c11.Status__c = 'Showing Completed';
        insert c11;   
        
        Floor_Plan__c fp1 = new Floor_Plan__c();
        fp1.Account__c = a1.id;
        fp1.Property__c = p11.Id;   
        fp1.Floorplan_ID__c = '100';
        insert fp1;

        Unit__c unit1 = new Unit__c();
        unit1.Account__c = a1.id;
        unit1.Property__c = p11.Id;   
        unit1.Unit_ID__c = '100';
        unit1.Floor_Plan__c = fp1.Id;
        insert unit1;

        Case cs1 = new Case();
        cs1.ContactId = c11.Id;
        cs1.Origin = 'Email';
        cs1.Move_in_Date__c = date.today();
        cs1.Date_Time_Sent_Via_Workflow__c = date.today();
        cs1.Ad_Source2__c = sc1.Id;
        cs1.Guest_Card_Status__c = 'Sent via Workflow';
        cs1.Integration_Failed__c = false;
        cs1.Property_of_Interest__c = p11.Id;
        cs1.GC_Entered__c = false;
        cs1.Desired_Rent_Start__c = 2;
        cs1.Desired_Lease_length__c = 2;
        cs1.Bed_Count_Pref__c = '2';
        cs1.Notes__c = 'Hello Hi iiiiii ';
        cs1.Origin = 'Phone';
        cs1.Floor_Plan_of_Interest__c = fp1.Id;
        cs1.Desired_Rent_Range_End__c = 2.0;
        cs1.Unit_of_Interest__c = unit1.Id;
        cs1.Multi_Family_Case__c = true;
        cs1.Is_First_Contact_Entered__c = true;
        insert cs1;
        
        Appointment__c ap12 = new Appointment__c();
        ap12.Contact__c = c12.Id; 
        ap12.Invite_Status__c = 'Invited';
        ap12.Unit__c = unit1.Id;
        ap12.Appointment_Date__c = date.today();           
        insert ap12;
        
        Appointment__c ap11 = new Appointment__c();
        ap11.Contact__c = c12.Id; 
        ap11.Invite_Status__c = 'Canceled';
        ap11.CanceledRejected_By__c = 'Prospect';
        ap11.Unit__c = unit1.Id;
        ap11.Appointment_Date__c = date.today();           
        insert ap11;

        Integration__c i11 = new Integration__c(); 
        i11.Grouping__c =  g1.Id;
        i11.Yardi_ID__c = 'anyonehome-ws';
        i11.Yardi_Password__c = '56559';
        i11.Send_Waitlist__c = true;
        i11.Yardi_Server_Name__c = 'sdb17\\SQL2k8_R2';
        i11.Yardi_Database_Name__c = 'afqoml_70dev';
        i11.Yardi_Platform_Type__c = 'SQL Server';
        i11.Yardi_API_URL__c = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfilsguestcard.asmx';
        i11.Yardi_Version_Number__c = '2';
        i11.Yardi_Integration_Active__c = true;
        i11.Push_Guest_Cards_to_Yardi__c = true;
        i11.Account__c = a1.Id;
        insert i11;
       
        YardiGCPushController controller = new YardiGCPushController();
        controller.PropertyCodes.add('abc');
        controller.responseXml = '<ImportYardiGuest_LoginResult><Messages xmlns=""><Message messageType="Error">Invalid or missing ResultName.</Message><Message messageType="Error">00593122:First Contact Event Failed to Post</Message></Messages></ImportYardiGuest_LoginResult>';
        controller.strPropertiesXml = '<GetPropertyConfigurationsResult><Properties><Property><Code>abc</Code><MarketingName>Anyone Home 1 Test Prop</MarketingName><AddressLine1>430 South Fairview Avenue</AddressLine1><AddressLine2 /><AddressLine3 /><City>Goleta</City><State>CA</State><PostalCode>93117</PostalCode></Property></Properties></GetPropertyConfigurationsResult>';                    
        controller.strYardiAgentsSourcesResults = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <GetYardiAgentsSourcesResults_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20"> <GetYardiAgentsSourcesResults_LoginResult> <Properties xsi:noNamespaceSchemaLocation="" xmlns=""> <Property> <PropertyCode>10alme</PropertyCode> <PropertyRequiredFields> <Agents> <AgentName>Rover</AgentName> <AgentName InactiveDate="2014-03-02">New Site Setup</AgentName> <AgentName>Property Solutions</AgentName> <AgentName>Rent Cafe</AgentName> <AgentName>Z Do Not Use</AgentName> <AgentName>Vanessa Leimback</AgentName> <AgentName>Carrie Otto</AgentName> <AgentName>Madison Young</AgentName> <AgentName>Jessica Sneed</AgentName> <AgentName>Anyone Home</AgentName> <AgentName>Anyone Home Anyone Home</AgentName> </Agents> <Sources> <SourceName>Apt. Guide Mag</SourceName> <SourceName>Apt. Showcase</SourceName> <SourceName>Locator</SourceName> <SourceName>Non-Res Ref</SourceName> <SourceName>ParaRentar Mag</SourceName> <SourceName>Yellow Pages</SourceName> <SourceName>Apts. 24/7</SourceName> <SourceName>Apts.com Nwsp</SourceName> <SourceName>Competitor Ref</SourceName> <SourceName>Corp. Housing</SourceName> <SourceName>Echo Mag</SourceName> <SourceName>For Rent Mag.</SourceName> <SourceName>Home Builder</SourceName> <SourceName>New Mkt Svcs</SourceName> <SourceName>Off Site Mktg</SourceName> <SourceName>PB Bell Ref</SourceName> <SourceName>RE Agent</SourceName> <SourceName>Resident Ref</SourceName> <SourceName>Tuc Nwsp</SourceName> <SourceName>Y Mas</SourceName> <SourceName>Drive By</SourceName> <SourceName>For Rent Online</SourceName> <SourceName>ParaRentar Online</SourceName> <SourceName>Rent.com</SourceName> <SourceName>The Independent</SourceName> <SourceName>Winter Visitor</SourceName> <SourceName>Apt. Guide Online</SourceName> <SourceName>Aptfinders.com</SourceName> <SourceName>Apts.com Mag</SourceName> <SourceName>Apts.com Online</SourceName> <SourceName>Move.com</SourceName> <SourceName>Craigs List</SourceName> <SourceName>Nurse/Intern Housing.com</SourceName> <SourceName>mynewplace.com</SourceName> <SourceName>New Site Set Up</SourceName> <SourceName>Corp Mkting</SourceName> <SourceName>Property Solutions</SourceName> <SourceName>Realtor.com</SourceName> <SourceName>luxe List</SourceName> <SourceName>Google</SourceName> <SourceName>RENTCafe</SourceName> <SourceName>PB Bell Transfer</SourceName> <SourceName>Former Resident Ref</SourceName> <SourceName>Zillow.com</SourceName> <SourceName>RentMineOnline.com</SourceName> <SourceName>RentAdvisors</SourceName> <SourceName>Linked</SourceName> <SourceName>Facebook</SourceName> <SourceName>PBBell.com</SourceName> <SourceName>AptRatings</SourceName> <SourceName>AptSearch.com</SourceName> <SourceName>Yelp</SourceName> <SourceName>Banner</SourceName> <SourceName>Hotpads.com</SourceName> <SourceName>Rentbits.com</SourceName> <SourceName>Trulia.com</SourceName> <SourceName>Pref Employer</SourceName> <SourceName>Community Website</SourceName> <SourceName>Apartment List</SourceName> <SourceName>Employee Network</SourceName> <SourceName>Local First</SourceName> <SourceName>E-Blast</SourceName> <SourceName>Mobile Website</SourceName> <SourceName>Google Ads</SourceName> <SourceName>Google Plus</SourceName> <SourceName>AZ Central Print</SourceName> <SourceName>Print Editorial</SourceName> <SourceName>AZ Central Online</SourceName> <SourceName>TV/Radio Ad</SourceName> <SourceName>Internet Other</SourceName> </Sources> <Results> <Result>Residency, Criminal &amp; Financia</Result> <Result>Community Amenities</Result> <Result>Community Location</Result> <Result>Community Price</Result> <Result>Community Apartment Size</Result> <Result>Financial Reasons</Result> <Result>Job Transfer</Result> <Result>Marital / Roommate</Result> <Result>Criminal</Result> <Result>Employment</Result> <Result>Financial</Result> <Result>Criminal &amp; Employment</Result> <Result>Criminal &amp; Financial</Result> <Result>Employment &amp; Financial</Result> <Result>Criminal, Financial &amp; Employme</Result> <Result>Show - Rented</Result> <Result>Show - Did Not Rent</Result> <Result>Show - Not Qualified</Result> <Result>Site Unseen - Rented</Result> <Result>Phone Call - Made Appt.</Result> <Result>Phone Call - No Appt.</Result> <Result>Residency</Result> <Result>Residency &amp; Employment</Result> <Result>Residency &amp; Criminal</Result> <Result>Residency, Criminal &amp; Employme</Result> <Result>Email/Internet - Made Appt.</Result> <Result>Email/Internet - No Appt.</Result> <Result>Phone Call - Not Qualified</Result> <Result>Entered Twice</Result> <Result>Email/Internet - Not Qualified</Result> <Result>Cancel Transfer</Result> <Result>Did Not Meet Conditional Appro</Result> <Result>General Correspondence</Result> <Result>Thank You Letter</Result> <Result>Return Visit</Result> <Result>Reassign to Waitlist</Result> <Result>Walk In - No Show</Result> <Result>Did not Appear for Move In</Result> <Result>No Availability for Waitlist</Result> <Result>Health</Result> <Result>Residency &amp; Financial</Result> </Results> </PropertyRequiredFields> </Property> </Properties> </GetYardiAgentsSourcesResults_LoginResult> </GetYardiAgentsSourcesResults_LoginResponse> </soap:Body> </soap:Envelope>';

        YardiGCPushScheduler Pushscheduler = new YardiGCPushScheduler( 5 );
        System.schedule( 'YardiGCPushScheduler', '0 0 * * * ?', new YardiGCPushScheduler( 3, false ) );
        
        YardiGCPushBatch ObjBatch = new YardiGCPushBatch( false );
        ObjBatch = new YardiGCPushBatch( false );
        
        ObjBatch.YardiController = controller;
        Database.executeBatch( ObjBatch, 20 );

        LIST<case> cases = controller.pushGuestCards();
        Test.stopTest();        
    }
}