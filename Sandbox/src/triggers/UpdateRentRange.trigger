trigger UpdateRentRange on Unit__c (before insert, before update) {        
    
    for(Unit__c u : trigger.new){

        LIST<double> payTermValues = new LIST<double>{};
        Double minimum_rent = 0, maximum_rent = 0; 
        
        if( u.X1_Month_Lease__c != null ) {
            payTermValues.add(u.X1_Month_Lease__c ); 
            System.debug('x1 - ' +u.X1_Month_Lease__c);
        } 
        if( u.X2_Month_Lease__c != null ) {            
            payTermValues.add( u.X2_Month_Lease__c );  
            
        }  
        if( u.X3_Month_Lease__c != null ) {
            payTermValues.add( u.X3_Month_Lease__c );  
        } 
        if( u.X4_Month_Lease__c != null ) {
            payTermValues.add( u.X4_Month_Lease__c ); 
        }
        
        if( u.X5_Month_Lease__c != null ) {
            payTermValues.add( u.X5_Month_Lease__c ); 
            system.debug('x5 - ' +u.X5_Month_Lease__c );
        }
        
        if( u.X6_Month_Lease__c != null ) {
            payTermValues.add( u.X6_Month_Lease__c ); 
        }
        
        if( u.X7_Month_Lease__c != null ) {
            payTermValues.add( u.X7_Month_Lease__c ); 
        }
        
        if( u.X8_Month_Lease__c != null ) {
            payTermValues.add( u.X8_Month_Lease__c ); 
        }
        
        if( u.X9_Month_Lease__c != null ) {
            payTermValues.add( u.X9_Month_Lease__c ); 
        }
        
        if( u.X10_Month_Lease__c != null ) {
            payTermValues.add( u.X10_Month_Lease__c ); 
            System.debug('x10 - ' +u.X10_Month_Lease__c);
        }
        
        if( u.X11_Month_Lease__c != null ) {
            payTermValues.add( u.X11_Month_Lease__c ); 
        }
        
        if( u.X12_Month_Lease__c != null ) {
            payTermValues.add( u.X12_Month_Lease__c ); 
        }
        
        if( u.X13_Month_Lease__c != null ) {
            payTermValues.add( u.X13_Month_Lease__c ); 
        }
        
        if( u.X14_Month_Lease__c != null ) {
            payTermValues.add( u.X14_Month_Lease__c ); 
        }
        
        if( u.X15_Month_Lease__c != null ) {
            payTermValues.add( u.X15_Month_Lease__c ); 
            System.debug('x15 - ' +u.X15_Month_Lease__c);
        }
        
        if( u.X18_Month_Lease__c != null ) {
            payTermValues.add( u.X18_Month_Lease__c ); 
        } 
        
        if( u.X24_Month_Lease__c != null ) {
            payTermValues.add( u.X24_Month_Lease__c ); 
        } 
        
        if( payTermValues.size() > 0 ) {   
            payTermValues.sort();
            minimum_rent = payTermValues.get(0); 
            
            if(payTermValues.size() > 1){
                maximum_rent = payTermValues.get(payTermValues.size()-1);
            }  else { 
                maximum_rent = payTermValues.get(0); 
            }
        } 
        
        u.Minimum_Rent__c = minimum_rent.round();
        u.Maximum_Rent__c = maximum_rent.round();
        u.Rent_Range__c = '$'+minimum_rent.round() + '  -  $' + maximum_rent.round();   
    }
}