public class YardiPullSRTypesController {
    //public String IntegrationPartnerID, ApiKey, strMarketing4_0, strGetProperties; 
    
    Public String InterfaceEntity = 'Anyone Home';
    Public String InterfaceLicense  = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQSLpy4Ro7huvEUpSSXkyhBQSByBBAui++BOHOZi6y+7e0F9P63osdEw/UekwyjUarQzRrAYpzgD93l226Ci2qWPYxqWlf8Qg8R7dNnAB/1TIx8roGlhRsUiWXrzuN7AzjGVzOXG+8LI5qLpTELb9+di/M+dOnakGuZKEhM+gOQFN60j10uPBMjeww1D/7OHNGO2JEGPqL94OLZ7yZCRKkAWQUsLlkfYECwJ0MVBzerAxP0wsQ4TEylz4A+KuXKfq7c0RfWzotMc83h0sYpHeSTC1c6vRL8xuxUZPU';
    public Set<String> PropertyCodes = new Set<String>();
    public RMPullPropertiesResponseController objRMPullPropertiesResponse;
    public List<Property__c> arrobjProperties = new List<Property__c>(); 
    
    public YardiPullSRTypesController() {
    }
    
    public void YardiPullSRTypes() {
        //Get Integrations.
        
        List<AggregateResult> ActiveAccountList = [ SELECT
                                                   		Account__c
                                                   	FROM
                                                   		Integration__c
                                                   	WHERE
                                                       	Yardi_SR_Integration_Active__c = true AND Pull_Service_Request_Types__c = true
                                                   	GROUP BY
                                                   		Account__c
                                                  ];
        
        if( !ActiveAccountList.isEmpty() ) {
            try {
                for( AggregateResult ActiveAccount: ActiveAccountList ) {
                    Integration__c I = [ SELECT 
                                        	Id, Name, Account__c, Yardi_SR_ID__c, Yardi_SR_Password__c, Yardi_SR_Platform_Type__c, Yardi_SR_Server_Name__c, Yardi_SR_Version_Number__c, Yardi_SR_Database_Name__c, Yardi_SR_API_URL__c
                                        FROM
                                        	Integration__c
                                        WHERE
                                        	Yardi_SR_Integration_Active__c = true AND Pull_Service_Request_Types__c != NULL AND Yardi_SR_ID__c != NULL AND Yardi_SR_Password__c != NULL AND Yardi_SR_API_URL__c != NULL AND Account__c =: String.valueOf(ActiveAccount.get('Account__c'))
                                        LIMIT 1
                                       ];    
                    
                    if( null != I ) {
                        Map<String, String> strCredentials = new Map<String, String>();
                        strCredentials.put( 'UserName', I.Yardi_SR_ID__c );
                        strCredentials.put( 'Password', I.Yardi_SR_Password__c );
                        strCredentials.put( 'Platform', I.Yardi_SR_Platform_Type__c );
                        strCredentials.put( 'Database', I.Yardi_SR_Database_Name__c );
                        strCredentials.put( 'ServerName', I.Yardi_SR_Server_Name__c );
                        strCredentials.put( 'VersionNumber', I.Yardi_SR_Version_Number__c ); 
                        strCredentials.put( 'APIURL', I.Yardi_SR_API_URL__c ); 
                        
                        this.GetCustomValues( strCredentials );
                    }
                }
            } catch( Exception e ) {
                System.debug( e.getMessage() );
                System.debug( e.getStackTraceString() );
                
            } 
        }
    }
    
    public void GetCustomValues( Map<String, String> strCredentials ) {
        if( ! Test.isRunningTest() ) {
            YardiSRWsdltoApexController.ItfServiceRequestsSoap yardiWsdltoApex = new YardiSRWsdltoApexController.ItfServiceRequestsSoap();  
            yardiWsdltoApex.GetCustomValues( strCredentials.get( 'UserName' ), strCredentials.get( 'Password' ), strCredentials.get( 'ServerName' ),strCredentials.get( 'Database' ), strCredentials.get( 'Platform' ), InterfaceEntity, InterfaceLicense, strCredentials.get( 'APIURL' ) );
            
        }
    }
}