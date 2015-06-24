trigger tgCallout on Appointment__c (before update){
if (!ProcessorControl.inFutureContext)
{
    String formatType=''; 
    for (Appointment__c c : Trigger.new)            
    { 
        /* boolean flag=true;                                      //Revoke validation not to send .ics file for MultiFamily
        if(c.Case__c != null && !Test.isRunningTest())
        {
            List<Case> cc=[Select id,Multi_Family_Case__c from Case where id=:c.Case__c];
            for(Case c1:cc)
            {
                if(c1.Multi_Family_Case__c==false)
                {
                    flag=false;
                }
                else
                {
                    flag=true;
                }
            }
        }
        
        if(flag==false)
        {
        */
            Appointment__c oldapp = Trigger.oldMap.get(c.ID);
            if(c.Invite_Status__c == 'Accepted')
            {
                formatType='1';
            }
            if(c.Invite_Status__c == 'Rejected')
            {
                formatType='4';
            }
            if(c.Invite_Status__c == 'Canceled')
            {
                formatType='5';
            }
            if(c.From__c != oldapp.From__c)
            {
                formatType='3';
            }
            if(c.Appointment_Date__c != oldapp.Appointment_Date__c)
            {
                formatType='2';
            }
            
            String objectId = c.id;
            
            //12 Nov
            date testDate = c.Appointment_Date__c;
            datetime dt =  DateTime.newInstance(testDate, time.newInstance(0, 0, 0, 0));
            
            //end 12 Nov
            
            
            //String appDate = myDateTime.format('E');
            String appDate2 =dt.format('MM/dd/yyyy');
            String appName=c.Name;
            String frm=c.From__c;
            String tod=c.To__c;
            Decimal nFrm=c.NoFrom__c;
            Decimal nTo=c.NoTo__c;
            
            //String cemail=c.Client_Email__c;
            
            String sats=c.Invite_Status__c;
            String guestEamil=c.Guest_Email__c;
            String propName=c.Property_name__c;
            String propAddress=c.Address__c;
            String clientName=c.Client_Name__c;
            String clientPhone=c.Client_Phone__c;
            String clientMobile=c.Guest_Mobile_Phone__c;
            
            String agent_id=c.Contact__c;
            String agent_name=c.Agent_First_Name__c;
            String agent_email=c.Agent_Email__c;
            
            String case_source=c.DNIS_From_Case_source__c;
            
            String property_agency=c.Agency__c;                    
            String property_Time_Zone=c.Property__r.Time_Zone__c;
            //String property_Time_Zone_Full=c.Property__r.Time_Zone_Full__c;
            String property_Time_Zone_Full=c.Time_Zone_Full__c;                    
            System.Debug('TimeZoneFull--->'+c.Time_Zone_Full__c);
            String apptNotes=c.Comments__c;                 
            
            //String args='?p3='+ objectId+','+appDate2+','+ nFrm +','+ nTo +','+agent_name+','+agent_email+','+guestEamil+','+propName+','+sats+','+clientPhone+','+case_source;
            //args+='&p7='+agent_id+'&p1='+appName+'&p4='+clientName+'&p6='+frm+'&p5='+propAddress+'&p11='+property_agency+'&p12='+property_Time_Zone+'&p13='+apptNotes+'&p17='+clientMobile+'&p14='+formatType;     
            
            String args='?p3='+ objectId+','+appDate2+','+ nFrm +','+ nTo +','+agent_name+','+agent_email+','+guestEamil+','+propName+','+sats+','+clientPhone+','+case_source;
            args+='&p7='+agent_id+'&p1='+appName+'&p4='+clientName+'&p6='+frm+'&p5='+propAddress+'&p11='+property_agency+'&p12='+property_Time_Zone_Full+'&p13='+apptNotes+'&p17='+clientMobile+'&p14='+formatType;                    
            
            System.Debug('String value--->'+args);
            if (!Test.isRunningTest() && !System.isBatch() )
            {
                //Execute the call
                //CalloutWS.Wspost(objectId+' : '+objectNumber); 
                CalloutWS.Wspost(args);
            }
        //}                                            
    }     
}     
}


//Conditions:::::::formatType
//IF Invite_Status__c is ACCEPTED then (1)
//IF Invite_Status__c is Rejected then (4)
//IF Invite_Status__c is Cancelled then (5)
//IF AppointmentDate is updated then (2)
//IF From__c is updated then (3)