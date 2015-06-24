trigger UpdateRangeForMFViewOnProperty on Unit__c (after insert, after update) {
     List<String> unitIds = new List<String>{};
    
    for(Unit__c u: Trigger.new){
        unitIds.add( u.Property__c );              
    }
       
    if( unitIds.size() > 0 ){
        String propertyId = unitIds.get(0);
        Boolean status = true; 
        List<Property__c> lstProperties = [ SELECT Id, Price__c, Multi_Family_Property__c FROM Property__c WHERE Id =:propertyId Limit 1];
        if( lstProperties.size() > 0 ) {
            Property__c currentProperty = lstProperties.get(0);    
            List<Integer> Rent_list = new List<Integer>();
            List<Integer> bath_list = new List<Integer>();
            List<Integer> bed_list = new List<Integer>(); 
            List<Integer> squarefeet_list = new List<Integer>();
            String rentRange = '';
            String square_feet_min = '0';
            String square_feet_max = '0';
            String sqftRange = ''; 
            String bedRange = ''; 
            String bathRange = ''; 
                    
            List<Unit__c> lstUnits = [ SELECT Id, Active__c, Rent_Range__c,Effective_Rent__c,Market_Rent__c,Maximum_Rent__c,Minimum_Rent__c,
                                        Bathrooms__c,Bedrooms__c,Made_Ready_Date__c,Available_On__c, Square_Feet__c, Property__r.Multi_Family_Property__c 
                                      FROM 
                                        Unit__c  
                                      WHERE 
                                        Property__r.Id =: currentProperty.Id  AND Is_Model_Unit__c = false AND Is_Waitlist__c = false];
            for( Unit__c u: lstUnits) {  
                if( u.Active__c == true || ( u.Active__c == false && u.Made_Ready_Date__c != NULL && u.Available_On__c != NULL && u.Available_On__c <= System.today() &&  u.Made_Ready_Date__c <  u.Available_On__c )){
                    if( u.Maximum_Rent__c != null && u.Minimum_Rent__c != null ){   
                        Rent_list.add(Integer.valueOf(u.Maximum_Rent__c)); 
                        Rent_list.add(Integer.valueOf(u.Minimum_Rent__c));
                    } else if( u.Effective_Rent__c > 0 && u.Effective_Rent__c != null ) {  
                        Rent_list.add(Integer.valueOf(u.Effective_Rent__c.round())); 
                    } else if( u.Market_Rent__c > 0 && u.Market_Rent__c != null) { 
                        Rent_list.add(Integer.valueOf(u.Market_Rent__c.round())); 
                    }  
                    
                    if(u.Square_Feet__c != null) 
                    { 
                        if(u.Square_Feet__c.contains('-')){ 
                            square_feet_min = u.Square_Feet__c.substringBefore('-');
                            square_feet_min = square_feet_min.trim(); 
                            square_feet_max = u.Square_Feet__c.substringAfter('-');
                            square_feet_max = square_feet_max.trim(); 
                            square_feet_max = square_feet_max.replaceAll('[^.0-9]', ''); 
                            squarefeet_list.add(Integer.valueOf(square_feet_max));
                        }  else { 
                            square_feet_min = u.Square_Feet__c;                        
                        }  
                        square_feet_min = square_feet_min.replaceAll('[^.0-9]', ''); 
                        squarefeet_list.add(Integer.valueOf(square_feet_min));
                    }   
                    
                    if(u.Bathrooms__c != null) 
                    {  
                        bath_list.add(Integer.valueOf(u.Bathrooms__c)); 
                    } 
                    if(u.Bedrooms__c != null) 
                    {  
                        bed_list.add(Integer.valueOf(u.Bedrooms__c)); 
                    } 
                }
            }
            if(Rent_list.size()>0){
                Rent_list.sort(); 
                Integer min_rent = Rent_list.get(0);
                Integer max_rent = Rent_list.get(Rent_list.size()-1);  
                rentRange = '$' + min_rent +'  -  $' + max_rent; 
            }  
            if(squarefeet_list.size()>0){
                squarefeet_list.sort(); 
                Integer min_sqfeet = squarefeet_list.get(0);
                Integer max_sqfeet = squarefeet_list.get(squarefeet_list.size()-1);  
                sqftRange = min_sqfeet +'  -  ' + max_sqfeet; 
            }  
            if(bath_list.size()>0){
                bath_list.sort(); 
                Integer min_bath = bath_list.get(0);
                Integer max_bath = bath_list.get(bath_list.size()-1);  
                bathRange = min_bath +'  -  ' + max_bath; 
            }  
            if(bed_list.size()>0){
                bed_list.sort(); 
                Integer min_bed = bed_list.get(0);
                Integer max_bed = bed_list.get(bed_list.size()-1);  
                bedRange = min_bed +'  -  ' + max_bed; 
            }  
            currentProperty.Rent_Range__c = rentRange;
            currentProperty.Square_Feet_Range__c = sqftRange;
            currentProperty.Bath_Range__c = bathRange;
            currentProperty.Bed_Range__c = bedRange;
            
            update currentProperty;  
        }
    }
}