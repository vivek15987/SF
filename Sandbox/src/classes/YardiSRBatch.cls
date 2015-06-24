global class YardiSRBatch implements Database.Batchable<Service_Request1__c>, Database.AllowsCallouts, Database.Stateful {
   
    Map<String,Map<String, String>> AllIntegrationCredentials = new Map<String, Map<String, String>>();
        
    public YardiSRBatch() {}
    
    global Iterable<Service_Request1__c> start(Database.BatchableContext BC) {
       	List<Service_Request1__c> arrobjServiceRequests = new List<Service_Request1__c>();
        
        List<Integration__c> arrobjIntegrations  = [SELECT 
                                                        Account__c, Grouping__c, Yardi_Password__c, Yardi_SR_API_URL__c, Yardi_SR_Database_Name__c, Yardi_SR_ID__c,
                                                        Yardi_SR_Integration_Active__c, Yardi_SR_Password__c, Yardi_SR_Platform_Type__c, Yardi_SR_Server_Name__c, Yardi_SR_Version_Number__c,
                                                        Emergency_Classification__c, Standard_Classification__c
                                                    FROM 
                                                        Integration__c
                                                    WHERE 
                                                        Yardi_SR_Integration_Active__c = true];
         
        Set<String> AccountIds = new Set<String>();
        Set<String> GroupingIds = new Set<String>();
        
        if( !arrobjIntegrations.isEmpty() ) {
            for( Integration__c I :arrobjIntegrations ) { 
                if( null != I.Grouping__c && !GroupingIds.contains( I.Grouping__c ) ) {
                    GroupingIds.add( I.Grouping__c );
                    AllIntegrationCredentials.put( I.Grouping__c, new Map<String, String>{ 'UserName' => I.Yardi_SR_ID__c, 'Password' => I.Yardi_SR_Password__c, 'ServerName' => I.Yardi_SR_Server_Name__c, 'Database' => I.Yardi_SR_Database_Name__c, 'Platform' => I.Yardi_SR_Platform_Type__c, 'VersionNumber' => I.Yardi_SR_Version_Number__c, 'APIURL' => I.Yardi_SR_API_URL__c, 'EmergencyClassification' => I.Emergency_Classification__c, 'StandardClassification' => I.Standard_Classification__c } );
                } else if( !AccountIds.contains( I.Account__c ) ) {
                    AccountIds.add( I.Account__c );
                    AllIntegrationCredentials.put( I.Account__c,  new Map<String, String>{ 'UserName' => I.Yardi_SR_ID__c, 'Password' => I.Yardi_SR_Password__c, 'ServerName' => I.Yardi_SR_Server_Name__c, 'Database' => I.Yardi_SR_Database_Name__c, 'Platform' => I.Yardi_SR_Platform_Type__c, 'VersionNumber' => I.Yardi_SR_Version_Number__c, 'APIURL' => I.Yardi_SR_API_URL__c, 'EmergencyClassification' => I.Emergency_Classification__c, 'StandardClassification' => I.Standard_Classification__c } );
                }         
            }
            System.debug( GroupingIds );
            arrobjServiceRequests = [ SELECT 
                                        Id, Name, Account_Name__r.Id, Grouping__c
                                    FROM 
                                        Service_Request1__c
                                    WHERE 
                                        Service_Request_Type__r.CS_Request_Type__c = FALSE AND
                                        Work_Order_Entered_in_PMS__c = FALSE AND 
                                        Status__c = 'Request Sent' AND
                                        Cust_Prop_ID__c != NULL AND
                                     	Repeat_Call__c = FALSE AND
                                     	Integration_Failed__c = FALSE AND
                                        ( ( Grouping__c IN : GroupingIds ) OR ( Account_Name__r.Id IN : AccountIds AND Grouping__c = NULL ) ) AND
										LastModifiedDate = LAST_N_DAYS:5
                                    ];
        }
        
        //System.debug( arrobjServiceRequests.size() );
        //return new List<Service_Request1__c>();
        
        return arrobjServiceRequests;
        
    }
    
    global void execute( Database.BatchableContext BC, List<Service_Request1__c> arrobjServiceRequests ){
        Set<ID> ServiceRequestIds   = new Set<ID>();
        
        Map<String, Map<String, String>> IntegrationCredentials = new Map<String, Map<String, String>>();
       	
        //Instead of Putting AccountIds, ServiceRequestIds and IntegrationInfo in new Variables, Direct assign these values to Class variable
        for( Service_Request1__c ServiceRequest : arrobjServiceRequests ) {
            if( null != ServiceRequest.Grouping__c && AllIntegrationCredentials.containsKey( ServiceRequest.Grouping__c ) ) {
                IntegrationCredentials.put( ServiceRequest.Grouping__c, AllIntegrationCredentials.get( ServiceRequest.Grouping__c ) );
            } else if( AllIntegrationCredentials.containsKey( ServiceRequest.Account_Name__r.Id ) ) {
                IntegrationCredentials.put( ServiceRequest.Account_Name__r.Id, AllIntegrationCredentials.get( ServiceRequest.Account_Name__r.Id )  );
            }  
            
            ServiceRequestIds.add( ServiceRequest.Id );
        }

        YardiSRController SRController = new YardiSRController();
        SRController.ServiceRequestIds  = ServiceRequestIds;
        SRController.AllIntegrationCredentials = IntegrationCredentials;
        SRController.pushServiceRequests();
        
        for( Service_Request1__c ServiceRequest: SRController.arrobjServiceRequests ) {
            try {
                update ServiceRequest;
            } catch ( Exception e) {
                System.debug( 'Error For ServiceRequestId : ' + ServiceRequest.Id );
            }
        }
        
        //upsert SRController.arrobjServiceRequests; 
    }

    global void finish(Database.BatchableContext info){
        //global void finish loop
    }

}