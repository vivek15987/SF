public with sharing class PSIStatusMappingController {
    
    public List<SelectOption> AllPSIStatus = new List<SelectOption>();
    
    public PSIStatusMappingController() {  
        AllPSIStatus = ( List<SelectOption> ) this.PSIStatusMapping();
    }
    
    public PSIStatusMappingController(ApexPages.StandardController stc) {
        
    }   
    
    public List<SelectOption> PSIStatusMapping() {
        
        List<SelectOption> AllPSIStatus = new List<SelectOption>();
        List<PSIStatuesMappingWrapperClass> MappedPSIStatus = new List<PSIStatuesMappingWrapperClass>();
        for ( Unit__c unit : [ SELECT Id, Occupancy_Status__c FROM Unit__c WHERE Account__c IN ( SELECT Account__c FROM Integration__c WHERE PSI_Username__c != NULL AND PSI_Password__c != NULL AND PSI_API_URL__c != NULL ) LIMIT 20 ] ) {
            if( unit.Occupancy_Status__c != null && unit.Id != null ) {
                PSIStatuesMappingWrapperClass PSIUnitStatues = new PSIStatuesMappingWrapperClass(); 
                PSIUnitStatues.Id = unit.Id;
                PSIUnitStatues.Occupancy_Status = unit.Occupancy_Status__c;
                MappedPSIStatus.add( PSIUnitStatues );
            }
        }
        
        for( PSIStatuesMappingWrapperClass PSIStatus: MappedPSIStatus ) {
            AllPSIStatus.add( new SelectOption( PSIStatus.Id, PSIStatus.Occupancy_Status ) );
        }
        return AllPSIStatus;
    }
    
    public class PSIStatuesMappingWrapperClass {
         public String Id; 
         public String Occupancy_Status; 
    } 
}