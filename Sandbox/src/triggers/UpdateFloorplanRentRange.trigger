trigger UpdateFloorplanRentRange on Unit__c (after insert,after update) {
    
    List<String> unitIds = new List<String>{};
    List<Integer> selMinUnitsRange = new List<Integer>();
    List<Integer> selMaxUnitsRange = new List<Integer>();
    
    for(Unit__c u: Trigger.new){
        unitIds.add( u.Floor_Plan__c );              
    }
    Boolean status = true; 
    Boolean count = false; 
    String rentRange = '';   
    if( unitIds.size() > 0 ){
        String floorplanId = unitIds.get(0);
        List<Floor_Plan__c> lstFloorplans = [ SELECT Id,Rent_Range__c, Effective_Rent__c, Market_Rent__c, Effective_Rent_Max__c,Effective_Rent_Min__c, Market_Rent_Max__c, Market_Rent_Min__c from Floor_Plan__c WHERE Id =:floorplanId Limit 1];
        if( lstFloorplans.size() > 0 ) {
            Floor_Plan__c currentFloorplan = lstFloorplans.get(0);   
            List<Unit__c> lstUnits = [ SELECT Id,Minimum_Rent__c,Maximum_Rent__c,Effective_Rent__c, Market_Rent__c, Made_Ready_Date__c,Active__c, Is_Model_Unit__c, Is_Waitlist__c,Available_On__c from Unit__c WHERE Is_Model_Unit__c = false AND Is_Waitlist__c = false AND ( Active__c = true  OR ( Active__c = false  AND Made_Ready_Date__c != NULL AND Available_On__c != NULL  AND Available_On__c <= today ) ) AND Floor_Plan__c =: currentFloorplan.Id ];
           
            double floorplan_min_rent = 0,floorplan_max_rent = 0;  
            if( lstUnits.size() > 0){ 
             
                for( Unit__c tmpunit: lstUnits) {
                    if(false != tmpunit.Active__c || tmpunit.Made_Ready_Date__c >= tmpunit.Available_On__c) {
                        count = true;
                        if( tmpunit.Minimum_Rent__c != null && tmpunit.Maximum_Rent__c != null && tmpunit.Maximum_Rent__c != 0 && tmpunit.Minimum_Rent__c <= tmpunit.Maximum_Rent__c  ){
                            selMinUnitsRange.add(Integer.valueOf(tmpunit.Minimum_Rent__c.round()));
                            selMaxUnitsRange.add(Integer.valueOf(tmpunit.Maximum_Rent__c.round()));
                        } else if( tmpunit.Effective_Rent__c > 0 && tmpunit.Effective_Rent__c != null ) { 
                            selMinUnitsRange.add(Integer.valueOf(tmpunit.Effective_Rent__c.round()));
                            selMaxUnitsRange.add(Integer.valueOf(tmpunit.Effective_Rent__c.round()));
                        } else if( tmpunit.Market_Rent__c > 0 && tmpunit.Market_Rent__c != null) {  
                            selMinUnitsRange.add(Integer.valueOf(tmpunit.Market_Rent__c.round()));
                            selMaxUnitsRange.add(Integer.valueOf(tmpunit.Market_Rent__c.round()));
                        } 
                    }
                } 
            }    
            
            if(count == true ){
                if(selMinUnitsRange.size() > 0 && selMaxUnitsRange.size() >0){
                    selMinUnitsRange.sort();
                    selMaxUnitsRange.sort();
                    floorplan_min_rent = selMinUnitsRange.get(0);
                    floorplan_max_rent = selMaxUnitsRange.get(selMaxUnitsRange.size()-1);           
                }    
            } else if( currentFloorplan.Effective_Rent__c != null && currentFloorplan.Effective_Rent__c > 0){
                floorplan_min_rent = currentFloorplan.Effective_Rent__c; 
                floorplan_max_rent = currentFloorplan.Effective_Rent__c;  
            } else if( currentFloorplan.Effective_Rent_Min__c != null && currentFloorplan.Effective_Rent_Max__c != null && currentFloorplan.Effective_Rent_Max__c >= currentFloorplan.Effective_Rent_Min__c ){ 
                floorplan_min_rent = currentFloorplan.Effective_Rent_Min__c;    
                floorplan_max_rent = currentFloorplan.Effective_Rent_Max__c;   
            } else if(currentFloorplan.Market_Rent__c != null && currentFloorplan.Market_Rent__c > 0) { 
                floorplan_min_rent = currentFloorplan.Market_Rent__c; 
                floorplan_max_rent = currentFloorplan.Market_Rent__c;  
            } else if(currentFloorplan.Market_Rent_Min__c != null && currentFloorplan.Market_Rent_Max__c != null && currentFloorplan.Market_Rent_Max__c >= currentFloorplan.Market_Rent_Min__c) {
                floorplan_min_rent = currentFloorplan.Market_Rent_Min__c;    
                floorplan_max_rent = currentFloorplan.Market_Rent_Max__c;  
            } 
            
            rentRange = '$' + floorplan_min_rent.round() +'  -  $' + floorplan_max_rent.round(); 
            currentFloorplan.Rent_Range__c = rentRange;
            
            update currentFloorplan;     
        } 
   }
}