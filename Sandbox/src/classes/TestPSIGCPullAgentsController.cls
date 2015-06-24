@isTest
public class TestPSIGCPullAgentsController {

    static testMethod void testpsigcpullagentscontroller() {
		
        Account a = new Account();
        a.Name	= 'Test';
        insert a;
        
        Integration__c i1 = new Integration__c(); 
        i1.Account__c = a.Id;
        i1.Push_Guest_Cards_to_PSI__c = true;
        i1.PSI_API_URL__c = 'https://timepass.com';
        i1.PSI_Username__c = 'Username';
        i1.PSI_Password__c = 'Password';
        i1.Get_PSI_Agents_Info__c = 'Hourly';
        i1.PSI_Integration_Active__c = true;
        insert i1;
        
        Property__c p 			= new Property__c();
        p.Account__c 			= a.Id;
        p.PSI_Prop_ID__c 	= '104143';
        insert p;
        
        Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;
        
        Test.startTest();
        PSIGCPullAgentsScheduler testAgents = new PSIGCPullAgentsScheduler();
        testAgents = new PSIGCPullAgentsScheduler( 3 );
        System.schedule( 'PSIGCPullAgentsScheduler', '0 0 * * * ?', new PSIGCPullAgentsScheduler(3, false) );
        PSIGCPullAgentsController psi = new PSIGCPullAgentsController();
        psi.strLeadPickLists = '{"response":{"requestId":"15","result":{"Property":{"104143":{"@attributes":{"Id":104143},"LeasingAgents":{"LeasingAgent":[{"@attributes":{"name":"AJ Aikin","Id":223447}},{"@attributes":{"name":"A.J Aikin","Id":222411}},{"@attributes":{"name":"Anyone Home Anyone","Id":224486}},{"@attributes":{"name":"April Williams","Id":222412}},{"@attributes":{"name":"Eric Naranjo","Id":222629}},{"@attributes":{"name":"Kyle Anderson","Id":224148}},{"@attributes":{"name":"Kyle Anderson","Id":224227}},{"@attributes":{"name":"Lawanda Dudley","Id":222413}}]},"LeadSources":{"LeadSource":[{"@attributes":{"name":"Apartment Finder","Id":40310,"WebVisible":"true"}},{"@attributes":{"name":"Apartment Guide","Id":40305,"WebVisible":"true"}},{"@attributes":{"name":"ApartmentGuys.com","Id":47211,"WebVisible":"true"}},{"@attributes":{"name":"Apartment Home Living","Id":41886,"WebVisible":"true"}},{"@attributes":{"name":"ApartmentRatings.com","Id":41887,"WebVisible":"true"}},{"@attributes":{"name":"Apartments.com","Id":34461,"WebVisible":"true"}},{"@attributes":{"name":"Bing.com","Id":41888,"WebVisible":"true"}},{"@attributes":{"name":"Coast2Coast Transfer","Id":41891,"WebVisible":"true"}},{"@attributes":{"name":"Craigslist.com","Id":40311,"WebVisible":"true"}},{"@attributes":{"name":"Drive By","Id":34457,"WebVisible":"true"}},{"@attributes":{"name":"Facebook","Id":41894,"WebVisible":"true"}},{"@attributes":{"name":"Former Resident","Id":41895,"WebVisible":"true"}},{"@attributes":{"name":"ForRent","Id":41896,"WebVisible":"true"}},{"@attributes":{"name":"Foursquare","Id":41897,"WebVisible":"true"}},{"@attributes":{"name":"Google","Id":46760,"WebVisible":"true"}},{"@attributes":{"name":"Laramar Community Referral","Id":42233,"WebVisible":"true"}},{"@attributes":{"name":"Lifestyle Brochure","Id":46337,"WebVisible":"true"}},{"@attributes":{"name":"Locator Service","Id":41899,"WebVisible":"true"}},{"@attributes":{"name":"Move.com","Id":34466,"WebVisible":"true"}},{"@attributes":{"name":"MyNewPlace.com","Id":34464,"WebVisible":"true"}},{"@attributes":{"name":"Outreach/Direct Marketing","Id":41900,"WebVisible":"true"}},{"@attributes":{"name":"PEP Marketing","Id":41901,"WebVisible":"true"}},{"@attributes":{"name":"Property Website","Id":41902,"WebVisible":"true"}},{"@attributes":{"name":"Rent.com","Id":34462,"WebVisible":"true"}},{"@attributes":{"name":"Resident Referral","Id":34459,"WebVisible":"true"}},{"@attributes":{"name":"Signs/Banners","Id":41903,"WebVisible":"true"}},{"@attributes":{"name":"Twitter","Id":41905,"WebVisible":"true"}},{"@attributes":{"name":"Vendor/Merchant Referral","Id":41906,"WebVisible":"true"}},{"@attributes":{"name":"Yelp.com","Id":41908,"WebVisible":"true"}},{"@attributes":{"name":"Youtube.com","Id":41909,"WebVisible":"true"}}]}}}}}}';
        psi.pullPSIAgents( false );
        PSIGCPullAgentsBatch AgentsBatch = new PSIGCPullAgentsBatch( false );
        AgentsBatch.psi = psi;
		Database.executeBatch( AgentsBatch, 20 );
        Test.stopTest();
    }
}