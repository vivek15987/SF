trigger PSIStatusMapping on Integration__c ( before insert, before update ) {
    
    for( Integration__c i :trigger.new ) {
        
        // For only those integrations having PSI integrations
        if( i.PSI_Username__c != null && i.PSI_Password__c != null && i.PSI_API_URL__c != null ) {
            List<String> PSIActiveUnitStatues = i.PSI_Active_Unit_Statues__c != null ? string.valueOf( i.PSI_Active_Unit_Statues__c ).split(';') : null;
            List<String> PSIInActiveUnitStatues = i.PSI_InActive_Unit_Statues__c != null ? string.valueOf( i.PSI_InActive_Unit_Statues__c ).split(';'): null;
            List<String> PSIActiveNoShowingsUnitStatues = i.PSI_Active_No_Showings_Unit_Statues__c != null ? string.valueOf( i.PSI_Active_No_Showings_Unit_Statues__c ).split(';'): null;
            
            if( PSIActiveUnitStatues != null && PSIInActiveUnitStatues != null ) {
                for( String PSIActiveUnitStatus :PSIActiveUnitStatues  ) {
                    for( String PSIInActiveUnitStatus :PSIInActiveUnitStatues  ) {
                        if( PSIActiveUnitStatus == PSIInActiveUnitStatus ) {
                            throw new TriggerException( 'Please select "' + PSIActiveUnitStatus + '" status for either Active or In-Active stauts types.' );
                        }
                    }
                }
            }
            
            if( PSIActiveNoShowingsUnitStatues != null && PSIInActiveUnitStatues != null ) {
                for( String PSIInActiveUnitStatus :PSIInActiveUnitStatues  ) {
                    for( String PSIActiveNoShowingsUnitStatus :PSIActiveNoShowingsUnitStatues  ) {
                        if( PSIActiveNoShowingsUnitStatus == PSIInActiveUnitStatus ) {
                            throw new TriggerException( 'Please select "' + PSIInActiveUnitStatus + '" status for either In-Active or Active No Showings Available stauts types.' );
                        }
                    }
                }
            }
            
            
            if( PSIActiveUnitStatues != null && PSIActiveNoShowingsUnitStatues != null ) {
                for( String PSIActiveUnitStatus :PSIActiveUnitStatues  ) {
                    for( String PSIActiveNoShowingsUnitStatus :PSIActiveNoShowingsUnitStatues  ) {
                        
                        if( PSIActiveUnitStatus == PSIActiveNoShowingsUnitStatus ) {     

                            throw new TriggerException( 'Please select "' + PSIActiveUnitStatus + '" status for either Active or Active No Showings Available stauts types.' );
                        }
                    }
                }
            }
        }
    }
}