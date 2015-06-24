@isTest
public class TestPSIGCPushController {

    static testMethod void psigcpush() {
        
        Test.startTest();
        
        PSIGCPushScheduler testScheduler = new PSIGCPushScheduler( 3 );
        System.schedule( 'PSIGCPushScheduler', '0 0 * * * ?', new PSIGCPushScheduler( 3 ) );
        
        Account a = new Account();
       	a.Name = 'Test Account';
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
        p1.Address_Line_1__c = 'AAAAAAAAA';
        p1.City__c = 'Pune';
        p1.State__c = ' MH';
        p1.Zip_Code__c = '411013';
        p1.PSI_Prop_ID__c = '104143';
       	insert p1;
       
       	Source__c sc = new Source__c();
       	sc.Account__c = a.id;
       	sc.Property__c = p1.Id;       
       	sc.Customer_Service_Source__c = true;
       	sc.Source_Type__c = 'Drive By';
       	insert sc;
               
        Contact c = new Contact();
        c.FirstName = 'Test6';
        c.LastName = 'Test6';
        c.AccountId = a.Id;        
        c.Anyone_Home_Type__c = 'Agent';
        c.MobilePhone = '11111';
        c.Email = 'aaaaaa@s.com';
        c.Phone	= '222';
        insert c;    
        
        
        
        Floor_Plan__c floorplan = new Floor_Plan__c();
        floorplan.PSI_Floor_Plan_ID__c = 'ABD';
        floorplan.Property__c = p1.Id;
        floorplan.Account__c = a.Id;
        insert floorplan;
        
        Unit__c Unit = new Unit__c();
        Unit.Floor_Plan__c = floorplan.Id;
        Unit.Property__c = p1.Id;
        Unit.Account__c = a.Id;
        Unit.PSI_Unit_ID__c = 'PQR';
        Unit.Name = 'xyz';
        Unit.Bedrooms__c = 2.00;
        Unit.Bathrooms__c = 2.00;
        Unit.Square_Feet__c = '20';
        Unit.Maximum_Rent__c = 200;
        Unit.Market_Rent__c = 100;
        
        insert Unit;

        Case cs = new Case();
        cs.ContactId = c.Id;
        cs.AccountId = a.Id;
        cs.Origin = 'Email';
       	cs.Move_in_Date__c = date.today();
        cs.Date_Time_Sent_Via_Workflow__c = date.today();
        cs.Ad_Source2__c = sc.Id;
        cs.Guest_Card_Status__c = 'Sent via Workflow';
        cs.Integration_Failed__c = false;
        cs.Property_of_Interest__c = p1.Id;
        cs.GC_Entered__c = false;
        cs.Multi_Family_Case__c = true;
        cs.Desired_Rent_Start__c = 2;
        cs.Desired_Lease_length__c = 2;
        cs.Notes__c = 'Hello Hi iiiiii ';
        cs.Unit_of_Interest__c = Unit.Id;
        cs.Of_Occupants__c = 2;
        cs.Floor_Plan_of_Interest__c = floorplan.Id;
        insert cs;
        
        Appointment__c Ap = new Appointment__c();
        Ap.Appointment_Date__c = Date.today();
        Ap.Case__c = cs.Id;
        Ap.From__c = '8:00';
        Ap.To__c = '8:30';
        insert Ap;
            
        Integration__c i1 = new Integration__c(); 
        i1.Account__c = a.Id;
        i1.Grouping__c = g.Id; 
        i1.PSI_Integration_Active__c = true;
        i1.Push_Guest_Cards_to_PSI__c = true;
        i1.PSI_API_URL__c = 'https://test.com';
        i1.PSI_Username__c = 'Username';
        i1.PSI_Password__c = 'Password';
        insert i1;
		
        //IGCPushController controller = new PSIGCPushController();
        //controller.strLeadPickLists = '{"response":{"requestId":"15","result":{"Property":{"104143":{"@attributes":{"Id":104143},"LeasingAgents":{"LeasingAgent":[{"@attributes":{"name":"AJ Aikin","Id":223447}},{"@attributes":{"name":"A.J Aikin","Id":222411}},{"@attributes":{"name":"Anyone Home Anyone","Id":224486}},{"@attributes":{"name":"April Williams","Id":222412}},{"@attributes":{"name":"Eric Naranjo","Id":222629}},{"@attributes":{"name":"Kyle Anderson","Id":224148}},{"@attributes":{"name":"Kyle Anderson","Id":224227}},{"@attributes":{"name":"Lawanda Dudley","Id":222413}}]},"LeadSources":{"LeadSource":[{"@attributes":{"name":"Apartment Finder","Id":40310,"WebVisible":"true"}},{"@attributes":{"name":"Apartment Guide","Id":40305,"WebVisible":"true"}},{"@attributes":{"name":"ApartmentGuys.com","Id":47211,"WebVisible":"true"}},{"@attributes":{"name":"Apartment Home Living","Id":41886,"WebVisible":"true"}},{"@attributes":{"name":"ApartmentRatings.com","Id":41887,"WebVisible":"true"}},{"@attributes":{"name":"Apartments.com","Id":34461,"WebVisible":"true"}},{"@attributes":{"name":"Bing.com","Id":41888,"WebVisible":"true"}},{"@attributes":{"name":"Coast2Coast Transfer","Id":41891,"WebVisible":"true"}},{"@attributes":{"name":"Craigslist.com","Id":40311,"WebVisible":"true"}},{"@attributes":{"name":"Drive By","Id":34457,"WebVisible":"true"}},{"@attributes":{"name":"Facebook","Id":41894,"WebVisible":"true"}},{"@attributes":{"name":"Former Resident","Id":41895,"WebVisible":"true"}},{"@attributes":{"name":"ForRent","Id":41896,"WebVisible":"true"}},{"@attributes":{"name":"Foursquare","Id":41897,"WebVisible":"true"}},{"@attributes":{"name":"Google","Id":46760,"WebVisible":"true"}},{"@attributes":{"name":"Laramar Community Referral","Id":42233,"WebVisible":"true"}},{"@attributes":{"name":"Lifestyle Brochure","Id":46337,"WebVisible":"true"}},{"@attributes":{"name":"Locator Service","Id":41899,"WebVisible":"true"}},{"@attributes":{"name":"Move.com","Id":34466,"WebVisible":"true"}},{"@attributes":{"name":"MyNewPlace.com","Id":34464,"WebVisible":"true"}},{"@attributes":{"name":"Outreach/Direct Marketing","Id":41900,"WebVisible":"true"}},{"@attributes":{"name":"PEP Marketing","Id":41901,"WebVisible":"true"}},{"@attributes":{"name":"Property Website","Id":41902,"WebVisible":"true"}},{"@attributes":{"name":"Rent.com","Id":34462,"WebVisible":"true"}},{"@attributes":{"name":"Resident Referral","Id":34459,"WebVisible":"true"}},{"@attributes":{"name":"Signs/Banners","Id":41903,"WebVisible":"true"}},{"@attributes":{"name":"Twitter","Id":41905,"WebVisible":"true"}},{"@attributes":{"name":"Vendor/Merchant Referral","Id":41906,"WebVisible":"true"}},{"@attributes":{"name":"Yelp.com","Id":41908,"WebVisible":"true"}},{"@attributes":{"name":"Youtube.com","Id":41909,"WebVisible":"true"}}]}}}}}}';
       	//controller.responseJSON = '{ "response":{ "requestId":"898", "result":{ "Prospects":{ "Prospect":[ { "@attributes":{ "node":1, "reference_id":4434271, "applicant_id":4900021, "status":"Success", "message":"Lead inserted successfully." } } ] } } } }';
        //controller.pushGuestCards( false );
        //ntroller.convertTime( '9:00 a.m.' );
        //ntroller.convertTime( '9:00 p.m.' );
        PSIGCPushBatch ObjBatch = new PSIGCPushBatch();
        //ObjBatch.psi = controller;
        Database.executeBatch( ObjBatch, 4 ); 
        
       	Test.stopTest(); 
       
    }
}