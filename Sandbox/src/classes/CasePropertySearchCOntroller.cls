public class CasePropertySearchCOntroller {
     
    
    public static LIST<Property__c> properties { get; set; }
    
    public  CasePropertySearchCOntroller () {  
        
    }
    
    public  CasePropertySearchCOntroller (ApexPages.StandardController stc) {
        
    }  
    
    public PageReference myMethod(){       
        return null;
    }   
 
    public static String FilterConditions(String  address, String  cities, String  states, String zipCodes , String selectedbeds,  String selectedbaths) {
        
        List<String> strSelectedAddress = new List<String>(); 
        List<String> arr_address = new List<String>(); 
        
        address = address.trim(); 
        if(address != '') {
            if(address.contains(',')){
                strSelectedAddress = address.split(',');   
                for (String str : strSelectedAddress) {  
                    str = str.trim();
                    if(str != ''){ 
                        arr_address.add('\''+str+'\'');  
                    }
                }   
            } else{ 
                arr_address.add('\''+address.trim()+'\''); 
            }
        }
        String AddressCondition = '';    
        if(arr_address.size() > 0){
            AddressCondition = ' AND Address_Line_1__c IN '+ arr_address;
        }
        
        List<String> strSelectedCities = new List<String>(); 
        List<String> arr_cities = new List<String>();   
        
        cities = cities.trim();
        if(cities != '') {
            if(cities.contains(',')){
                strSelectedCities = cities.split(',');   
                for (String str : strSelectedCities) {  
                    str = str.trim();
                    if(str != ''){ 
                        arr_cities.add('\''+str+'\'');  
                    }
                }   
            } else{
                arr_cities.add('\''+cities.trim()+'\''); 
            }
        }
        String CitiesCondition = '';    
        if(arr_cities.size() > 0){
            CitiesCondition = ' AND City__c IN '+ arr_cities;
        }
    
        List<String> strSelectedStates = new List<String>(); 
        List<String> arr_states = new List<String>();   
        
        states = states.trim();
        if(states != '') {
            if(states.contains(',')){
                strSelectedStates = states.split(',');   
                for (String str : strSelectedStates) {    
                    str = str.trim();
                    if(str != ''){ 
                        arr_states.add('\''+str+'\'');  
                    }
                }   
            } else{
                arr_states.add('\''+states.trim()+'\''); 
            }
        }
        String StatesCondition = '';    
        if(arr_states.size() > 0){
            StatesCondition = ' AND State__c IN '+ arr_states;
        }
           
        List<String> strSelectedZipCodes = new List<String>(); 
        List<String> arr_zipCodes = new List<String>();   
        
        zipCodes = zipCodes.trim();
        if(zipCodes != '') {
            if(zipCodes.contains(',')){
                strSelectedZipCodes = zipCodes.split(',');   
                for (String str : strSelectedZipCodes) {
                    str = str.trim();
                    if(str != ''){ 
                        arr_zipCodes.add('\''+str+'\'');  
                    }
                }   
            } else{
                arr_zipCodes.add('\''+zipCodes.trim()+'\''); 
            }
        }
        String ZipCodesCondition = '';    
        if(arr_zipCodes.size() > 0){
            ZipCodesCondition = ' AND Zip_Code__c IN '+ arr_zipCodes;
        }
      
        Boolean fivePlus = false; 
        Boolean nullBedCount = false; 
        List<String> strSelectedBed = new List<String>(); 
        List<Integer> bedCount = new List<Integer>();  
        if(selectedbeds != '') {
            strSelectedBed = selectedbeds.split('-'); 
            
            for (String str : strSelectedBed) {                       
                if( '5' == str ) {
                    fivePlus = true;
                    bedCount.add(5);
                } else {
                    bedCount.add(Integer.valueof(str.trim()));
                }
                
            }     
        } 
        
        String bedCountCondition = '';
        if(bedCount.size() > 0 ) {
            bedCountCondition += ' Bed_Count__c IN ' + bedCount;
        }
        if(true == fivePlus ) {
            if(bedCountCondition != '' ){
                bedCountCondition += ' OR ';
            }
            bedCountCondition += '  Bed_Count__c >= 5 '; 
        }
        if(bedCount.size() == 6 || true == nullBedCount) {
            if(bedCountCondition != '' ){
                bedCountCondition += ' OR ';
            }
            bedCountCondition += ' Bed_Count__c = NULL ';   
        }
        
        if(bedCountCondition != ''){
            bedCountCondition  = ' AND ( ' + bedCountCondition +  ')'; 
        }   
    
        Boolean bathCountFivePlus = false; 
        Boolean nullBathCount = false; 
        List<String> strSelectedBath = new List<String>(); 
        List<Integer> bathCount = new List<Integer>();  
        if(selectedbaths != '') {
            strSelectedBath = selectedbaths.split('-');  
            for (String str : strSelectedBath) {                       
                if( '5' == str ) {
                    bathCountFivePlus = true;
                    bathCount.add(5);
                } else {
                    bathCount.add(Integer.valueof(str.trim()));
                } 
            }     
        } 
        
        String bathCountCondition = '';
        if(bathCount.size() > 0 ) {
            bathCountCondition += ' Bath_Count__c IN ' + bathCount;
        }
        if(true == bathCountFivePlus ) {
            if(bathCountCondition != '' ){
                bathCountCondition += ' OR ';
            }
            bathCountCondition += '  Bath_Count__c >= 5 '; 
        }
        if(bathCount.size() == 6 || true == nullBathCount) {
            if(bathCountCondition != '' ){
                bathCountCondition += ' OR ';
            }
            bathCountCondition += ' Bath_Count__c = NULL ';   
        }
        
        if(bathCountCondition != ''){
            bathCountCondition  = ' AND ( ' + bathCountCondition +  ')'; 
        }     
        
        String filterConditions =  AddressCondition +CitiesCondition + StatesCondition + ZipCodesCondition + bedCountCondition + bathCountCondition;
        System.debug('Filter conditions '+ filterConditions);
        return filterConditions;
    } 
    
    @RemoteAction 
    public static Integer GetPropertiesCount( String accountId,  String  address, String  cities, String  states, String zipCodes , String selectedbeds,  String selectedbaths, String additionalFilters) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        }  
        String filterConditions =  FilterConditions( address, cities, states, zipCodes, selectedbeds, selectedbaths);
        Integer propertyCount = 0;
        String sql   = 'SELECT COUNT() FROM Property__c  WHERE Account__c =  :accountId  ' + filterConditions + additionalFilters;
        System.debug('SOQL STRING OF PROPERTY COUNT'+sql);
        propertyCount =  Database.countQuery( sql );
        
        System.debug('Integer count' +propertyCount);
        return propertyCount; 
    }
    @RemoteAction
    public static List<Property__c>  GetLocationFiltersData(String accountId){
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
         
        List<Property__c> newProperties = new List<Property__c>();   
        
        properties = [ SELECT 
                      Id,Address_Line_1__c, Zip_Code__c, City__c, State__c   
                      FROM Property__c 
                      WHERE Account__c =: accountId  
                      ORDER BY Name ASC ];
        return properties;
    }
    
    @RemoteAction 
    public static List<Property__c> searchProperties( String accountId, Boolean useDaysOnMarket, Integer startCount, Integer totalCount, String  address, String  cities, String  states, String zipCodes, String selectedbeds, String selectedbaths, String additionalFilters) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
       String orderByDaysOnMarket = '';
        if(true == useDaysOnMarket){
            System.debug('set true ');
            orderByDaysOnMarket =' Days_on_Market__c DESC NULLS LAST, ';
        }  
        
        String filterConditions =  FilterConditions( address, cities, states, zipCodes, selectedbeds, selectedbaths );
        
        List<Property__c> newProperties  = new List<Property__c>(); 
        String sql   = 'SELECT Id, Active__c, Address_Line_1__c, Address_Line_2__c, Name, Zip_Code__c, City__c, Square_Footage__c, Pet_Policy__c, ' +
            ' Bed_Count__c, Bath_Count__c, Price__c, Move_in_Special1__c, Do_Not_Show__c, State__c, Street_Number__c, Priority_Property__c, GeoDs__c'+
            ' FROM Property__c  WHERE Account__c =: accountId ' + filterConditions + additionalFilters +
            ' ORDER BY Priority_Property__c DESC, '+ orderByDaysOnMarket +' Name ASC';
        System.debug('SEARCH PROPERTIES SOQL' + sql);
        
        properties =  Database.query( sql ); 
         
        Integer prop_count = properties.size();
        if(properties.size() > 0){  
            totalCount = totalCount + startCount;
            for(Integer i = startCount; i < totalCount; i++){  
                if( i >= prop_count   ) {
                    break;
                }
                
                Property__c newSubProperty = new Property__c();
      
                newSubProperty.Id = properties[i].Id;
                newSubProperty.Active__c =  properties[i].Active__c; 
                newSubProperty.Name =  properties[i].Name; 
                newSubProperty.Address_Line_1__c  =  properties[i].Address_Line_1__c; 
                newSubProperty.Address_Line_2__c  =  properties[i].Address_Line_2__c; 
                newSubProperty.Zip_Code__c =  properties[i].Zip_Code__c; 
                newSubProperty.City__c =  properties[i].City__c;
                newSubProperty.Pet_Policy__c = properties[i].Pet_Policy__c;
                newSubProperty.Bed_Count__c =  properties[i].Bed_Count__c; 
                newSubProperty.Bath_Count__c =  properties[i].Bath_Count__c; 
                newSubProperty.Price__c  =  properties[i].Price__c;  
                newSubProperty.Square_Footage__c  =  properties[i].Square_Footage__c;  
                newSubProperty.Move_in_Special1__c  =  properties[i].Move_in_Special1__c; 
                newSubProperty.Do_Not_Show__c =  properties[i].Do_Not_Show__c; 
                newSubProperty.State__c =  properties[i].State__c;
                newSubProperty.Street_Number__c  =  properties[i].Street_Number__c; 
                newSubProperty.Priority_Property__c =  properties[i].Priority_Property__c;  
                
                newProperties.add(newSubProperty);  
            }
        } 
        return newProperties;    
    } 

}