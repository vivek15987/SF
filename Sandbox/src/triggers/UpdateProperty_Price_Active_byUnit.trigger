trigger UpdateProperty_Price_Active_byUnit on Unit__c (after insert, after update)
{/*
    List<Unit__c> Units = trigger.New;
    List<Property__c> NeedtoUpdateProeprties = new List<Property__c>();
    
    Set<String> AllIdsOfUnits = new Set<String>();
    
    for( Unit__c u :Units ) {
        if( !AllIdsOfUnits.contains( u.Id ) )
            AllIdsOfUnits.add( u.Id );
    }
    
    Set<String> UniquePropertyIds = new Set<String>();
    List<Unit__c> SFDCUnits = [ Select Id, Active__c, Do_Not_Show__c, Name, Effective_Rent__c, Available_On__c, Leased_Status__c, Occupancy_Status__c, Bathrooms__c,  Market_Rent__c, Bedrooms__c, Square_Feet__c, Property__r.Id, Property__r.Active__c, Property__r.Price__c, Property__r.Multi_Family_Property__c from Unit__c where Id IN :AllIdsOfUnits ];
    for( Unit__c u : SFDCUnits ) 
    {
        if( !UniquePropertyIds.contains( u.Property__r.Id ) )
        {
            UniquePropertyIds.add( u.Property__r.Id );
            Property__c Property = new Property__c();
            Property.Id = u.Property__r.Id;
            
            if( u.Property__r.Active__c != 'New Property Queue' )
                Property.Active__c=( u.Active__c==true ) ? 'Yes' : 'No';
            
            if( u.Market_Rent__c != null ){
                Property.Price__c=u.Market_Rent__c;
            } else if( u.Effective_Rent__c != null ){
                Property.Price__c=u.Effective_Rent__c;
            } else {
                Property.Price__c=0;
            }
            
            if( u.Square_Feet__c != null && u.Square_Feet__c != '' ){
                Property.Square_Footage__c = Integer.valueOf( u.Square_Feet__c );
            } else {
                Property.Square_Footage__c = NULL;
            }
            
            if( u.Bedrooms__c != null  ){
                Property.Bed_Count__c = u.Bedrooms__c;
            }else {
                Property.Bed_Count__c = NULL;
            }
            
            if( u.Bathrooms__c != null  ){
                Property.Bath_Count__c = u.Bathrooms__c;
            }else {
                Property.Bath_Count__c = NULL;
            }
            
            if( u.Name != null && u.Name != ''  ){
                Property.Customer_Unit_ID__c = u.Name;
            }else {
                Property.Customer_Unit_ID__c = NULL;
            }
            
            if( u.Occupancy_Status__c != null && u.Leased_Status__c != null ) {
                Property.Customer_Status__c = u.Occupancy_Status__c + ' ' +  u.Leased_Status__c; 
            } else if( u.Occupancy_Status__c == null && u.Leased_Status__c != null ) {
                Property.Customer_Status__c = u.Leased_Status__c;
            } else if( u.Occupancy_Status__c != null && u.Leased_Status__c == null ) {
                Property.Customer_Status__c = u.Occupancy_Status__c;
            } else {
                Property.Customer_Status__c = NULL;
            } 
                        
            if( u.Available_On__c != null )  {
                Property.Date_Available__c =  u.Available_On__c;
            } else {
                Property.Date_Available__c =  NULL;
            }
 		
            Property.Do_Not_Show__c = ( true == u.Do_Not_Show__c ? true :false );
			            
            if( u.Property__r.Multi_Family_Property__c==false )
                NeedtoUpdateProeprties.add( Property );
        }
    }
    update NeedtoUpdateProeprties;
    */
}