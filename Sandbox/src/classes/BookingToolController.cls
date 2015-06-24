public with sharing class BookingToolController {   
    
    private static List<Unvailability__c> lstOpenHouse { get; set; }
    private static List<Property_Agent__c> lstAgents { get; set; }
    private static List<Unvailability__c> lstUnvailability { get; set; }  
    private static List<Default_Availability__c> lstAvailability { get; set; }   
    
    public  BookingToolController() {  
        
    }
    
    public  BookingToolController(ApexPages.StandardController stc) {
        
    }   
    
    public PageReference myMethod(){        
        return null;
    }   
    
    @RemoteAction
    public static List<AggregateResult> getNextConcurrentShowings( String propertyId, String sDate ) {
        List<AggregateResult> nextThreeAppointments =[ SELECT Appointment_Date__c, From__c, To__c,Contact__r.Name,Contact__r.Id, Count(Id)count_appointment 
                                                      FROM Appointment__c 
                                                      WHERE Appointment_Date__c >=: dateRetrieval(sDate)
                                                      AND Property__r.Id =: propertyId
                                                      AND Invite_Status__c IN ( 'Invited','Accepted' )
                                                      GROUP BY Appointment_Date__c, From__c, To__c,Contact__r.Name,Contact__r.Id
                                                      LIMIT 3
                                                     ] ;
        return nextThreeAppointments;
        
    }
    
    @RemoteAction
    public static List<Appointment__c> getAppointmentsByAgent( Contact c, Date sDate, Date eDate ) {
        List<Appointment__c> lstAppointments = new List<Appointment__c>();
        
        lstAppointments = [ SELECT Appointment_Date__c,Day__c,From__c,Id,To__c,Invite_Status__c,
                           Property__r.Region__c,
                           Property__r.Id
                           FROM Appointment__c 
                           WHERE Appointment_Date__c >=: sDate 
                           AND Appointment_Date__c <=: eDate
                           AND From__c != NULL 
                           AND To__c != NULL 
                           AND Contact__c =: c.Id
                           AND Invite_Status__c IN ( 'Invited','Accepted' )];
        
        System.debug( lstAppointments );
        
        return lstAppointments;
    }
    
    @RemoteAction
    public static List<Appointment__c> getAppointmentsByPropertyId( String propertyId, Date sDate, Date eDate ) {
        List<Appointment__c> lstAppointments = new List<Appointment__c>();
        
        lstAppointments = [ SELECT Appointment_Date__c,Day__c,From__c,Id,To__c,Invite_Status__c,
                           Property__r.Region__c,
                           Property__r.Id
                           FROM Appointment__c 
                           WHERE Appointment_Date__c >=: sDate 
                           AND Appointment_Date__c <=: eDate
                           AND Property__c =: propertyId
                           AND From__c != NULL 
                           AND To__c != NULL 
                           AND Invite_Status__c IN ( 'Invited','Accepted' )];
        
        System.debug( lstAppointments );
        
        return lstAppointments;
    }
    
    
    
    @RemoteAction
    public static String getNextWeekCocurrentBookings( String propertyId,String startDate,String endDate ) {
        
        String[] strDate = startDate.split('/');
        Integer smonth = integer.valueOf(strDate[0]);
        Integer sdate = integer.valueOf(strDate[1]);
        Integer syear = integer.valueOf(strDate[2]);
        
        List<Property_Agent__c> agents = [ SELECT Contact__r.Id,Contact__r.Name,Contact__r.Allow_Same_Day_Showings__c,Contact__r.Same_Day_Showings__c,Contact__r.Weekend_Showings__c
                                          FROM Property_Agent__c 
                                          WHERE Property__c =: propertyId 
                                          ORDER BY 
                                          Roles__c ASC NULLS FIRST ];
        
        JSONGenerator gen = JSON.createGenerator(true); 		
        gen.writeStartObject();
        gen.writeFieldName('agents');
        gen.writeStartArray();   
        for( Property_Agent__c pa : agents ) { 
            gen.writeStartObject();
            gen.writeStringField('agent_name', pa.Contact__r.Name );
            gen.writeStringField('agent_id', pa.Contact__r.Id);
            gen.writeFieldName('timings'); 
            gen.writeStartArray();
            for(Integer i = 0 ; i < 7 ; i ++ ) 
            {   
                Date tmpDate = dateRetrieval( smonth + '/' + ( sdate + i ) + '/' + syear );
                System.debug( tmpDate );
                AggregateResult[] lstAppointments = [ SELECT Appointment_Date__c, From__c, To__c, Count(Id)count_appointment 
                                                     FROM Appointment__c 
                                                     WHERE Appointment_Date__c =: tmpDate
                                                     AND Property__r.Id =: propertyId
                                                     AND Contact__c =: pa.Contact__r.Id
                                                     AND Invite_Status__c IN ( 'Invited','Accepted' )
                                                     GROUP BY Appointment_Date__c, From__c, To__c ];
                for( AggregateResult obj : lstAppointments ) 
                {
                    gen.writeStartObject();
                    gen.writeDateField( 'date', tmpDate );
                    gen.writeObjectField('From',obj.get('From__c'));
                    gen.writeObjectField('To',obj.get('To__c'));
                    gen.writeObjectField('count', obj.get('count_appointment'));
                    gen.writeEndObject();
                }
            }   
            gen.writeEndArray();
            gen.writeEndObject();
            
        }
        gen.writeEndArray();
        gen.writeEndObject();
        
        return gen.getAsString();
    }
    
    
    @RemoteAction
    public static String getNextWeekAgentAvailability( String propertyId,String startDate,String endDate,boolean isMFView ) {
        // List<Contact> agents;
        if( propertyId != null ) {
            lstAgents = [ SELECT Contact__r.Id,Contact__r.Name,Contact__r.Allow_Same_Day_Showings__c,Contact__r.Same_Day_Showings__c,Contact__r.Weekend_Showings__c, Contact__r.Hours_Advanced_Notice_Required_PST__c  FROM Property_Agent__c WHERE Property__c =: propertyId ORDER BY 
                         Roles__c ASC NULLS FIRST ];
        }
        
        JSONGenerator gen = JSON.createGenerator(true); 		
        if( lstAgents.size() > 0 ) {
            gen.writeStartObject();
            if( isMFView )
            {
                gen.writeFieldName('appointments'); 
                gen.writeStartArray();
                List<Appointment__c> tmpAppointments;
                tmpAppointments = getAppointmentsByPropertyId( propertyId, dateRetrieval( startDate ), dateRetrieval ( endDate ) );
                tmpAppointments.sort();  
                for( Appointment__c appointment : tmpAppointments ) {                   
                    gen.writeStartObject();
                    gen.writeDateField('appointment_date', appointment.Appointment_Date__c);
                    gen.writeStringField('From', appointment.From__c);
                    gen.writeStringField('To', appointment.To__c);
                    gen.writeStringField('Status', appointment.Invite_Status__c);
                    if( appointment.Property__r.Region__c != NULL ) {
                        gen.writeStringField('region', appointment.Property__r.Region__c);
                    } else {
                        gen.writeStringField('region', '');
                    }   
                    if( appointment.Property__r.Id != NULL ) {
                        gen.writeStringField('property_id', appointment.Property__r.Id);
                    } else {
                        gen.writeStringField('property_id', '');
                    }  
                    
                    gen.writeEndObject();
                }
                gen.writeEndArray();
            }
            gen.writeFieldName('agents');
            gen.writeStartArray();            
            for( Property_Agent__c pa : lstAgents ) {
                gen.writeStartObject();
                gen.writeStringField('agent_name', pa.Contact__r.Name );
                gen.writeStringField('agent_id', pa.Contact__r.Id);
                gen.writeBooleanField('allow_same_day_showings__c', pa.Contact__r.Allow_Same_Day_Showings__c); 
                
                if( pa.Contact__r.Weekend_Showings__c != NULL ) {
                    gen.writeStringField('weekend_showings', pa.Contact__r.Weekend_Showings__c); 
                } else {
                    gen.writeStringField('weekend_showings', ''); 
                }                 
                
                if( pa.Contact__r.Same_Day_Showings__c != NULL )
                {
                    
                    gen.writeStringField('same_day_showings', pa.Contact__r.Same_Day_Showings__c);
                } 
                else 
                {
                    gen.writeStringField('same_day_showings', '');
                }
                
                if( pa.Contact__r.Hours_Advanced_Notice_Required_PST__c != NULL )
                { 
                    gen.writeNumberField('advanced_notice_hours', pa.Contact__r.Hours_Advanced_Notice_Required_PST__c);
                } 
                else 
                { 
                    gen.writeNumberField('advanced_notice_hours',0);
                }
                
                if ( !isMFView )
                {
                    gen.writeFieldName('appointments'); 
                    gen.writeStartArray();
                    List<Appointment__c>   tmpAppointments = getAppointmentsByAgent( pa.Contact__r, dateRetrieval( startDate ), dateRetrieval ( endDate ) );
                    tmpAppointments.sort();
                    System.debug(tmpAppointments);
                    for( Appointment__c appointment : tmpAppointments ) {                   
                        gen.writeStartObject();
                        gen.writeDateField('appointment_date', appointment.Appointment_Date__c);
                        gen.writeStringField('From', appointment.From__c);
                        gen.writeStringField('To', appointment.To__c);
                        gen.writeStringField('Status', appointment.Invite_Status__c);
                        if( appointment.Property__r.Region__c != NULL ) {
                            gen.writeStringField('region', appointment.Property__r.Region__c);
                        } else {
                            gen.writeStringField('region', '');
                        }   
                        if( appointment.Property__r.Id != NULL ) {
                            gen.writeStringField('property_id', appointment.Property__r.Id);
                        } else {
                            gen.writeStringField('property_id', '');
                        }  
                        
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();  
                }
                gen.writeFieldName('availability'); 
                gen.writeStartArray();
                List<Default_Availability__c> tmpDefaultAvailbilityByAgent = getDefaultAvailbilityByAgent( pa.Contact__r);
                for( Default_Availability__c da : tmpDefaultAvailbilityByAgent ) {                   
                    gen.writeStartObject();
                    gen.writeStringField('day', da.Day__c);
                    if( da.From__c != NULL ) {
                        gen.writeStringField('From', da.From__c);
                    }else {
                        gen.writeStringField('From', '8:00 a.m.');
                    }
                    if( da.To__c != NULL ) {
                        gen.writeStringField('To', da.To__c);
                    }else {
                        gen.writeStringField('To', '8:00 p.m.');
                    }
                    gen.writeEndObject();
                }   
                gen.writeEndArray();
                gen.writeFieldName('unvailability');
                gen.writeStartArray();
                List<Unvailability__c> tmpUnvailability = getUnavalibilityByAgent( pa.Contact__r, dateRetrieval( startDate ), dateRetrieval ( endDate ) );
                for( Unvailability__c ua : tmpUnvailability ) {
                    // Set<String> objectFields = Schema.SObjectType.ua.fields.getMap().keySet();
                    System.debug( ua );
                    gen.writeStartObject();
                    gen.writeDateField('date', ua.av_Date__c);
                    if( ua.av_start_Time__c != NULL ) {
                        gen.writeStringField('start_time', ua.av_start_Time__c);
                    } else {
                        gen.writeStringField('start_time', '00:00');
                    }                    
                    if( ua.av_End_Time__c  != NULL) {
                        gen.writeStringField('end_time', ua.av_End_Time__c);
                    } else {
                        gen.writeStringField('end_time', '00:00');
                    }
                    
                    if( ua.Type__c != NULL ) {
                        gen.writeStringField('type',ua.Type__c);
                    } else {
                        gen.writeStringField('type','Personal');
                    }
                    
                    if( ua.Property__c != NULL ) {
                        gen.writeStringField('property_id',ua.Property__c);
                    } else {
                        gen.writeStringField('property_id','');
                    }
                    gen.writeEndObject();
                }   
                gen.writeEndArray();
                gen.writeEndObject();
                
            }        
            // gen.writeEndObject();
            gen.writeEndArray();
            gen.writeEndObject();
            
        } 
        return gen.getAsString();
        // return ;
        
    }
    @RemoteAction
    public static List<Default_Availability__c> getDefaultAvailbilityByAgent( Contact c )    {
        List<Default_Availability__c> lstDefaultAvailbilityByAgent = [ SELECT 
                                                                      contact_rec_id__c,
                                                                      Day__c,
                                                                      From__c,
                                                                      Id,IsDeleted,
                                                                      Name,To__c 
                                                                      FROM 
                                                                      Default_Availability__c 
                                                                      WHERE 
                                                                      Day__c IN ( 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday' ) 
                                                                      AND contact_rec_id__c =: c.Id AND From__c != NULL AND To__c != NULL 
                                                                      ORDER BY 
                                                                      Day__c ASC NULLS FIRST
                                                                     ];
        
        return lstDefaultAvailbilityByAgent;
        
    }
    
    @RemoteAction
    public static List<Unvailability__c> getUnavalibilityByAgent( Contact c,Date startDate,Date endDate )    {
        List<Unvailability__c> lstUnvailabilityByAgent = [ SELECT 	av_Date__c,av_End_Time__c,av_start_Time__c,av_Status__c,Type__c,Property__c 
                                                          FROM Unvailability__c WHERE av_Date__c >=: startDate 
                                                          AND av_Date__c <=: endDate
                                                          AND Saved_by__c =: c.Id
                                                          AND (av_End_Time__c != NULL OR av_start_Time__c != NULL )
                                                          ORDER BY Saved_by__c ASC
                                                         ];
        
        return lstUnvailabilityByAgent;
    }
    
    @RemoteAction
    public static List<Unvailability__c> getUnavailabiltyByOpenHouse( String propertyId, String moveInDate )
    {        
        if( moveInDate != null ){
            Date move_in_date = dateRetrieval( moveInDate ); 
            System.debug('Move in date' + move_in_date );
            
            lstOpenHouse = [ SELECT 
                            Id,Type__c,av_Date__c,av_start_Time__c,av_End_Time__c,Saved_by__r.Name,Day_name__c
                            FROM 
                            Unvailability__c 
                            WHERE 
                            Type__c = 'Open House' 
                            AND Property__c = :propertyId 
                            AND av_Date__c >= :move_in_date
                            Limit 3
                           ];
            
            System.debug(  lstOpenHouse );
            
            return lstOpenHouse;    
        }
        return lstOpenHouse;            
    }
    
    @RemoteAction
    public static void createAppointmentByAgent( String agentId, String startdate,String propertyId,String caseId,String starttime,String endtime )
    {     
        System.debug('1'+agentId);
        System.debug('2'+startdate);
        System.debug('3'+propertyId); 
        System.debug('4'+caseId);
        System.debug('5'+starttime);
        System.debug('6'+endtime);
        Appointment__c app = new Appointment__c();
        if( agentId != null && agentId != '' ){
            app.Contact__c = agentId;
        }
        
        app.Case__c = caseId;
        app.Property__c = propertyId;
        app.Appointment_Date__c = dateRetrieval( startdate );
        app.Invite_Status__c = 'Invited';
        app.From__c = starttime;
        app.To__c = endtime;
        System.debug('7'+app);
        insert app;
        
    }
    
    private static Date dateRetrieval( string moveInDate ) {        
        
        String[] strDate = moveInDate.split('/');
        Integer myIntMonth = integer.valueOf(strDate[0]);
        Integer myIntDay = integer.valueOf(strDate[1]);
        Integer myIntYear = integer.valueOf(strDate[2]);
        return Date.newInstance(myIntYear, myIntMonth, myIntDay);       
    }   
    
    
}