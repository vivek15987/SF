@isTest
global class HttpYardiGCPullAgentsResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response.
        // Set response values, and 
        // return response.
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setBody('<GetYardiAgentsSourcesResults_LoginResult> <Properties xmlns=""> <Property> <PropertyCode>anyhome1</PropertyCode> <PropertyRequiredFields> <Agents> <AgentName>Joe Black</AgentName> <AgentName>Tom Jones</AgentName> <AgentName InactiveDate="2012-03-30">John Smith</AgentName> <AgentName>Joseph Smith</AgentName> <AgentName>Richard Green</AgentName> <AgentName>AnyoneHome AnyoneHome</AgentName> <AgentName>Anyone Home Anyone Home</AgentName> </Agents> <Sources> <SourceName>Drive by</SourceName> <SourceName>Internet</SourceName> <SourceName>Referral</SourceName> <SourceName>Newspaper</SourceName> </Sources> <Results> <Result>Still Looking</Result> <Result>Too Expensive</Result> <Result>Pets</Result> <Result>Pricing</Result> <Result>Location</Result> <Result>Follow Up</Result> <Result>Cancel Reason</Result> <Result>Credit History</Result> <Result>Size</Result> </Results> </PropertyRequiredFields> </Property> </Properties> </GetYardiAgentsSourcesResults_LoginResult>');
        res.setStatusCode(200);
        return res;
    }
}