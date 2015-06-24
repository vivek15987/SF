public with sharing class MFController{
    
    //public static LIST<Unit__c> units { get; set; }
    public static LIST<String> FloorPlanIds = new List<String>();
    public static LIST<Floor_Plan__c> floorplanImages { get; set; }
    
    public  MFController() {  
        
    }
    
    public  MFController(ApexPages.StandardController stc) {
        
    }   
    
    public PageReference myMethod(){       
        return null;
    }   
    
    public static Date dateRetrieval( string moveInDate ) {        
        
        String[] strDate = moveInDate.split('-');
        Integer myIntDay = integer.valueOf(strDate[2]);
        Integer myIntMonth = integer.valueOf(strDate[1]);
        Integer myIntYear = integer.valueOf(strDate[0]);
        return Date.newInstance(myIntYear, myIntMonth, myIntDay);       
    }
    
    @RemoteAction
    public static List<Map<String,String>> searchFloorPlansData( string moveInDate, string propertyId, string selectedbeds) {                          
        
        Date d = dateRetrieval( moveInDate );
        Boolean fivePlus = false;
        Boolean showAll = false;
        
        List<String> strSelectedBed = new List<String>(); 
        List<Decimal> bedCount = new List<Decimal>(); 
        // AggregateResult[] floorplans = new AggregateResult[]{};
        List<Unit__c> floorplan_terms = new List<Unit__c>();
        List<Unit__c> floorplans = new List<Unit__c>();
        
        
        List<Floor_Plan__c> lstFloorPlan =  new List<Floor_Plan__c>();
        List<Map<String,String>> result = new List<Map<String,String>>();
        List<Integer> month_terms = new List<Integer>{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 24}; 
            List<Integer> selTerms = new List<Integer>(); 
        List<Integer> selUnitsRange = new List<Integer>(); 
        Integer unit_min_term = 0; 
        Integer unit_max_term = 0; 
        Integer unit_min_rent = 0; 
        Integer unit_max_rent = 0; 
        Integer  firstcnt = 0;
        String terms = '';
        String term_range = ''; 
        String fp_rent_range = ''; 
        String fp_square_feet = ''; 
        Boolean is_available_units = false;
        
        double floorplan_min_rent = 0,floorplan_max_rent = 0; 
        strSelectedBed = selectedbeds.split('-');       
        
        for (String str : strSelectedBed) {  
            
            if( '6' == str ) {
                fivePlus = true;
                bedCount.add(5);
            } else {
                bedCount.add(Decimal.valueOf(str.trim()));
            }
            if( '0' == str ) { 
                bedCount.add(0.5);
            } 
        } 
        if( bedCount.size() == 7 ) {
            showAll = true;
        } 
        
        System.debug('Total BedCount'+bedCount);
        if( true == showAll ) {
            lstFloorPlan = [ SELECT Id,Name,Rent_Range__c,Effective_Rent__c,Effective_Rent_Min__c,Effective_Rent_Max__c,Market_Rent__c,Market_Rent_Min__c ,Market_Rent_Max__c,Square_Feet__c,SQ_FT_Min__c,SQ_FT_Max__c,Bedrooms__c,Bathrooms__c FROM Floor_Plan__c Where Active__c = true AND Property__c =:propertyId ORDER BY Bedrooms__c ASC];              
        } else if( false == showAll && true == fivePlus) {
            lstFloorPlan = [ SELECT Id,Name,Rent_Range__c,Effective_Rent__c,Effective_Rent_Min__c,Effective_Rent_Max__c,Market_Rent__c,Market_Rent_Min__c ,Market_Rent_Max__c,Square_Feet__c,SQ_FT_Min__c,SQ_FT_Max__c,Bedrooms__c,Bathrooms__c FROM Floor_Plan__c Where Active__c = true AND Property__c =:propertyId AND (Bedrooms__c IN :bedCount OR Bedrooms__c >= 5) ORDER BY Bedrooms__c ASC]; 
        } else {
            lstFloorPlan = [ SELECT Id,Name,Rent_Range__c,Effective_Rent__c,Effective_Rent_Min__c,Effective_Rent_Max__c,Market_Rent__c,Market_Rent_Min__c,Market_Rent_Max__c,Square_Feet__c,SQ_FT_Min__c,SQ_FT_Max__c,Bedrooms__c,Bathrooms__c FROM Floor_Plan__c Where Active__c = true AND Property__c =:propertyId AND Bedrooms__c IN :bedCount ORDER BY Bedrooms__c ASC]; 
        }
        
        
        for( Floor_Plan__c fp : lstFloorPlan ) {
            Map<String,String> tmp = new Map<String,String>(); 
            Integer units_lst_count = 0;
            
            if( false == fivePlus ){  
                floorplan_terms = [ SELECT 
                                   Unit__c.Floor_Plan__r.Id, Maximum_Rent__c,Minimum_Rent__c, Rent_Range__c, Effective_Rent__c, Market_Rent__c,External_Unit_Description__c,
                                   Active__c,Available_On__c,Made_Ready_Date__c,Is_Model_Unit__c, Is_Waitlist__c, X1_Month_Lease__c ,X2_Month_Lease__c,X3_Month_Lease__c,
                                   X4_Month_Lease__c,X5_Month_Lease__c,X6_Month_Lease__c,X7_Month_Lease__c,X8_Month_Lease__c,X9_Month_Lease__c,
                                   X10_Month_Lease__c,X11_Month_Lease__c,X12_Month_Lease__c, X13_Month_Lease__c, X14_Month_Lease__c,X15_Month_Lease__c,X18_Month_Lease__c,X24_Month_Lease__c 
                                   FROM 
                                   Unit__c 
                                   WHERE 
                                   Is_Model_Unit__c = false AND Is_Waitlist__c = false 
                                   AND ( Active__c = true  OR ( Active__c = false AND Made_Ready_Date__c != NULL AND Available_On__c != NULL AND Available_On__c <=:d ) )
                                   AND Unit__c.Property__r.Id = :propertyId AND Unit__c.Floor_Plan__r.Id =:fp.Id
                                   AND Unit__c.Floor_Plan__r.Bedrooms__c IN :bedCount  
                                  ]; 
            } else { 
                floorplan_terms = [ SELECT 
                                   Unit__c.Floor_Plan__r.Id, Maximum_Rent__c,Minimum_Rent__c, Rent_Range__c, Effective_Rent__c, Market_Rent__c,External_Unit_Description__c,
                                   Active__c,Available_On__c,Made_Ready_Date__c,Is_Model_Unit__c, Is_Waitlist__c, X1_Month_Lease__c ,X2_Month_Lease__c,X3_Month_Lease__c,
                                   X4_Month_Lease__c,X5_Month_Lease__c,X6_Month_Lease__c,X7_Month_Lease__c,X8_Month_Lease__c,X9_Month_Lease__c,X10_Month_Lease__c,X11_Month_Lease__c,
                                   X12_Month_Lease__c, X13_Month_Lease__c, X14_Month_Lease__c,X15_Month_Lease__c,X18_Month_Lease__c,X24_Month_Lease__c
                                   FROM
                                   Unit__c 
                                   WHERE 
                                   Is_Model_Unit__c = false AND Is_Waitlist__c = false 
                                   AND ( Active__c = true  OR ( Active__c = false  AND Made_Ready_Date__c != NULL AND Available_On__c != NULL  AND Available_On__c <=:d ) )
                                   AND (Unit__c.Floor_Plan__r.Bedrooms__c IN :bedCount OR Unit__c.Floor_Plan__r.Bedrooms__c >= 5 OR Unit__c.Floor_Plan__r.Bedrooms__c = NULL)
                                   AND Unit__c.Property__r.Id = :propertyId AND  Unit__c.Floor_Plan__r.Id =:fp.Id
                                  ]; 
            }
            
            if(floorplan_terms.size() >0 ) { 
                
                firstcnt = 0;
                for( Unit__c fpterms : floorplan_terms ) {
                    
                    if(false == fpterms.Active__c && fpterms.Made_Ready_Date__c < fpterms.Available_On__c) {   
                        fpterms.clear();
                    } else{
                        
                        is_available_units = true;
                        for (Integer i=0;i<month_terms.size(); i++) {
                            terms = string.valueOf( month_terms.get(i));    
                            if(fpterms.get('X'+terms+'_Month_Lease__c') != null){
                                selTerms.add( Integer.valueOf(month_terms[i]));  
                            } 
                        }  
                        
                        units_lst_count++;
                        
                        if( fpterms.Rent_Range__c != null && fpterms.Rent_Range__c != '$0  -  $0'){ 
                            selUnitsRange.add(Integer.valueOf(fpterms.Maximum_Rent__c.round()));
                            selUnitsRange.add(Integer.valueOf(fpterms.Minimum_Rent__c.round()));
                        } else if( fpterms.Effective_Rent__c > 0 && fpterms.Effective_Rent__c != null ) { 
                            selUnitsRange.add(Integer.valueOf(fpterms.Effective_Rent__c.round()));
                        } else if( fpterms.Market_Rent__c > 0 && fpterms.Market_Rent__c != null) {  
                            selUnitsRange.add(Integer.valueOf(fpterms.Market_Rent__c.round()));
                        }  
                    }
                } 
                
                if(selTerms.size() > 0) {
                    selTerms.sort();
                    unit_min_term = selTerms.get(0);
                    unit_max_term = selTerms.get(selTerms.size()-1);
                    
                    term_range = string.valueOf(unit_min_term )+ ' - ' + string.valueOf(unit_max_term);
                    selTerms.clear();
                } else{
                    term_range = 'N/A';
                }
                
                if(selUnitsRange.size() > 0){
                    selUnitsRange.sort();
                    unit_min_rent = selUnitsRange.get(0);
                    unit_max_rent = selUnitsRange.get(selUnitsRange.size()-1);
                    
                    fp_rent_range = '$'+string.valueOf(unit_min_rent )+ ' - $' + string.valueOf(unit_max_rent);
                    selUnitsRange.clear();
                } else{
                    fp_rent_range = 'N/A';
                } 
            } 
            if( is_available_units == false || floorplan_terms.size() == 0 ){
                term_range = 'N/A';
                //fp_rent_range = 'N/A';
                
                if( fp.Effective_Rent__c != null && fp.Effective_Rent__c > 0){
                    floorplan_min_rent = fp.Effective_Rent__c; 
                    floorplan_max_rent = fp.Effective_Rent__c; 
                } else if( fp.Effective_Rent_Min__c != null && fp.Effective_Rent_Max__c != null && fp.Effective_Rent_Max__c >= fp.Effective_Rent_Min__c ){ 
                    floorplan_min_rent = fp.Effective_Rent_Min__c;    
                    floorplan_max_rent = fp.Effective_Rent_Max__c;    
                } else if(fp.Market_Rent__c != null && fp.Market_Rent__c > 0) { 
                    floorplan_min_rent = fp.Market_Rent__c; 
                    floorplan_max_rent = fp.Market_Rent__c; 
                } else if(fp.Market_Rent_Min__c != null && fp.Market_Rent_Max__c != null && fp.Market_Rent_Max__c >= fp.Market_Rent_Min__c) {
                    floorplan_min_rent = fp.Market_Rent_Min__c;    
                    floorplan_max_rent = fp.Market_Rent_Max__c;    
                } 
                if(floorplan_min_rent == 0 && floorplan_max_rent == 0){
                    fp_rent_range = 'N/A';
                } else{
                    fp_rent_range = '$' + floorplan_min_rent.round() +'  -  $' + floorplan_max_rent.round(); 
                }
            }
            tmp.put( 'Term_Range', term_range);
            tmp.put( 'Id', fp.Id );
            tmp.put( 'Name', fp.Name ); 
            tmp.put( 'Units_count', String.valueOf(units_lst_count)); 
            tmp.put( 'Rent_Range__c', fp_rent_range );
            
            if( fp.Square_Feet__c != null ) {
                fp_square_feet = fp.Square_Feet__c; 
            } else if( fp.SQ_FT_Min__c != null || fp.SQ_FT_Min__c != null )
            {  
                if( fp.SQ_FT_Max__c != null && fp.SQ_FT_Max__c > 0 ){
                    if(fp.SQ_FT_Min__c != null && fp.SQ_FT_Min__c > 0 && fp.SQ_FT_Min__c <= fp.SQ_FT_Max__c ){ 
                        fp_square_feet = String.valueOf(fp.SQ_FT_Min__c) + ' - ' + String.valueOf(fp.SQ_FT_Max__c);
                    } else {
                        fp_square_feet = String.valueOf(fp.SQ_FT_Max__c);
                    } 
                } else{
                    fp_square_feet = String.valueOf(fp.SQ_FT_Min__c);
                }                     
            } else{
                fp_square_feet = 'N/A';
            }
            tmp.put( 'Square_Feet__c', fp_square_feet); 
            
            if( fp.Bedrooms__c != null ) {
                tmp.put( 'Bedrooms__c', String.valueOf(fp.Bedrooms__c.round()));
            } else {
                tmp.put( 'Bedrooms__c', 'N/A');
            }
            
            if( fp.Bathrooms__c != null ) {
                tmp.put( 'Bathrooms__c', String.valueOf(fp.Bathrooms__c.round()));
            } else {
                tmp.put( 'Bathrooms__c', 'N/A');
            }
            
            result.add(tmp);  
            term_range = '';
            fp_rent_range = '';
            selTerms.clear();
            selUnitsRange.clear();
        } 
        return result;
    }
    
    @RemoteAction 
    // public static List<Unit__c> searchUnitsData( string moveInDate, string propertyId, string selectedbeds, string advanceFilters, string selectedFloorPlan ) {    
    public static List<FPUnits> searchUnitsData( string moveInDate, string propertyId, string selectedbeds, string advanceFilters, string selectedFloorPlan ) {   
        Date move_in_date = dateRetrieval( moveInDate );  
        Boolean fivePlus = false; 
        List<String> strSelectedBed = new List<String>(); 
        List<Decimal> bedCount = new List<Decimal>();  
        List<Unit__c> units  = new List<Unit__c>();         
        String sqlWhere  = '';
        String  sql = '';
        String isNullBedroom = '';
        String isFloorplanSelected = '';
        String square_feet_min = '0'; 
        
        strSelectedBed = selectedbeds.split('-'); 
        
        for (String str : strSelectedBed) {                       
            if( '6' == str ) {
                fivePlus = true;
                bedCount.add(5);
            } else {
                bedCount.add(Decimal.valueof(str.trim()));
            }
            if( '0' == str ) { 
                bedCount.add(0.5);
            } 
        }     
        if(bedCount.size() == 7 ) {
            isNullBedroom = ' OR Bedrooms__c = NULL ';   
        }
        if( 'All' != selectedFloorPlan ) {
            isFloorplanSelected = ' AND Unit__c.Floor_Plan__r.Id = \'' + selectedFloorPlan + '\'';
        }  
        
        if( false == fivePlus ) { 
            sqlWhere = ' WHERE Is_Model_Unit__c = false AND Is_Waitlist__c = false AND ( Active__c = true  OR ( Active__c = false AND Made_Ready_Date__c != NULL AND Available_On__c != NULL AND Available_On__c <=:move_in_date ) ) AND Unit__c.Property__r.Id = \'' + propertyId + '\' '+ advanceFilters + ' AND Bedrooms__c IN' + bedCount + isFloorplanSelected;
            sql   = 'SELECT Floor_Plan__r.Name,Floor_Plan__r.Id,Name,Building_Name_Number__c,External_Unit_Description__c, Level__c, Special_Concession__c,Smoking_Allowed__c,amenities__c,Furnished__c,Pets_Allowed__c,Pets_allowed_notes__c, Rent_Range__c,Effective_Rent__c,Market_Rent__c,Maximum_Rent__c,Minimum_Rent__c,Bathrooms__c,Bedrooms__c,Made_Ready_Date__c,Available_On__c,Active__c,Square_Feet__c,X1_Month_Lease__c ,X2_Month_Lease__c,X3_Month_Lease__c,X4_Month_Lease__c,X5_Month_Lease__c,X6_Month_Lease__c,X7_Month_Lease__c,X8_Month_Lease__c,X9_Month_Lease__c,X10_Month_Lease__c,X11_Month_Lease__c,X12_Month_Lease__c,X13_Month_Lease__c,X14_Month_Lease__c,X15_Month_Lease__c,X18_Month_Lease__c,X24_Month_Lease__c  FROM Unit__c  '+ sqlWhere +'  ORDER BY Active__c DESC';
            units  =  Database.query( sql );
        } else {
            sqlWhere = ' WHERE Is_Model_Unit__c = false AND Is_Waitlist__c = false AND ( Active__c = true  OR ( Active__c = false AND Made_Ready_Date__c != NULL AND Available_On__c != NULL AND Available_On__c <=:move_in_date) )  AND Unit__c.Property__r.Id = \'' + propertyId + '\' '+ advanceFilters + isFloorplanSelected + ' AND ( Bedrooms__c IN' + bedCount + ' OR  Bedrooms__c >= 5 '+ isNullBedroom +')';
            sql   = 'SELECT Floor_Plan__r.Name,Floor_Plan__r.Id,Name,Building_Name_Number__c,External_Unit_Description__c, Level__c,Special_Concession__c,Smoking_Allowed__c,amenities__c,Furnished__c,Pets_Allowed__c,Pets_allowed_notes__c, Rent_Range__c,Effective_Rent__c,Market_Rent__c,Maximum_Rent__c,Minimum_Rent__c,Bathrooms__c,Bedrooms__c,Made_Ready_Date__c,Available_On__c,Active__c,Square_Feet__c, X1_Month_Lease__c ,X2_Month_Lease__c,X3_Month_Lease__c,X4_Month_Lease__c,X5_Month_Lease__c,X6_Month_Lease__c,X7_Month_Lease__c,X8_Month_Lease__c,X9_Month_Lease__c,X10_Month_Lease__c,X11_Month_Lease__c,X12_Month_Lease__c,X13_Month_Lease__c,X14_Month_Lease__c,X15_Month_Lease__c,X18_Month_Lease__c,X24_Month_Lease__c  FROM Unit__c  '+ sqlWhere +'  ORDER BY Active__c DESC';
            units  =  Database.query( sql );
        }  
        List<FPUnits> lstAllUnits = new List<FPUnits>();
        
        for( Unit__c units_lst : units ) {
            if(false == units_lst.Active__c && units_lst.Made_Ready_Date__c < units_lst.Available_On__c) {   
                units_lst.clear(); 
            } else{
                FPUnits fp_units = new FPUnits(); 
                
                if( units_lst.Rent_Range__c != null && units_lst.Rent_Range__c != '$0  -  $0'){   
                    units_lst.put('Rent_Range__c',units_lst.Rent_Range__c);  
                } else if( units_lst.Effective_Rent__c > 0 && units_lst.Effective_Rent__c != null ) {
                    units_lst.put('Rent_Range__c','$' +  String.valueOf(units_lst.Effective_Rent__c.round()) + ' - $' +  String.valueOf(units_lst.Effective_Rent__c.round())); 
                    units_lst.put('Maximum_Rent__c', Integer.valueOf(units_lst.Effective_Rent__c.round()) );
                    units_lst.put('Minimum_Rent__c', Integer.valueOf(units_lst.Effective_Rent__c.round()) );  
                } else if( units_lst.Market_Rent__c > 0 && units_lst.Market_Rent__c != null) {
                    units_lst.put('Rent_Range__c','$' +  String.valueOf(units_lst.Market_Rent__c.round())+' - $' +  String.valueOf(units_lst.Market_Rent__c.round())); 
                    units_lst.put('Maximum_Rent__c',  Integer.valueOf(units_lst.Market_Rent__c.round()));
                    units_lst.put('Minimum_Rent__c',  Integer.valueOf(units_lst.Market_Rent__c.round()) ); 
                } else{ 
                    units_lst.put( 'Rent_Range__c', 'N/A' );  
                } 
                if(units_lst.Available_On__c != null ) { 
                    units_lst.put( 'Made_Ready_Date__c', units_lst.Available_On__c );  
                }
                
                if(units_lst.Square_Feet__c != null) 
                { 
                    if(units_lst.Square_Feet__c.contains('-')){ 
                        square_feet_min = units_lst.Square_Feet__c.substringBefore('-');
                        square_feet_min = square_feet_min.trim(); 
                    }  else { 
                        square_feet_min = units_lst.Square_Feet__c;                        
                    } 
                    
                    square_feet_min = square_feet_min.replaceAll('[^.0-9]', ''); 
                }  
                fp_units.min_square_feet = Decimal.valueOf(square_feet_min);  
                fp_units.Floor_Units = units_lst;   
                
                lstAllUnits.add( fp_units ); 
            }    
        }  
        return lstAllUnits;   
    }
    
    @RemoteAction 
    public static LIST<Floor_Plan__c> getFloorplans( string propertyId) {   
        floorplanImages = [ SELECT Id,Floorplan_Image__c,Bedrooms__c,Bathrooms__c,Special_Concession__c FROM Floor_Plan__c WHERE  Property__c =:propertyId]; 
        return floorplanImages;        
    }
    
    @RemoteAction 
    public static Map<String,Double> getRentRangeSilderVaules ( string propertyId, string moveInDate ) {
        
        Date move_in_date = dateRetrieval( moveInDate );   
        
        AggregateResult[] result = [ SELECT Unit__c.Property__r.Id,Max(Maximum_Rent__c) Max_rent, Min(Minimum_Rent__c) Min_rent, 
                                    Max(Effective_Rent__c) Max_Effective, Max(Market_Rent__c) Max_Market 
                                    FROM Unit__c 
                                    WHERE Is_Model_Unit__c = false AND Is_Waitlist__c = false AND ( Active__c = true  OR (  Made_Ready_Date__c != NULL AND Available_On__c != NULL  AND Active__c = false  AND Available_On__c <=:move_in_date ) )
                                    AND Unit__c.Property__r.Id = :propertyId GROUP BY Unit__c.Property__r.Id
                                   ];
        double min_rent = 0 ,max_rent = 0 ,i= 0;        
        Map<String,Double> slideRenge= new Map<String,Double>();
        
        if(result.size() > 0) { 
            
            for( AggregateResult ar : result ){
                
                if(ar.get('Min_rent') != null )
                {
                    min_rent = double.valueOf(ar.get('Min_rent'));                       
                } else{
                    min_rent = 0;
                } 
                
                if( ar.get('Max_rent') != null && double.valueOf(ar.get('Max_rent')) > max_rent )
                { 
                    max_rent = double.valueOf(ar.get('Max_rent'));
                }
                if( ar.get('Max_Effective') != null &&  max_rent < double.valueOf(ar.get('Max_Effective')) )
                {
                    max_rent = double.valueOf(ar.get('Max_Effective'));
                } 
                if(ar.get('Max_Market') != null  &&  max_rent < double.valueOf(ar.get('Max_Market')) )
                {
                    max_rent = double.valueOf(ar.get('Max_Market')); 
                }  
            } 
        }
        
        slideRenge.put('min', min_rent);
        slideRenge.put('max', max_rent);
        
        return slideRenge;
    }
    
    @RemoteAction  
    public static List<Map<String,String>> getSchools ( string propertyId ) { 
        
        List<Map<String,String>> result = new List<Map<String,String>>(); 
        
        String Latitude = '';
        String Longitude = '';
        
        
        List<Property__c> properties = [ SELECT 
                                        Id, Name, Property__c.Zip_Code_Lookup__r.Longitude__Longitude__s, Property__c.Zip_Code_Lookup__r.Latitude__Latitude__s 
                                        FROM Property__c 
                                        WHERE Id =: propertyId Limit 1];
        
        if(properties.size() > 0){
            
            for( Property__c property : properties) {
                if(property.Zip_Code_Lookup__r.Latitude__Latitude__s != null){
                    Latitude = String.valueOf( property.Zip_Code_Lookup__r.Latitude__Latitude__s);
                }
                if(property.Zip_Code_Lookup__r.Longitude__Longitude__s != null){
                    Longitude = String.valueOf( property.Zip_Code_Lookup__r.Longitude__Longitude__s);
                } 
            }
            
            if(Longitude != '' && Latitude != ''){ 
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http(); 
                String username = 'anyonehome';
                String Api_key = 'yVa8A1)!f439!7!2MYY!Wb6Y8c$p7cZP'; 
                
                String  Name = '';
                String xml = '<?xml version="1.0" encoding="UTF-8" ?><data><auth><loginname>'+username+'</loginname><key>'+Api_key+'</key></auth>'+ 
                    '<request><dataset>SAZ</dataset><method>getSchoolByCoord</method><returnType>json</returnType><count>false</count><parameters><lat>'+Latitude+'</lat><lon>'+Longitude+'</lon></parameters></request></data>';
                
                req.setEndpoint('http://api.maponics.com/interface/');
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                req.setMethod('POST');
                req.setBody('apirequest=' + EncodingUtil.urlEncode(xml, 'UTF-8'));
                if( !System.isBatch() && !test.isRunningTest() ) { 
                    res = http.send(req);    
                } else{ 
                    res.setStatus('OK');
                    res.setBody('[{"resultcode":0,"message":"Return OK","requestid":"172-17272899","request":[[{"mx_id":"FL-DADE-2929-FL-PB92023","nces_disid":"1200390","nces_schid":"120039000390","sch_name":"FIENBERG FISHER K-8 CENTER","ed_level":"P","district_name":"MIAMI-DADE COUNTY SCHOOL DISTRICT"},{"mx_id":"FL-DADE-2929-FL-PB92209","nces_disid":"1200390","nces_schid":"120039000594","sch_name":"MIAMI BEACH SENIOR HIGH SCHOOL","ed_level":"H","district_name":"MIAMI-DADE COUNTY SCHOOL DISTRICT"},{"mx_id":"FL-DADE-2929-FL-PB91540","nces_disid":"1200390","nces_schid":"120039000570","sch_name":"NAUTILUS MIDDLE SCHOOL","ed_level":"M","district_name":"MIAMI-DADE COUNTY SCHOOL DISTRICT"},{"mx_id":"FL-DADE-2929-FL-PB92023","nces_disid":"1200390","nces_schid":"120039000390","sch_name":"FIENBERG FISHER K-8 CENTER","ed_level":"M","district_name":"MIAMI-DADE COUNTY SCHOOL DISTRICT"}]]}]');
                    res.setStatusCode(200);
                }                    
                if (res.getStatusCode() == 200) {   
                    JSONParser parser = JSON.createParser(res.getBody());
                    Map<String,String> tmp = new Map<String,String>();
                    
                    while (parser.nextToken() != null) {
                        
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'sch_name')) {  
                            parser.nextToken();  
                            Name = parser.getText();
                            tmp.put('School_Name', Name);
                            
                        }
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'ed_level')) {  
                            parser.nextToken();  
                            Name = parser.getText();
                            tmp.put('School_Level', Name);
                            
                        }
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'district_name')) {  
                            parser.nextToken();  
                            Name = parser.getText();
                            tmp.put('District_Name', Name); 
                            result.add(tmp);  
                            tmp = new Map<String,String>(); 
                        }  
                    }  
                }   
            } 
        }  
        return result; 
    }
    
    @RemoteAction  
    public static List<SisterProperties> loadSisterProperties ( String sisterPropertyId,String CurrentpropertyId, Decimal lat, Decimal lang ) {  
        List<Property__c> SisterPropertyList = new  List<Property__c>();
        List<SisterProperties> lstSisterProp = new List<SisterProperties>();
        
        if(sisterPropertyId != ''){
            
            SisterPropertyList = [ SELECT Id,Name,Bath_Range__c,Bed_Range__c,Rent_Range__c,Square_Feet_Range__c, Property__c.Geocode__r.geopointe__Latitude__c,Property__c.Geocode__r.geopointe__Longitude__c  FROM Property__c WHERE Sister_Property__c =:sisterPropertyId AND Id !=: CurrentpropertyId];            
            for( Property__c prop_lst : SisterPropertyList ) { 
                SisterProperties sis_props = new SisterProperties(); 
                sis_props.PropertyId = prop_lst.Id;
                sis_props.PropertyName = prop_lst.Name; 
                
                sis_props.Rent_Range = (prop_lst.Rent_Range__c != null) ? prop_lst.Rent_Range__c : ''; 
                sis_props.Bed_Range =(prop_lst.Bed_Range__c != null) ? prop_lst.Bed_Range__c : ''; 
                sis_props.Bath_Range = (prop_lst.Bath_Range__c != null) ? prop_lst.Bath_Range__c : ''; 
                sis_props.SquareFeet_Range = (prop_lst.Square_Feet_Range__c != null) ? prop_lst.Square_Feet_Range__c : '';  
                
                if(prop_lst.Rent_Range__c != null || prop_lst.Bed_Range__c != null || prop_lst.Bath_Range__c != null || prop_lst.Square_Feet_Range__c != null ){ 
                    sis_props.status = true; 
                } else{
                    sis_props.status = false; 
                } 
                
                
                if(lat != 0 && lang != 0)  
                {
                    if(prop_lst.Geocode__r.geopointe__Latitude__c != null && prop_lst.Geocode__r.geopointe__Longitude__c != null){
                        
                        Double dDepartLat = lat * 3.14159 / 180;
                        Double dDepartLong = lang * 3.14159 / 180;
                        Double dArrivalLat = prop_lst.Geocode__r.geopointe__Latitude__c * 3.14159 / 180;
                        Double dArrivalLong =prop_lst.Geocode__r.geopointe__Longitude__c * 3.14159 / 180;
                        
                        Double dDeltaLong = dArrivalLong - dDepartLong;
                        Double dDeltaLat = dArrivalLat - dDepartLat;
                        
                        // calculate angle using the haversine formula
                        Double dHaversineResult = Math.Sin( dDeltaLat / 2 ) * Math.Sin( dDeltaLat / 2 ) + Math.Cos( dDepartLat ) * Math.Cos( dArrivalLat ) * Math.Sin( dDeltaLong / 2 ) * Math.Sin( dDeltaLong / 2 );
                        
                        // calculate distance by multiplying arc-tangent by the planet radius in miles
                        Double Distance = 3958.76 * 2 * Math.Atan2( Math.Sqrt( dHaversineResult ), Math.Sqrt( 1 - dHaversineResult ) );
                        Distance =Math.round(Distance*100);
                        Distance  = Distance/100.0; 
                        sis_props.Distance = ''+Distance+' Miles';
                        
                    } else{
                         sis_props.Distance = 'N/A';
                    
                    }
                     
                }
                else
                {
                    system.debug('exception'); 
                     sis_props.Distance = 'N/A';
                }
                 
                
                lstSisterProp.add(sis_props);
            }
        }
        return lstSisterProp;
    }
    
    
    public class FPUnits {
        public String id;
        public Decimal min_square_feet; 
        public Unit__c Floor_Units;
        
    } 
    public class SisterProperties {
        public String PropertyId;  
        public String PropertyName; 
        public String Rent_Range; 
        public String Bed_Range; 
        public String Bath_Range; 
        public String SquareFeet_Range;
        public Boolean status;
        public String Distance; 
        
        
    } 
}