trigger UpdatePropertyPriceRange on Unit__c (after insert,after update) {

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
           
            List<Unit__c> lstUnits = [ SELECT 
                                      		Id,Property__c,X1_Month_Lease__c,X2_Month_Lease__c,X3_Month_Lease__c,
                                      		X4_Month_Lease__c,X5_Month_Lease__c,X6_Month_Lease__c,X7_Month_Lease__c,
                                      		X8_Month_Lease__c,X9_Month_Lease__c,X10_Month_Lease__c,X11_Month_Lease__c,
                                      		X12_Month_Lease__c,X13_Month_Lease__c,X14_Month_Lease__c,X24_Month_Lease__c
                                      FROM 
                                      		Unit__c 
                                      WHERE Property__c =: currentProperty.Id AND Active__c =:status ];
        
            double unit_min_rent = 0,unit_max_rent = 0, property_price = 0, index = 0, minimum_rent, maximum_rent;  
            LIST<double> payTermValues = new LIST<double>{}; 
            integer n = 0,i;
            for( Unit__c tmpunit: lstUnits) { 
				
				if( tmpunit.X1_Month_Lease__c != null ) {
				  payTermValues.add(tmpunit.X1_Month_Lease__c );
				  n = n+1;
				} 
				
				if( tmpunit.X2_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X2_Month_Lease__c );    
				   n = n+1;
				} 
				
				if( tmpunit.X3_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X3_Month_Lease__c );     
				   n = n+1;
				} 
				
				if( tmpunit.X4_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X4_Month_Lease__c );
				   n = n+1;
				}
					
				if( tmpunit.X5_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X5_Month_Lease__c );
				   n = n+1;
				}
				
				if( tmpunit.X6_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X6_Month_Lease__c );
				   n = n+1;
				}
				
				if( tmpunit.X7_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X7_Month_Lease__c );
				   n = n+1;
				}
				
				if( tmpunit.X8_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X8_Month_Lease__c );
				   n = n+1;
				}
				
				if( tmpunit.X9_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X9_Month_Lease__c );
				   n = n+1;
				}
				
				if( tmpunit.X10_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X10_Month_Lease__c );
				   n = n+1;
				}
				
				if( tmpunit.X11_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X11_Month_Lease__c );
				   n = n+1;
				}
				
				if( tmpunit.X12_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X12_Month_Lease__c );
				   n = n+1;
				}
				
				if( tmpunit.X13_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X13_Month_Lease__c );
				   n = n+1;
				}
				
				if( tmpunit.X14_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X14_Month_Lease__c );
				   n = n+1;
				}
					
				if( tmpunit.X24_Month_Lease__c != null ) {
				   payTermValues.add( tmpunit.X24_Month_Lease__c );
				   n = n+1;
				}
				system.debug(payTermValues);
				if (n == 1)
				{
					minimum_rent = payTermValues[0];
					maximum_rent = payTermValues[0];            
				} 
				
				system.debug(payTermValues.size());
				
			}
			
			if( payTermValues.size() > 1 ) {
				if (payTermValues[0] > payTermValues[1]){
				  maximum_rent = payTermValues[0];
				  minimum_rent = payTermValues[1];
				} else {
				  maximum_rent = payTermValues[1];
				  minimum_rent = payTermValues[0];
				} 
				
				 for (i = 2; i<n; i++){        
					if (payTermValues[i] >  maximum_rent)     
						maximum_rent = payTermValues[i];
			   
					else if (payTermValues[i] < minimum_rent)     
						 minimum_rent = payTermValues[i];
				}
			} else {
				if( payTermValues.size() == 1 ){
					 minimum_rent = payTermValues[0];
					 maximum_rent = payTermValues[0];
				}
				else 
				{
					minimum_rent = 0;
					maximum_rent = 0;
				}
			}
				
			unit_min_rent = minimum_rent.round();
			unit_max_rent = maximum_rent.round();
				
			 
            if( currentProperty.Multi_Family_Property__c ) {
                if(unit_min_rent == 0 && unit_max_rent == 0) {
                    property_price = 0;
                } else if(unit_min_rent == 0 && unit_max_rent > 0){
                    property_price = unit_max_rent;
                } else if(unit_min_rent > 0 && unit_max_rent > 0){
                    property_price = (unit_min_rent + unit_max_rent)/2;
                }
                
                currentProperty.Price__c = property_price ;
                
                update currentProperty;
            }
        } 
   }
}