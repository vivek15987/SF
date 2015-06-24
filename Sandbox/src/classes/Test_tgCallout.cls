@isTest
private class Test_tgCallout {
static testMethod void TesttgCallout()
{ 
Case c=new Case();
c.Status='Inquiry';
c.Multi_Family_Case__c=false;
insert c;

Appointment__c app = new Appointment__c();
app.Invite_Status__c = 'Invited';
app.Case__c=c.Id;
app.Appointment_Date__c = Date.Parse('12/12/2013');
insert app;
app.Invite_Status__c = 'Accepted';  
update app;          
                  String objectId = app.id;
                  String formatType='1';
                    //12 Nov
                    date testDate = app.Appointment_Date__c;
                    datetime dt =  DateTime.newInstance(testDate, time.newInstance(0, 0, 0, 0));
                    
                    //end 12 Nov
                    
                    
                    //String appDate = myDateTime.format('E');
                    String appDate2 =dt.format('MM/dd/yyyy');
                    String appName=app.Name;
                    String frm=app.From__c;
                    String tod=app.To__c;
                    Decimal nFrm=app.NoFrom__c;
                    Decimal nTo=app.NoTo__c;
                    
                    //String cemail=c.Client_Email__c;
                    
                    String sats=app.Invite_Status__c;
                    String guestEamil=app.Guest_Email__c;
                    String propName=app.Property_name__c;
                    String propAddress=app.Address__c;
                    String clientName=app.Client_Name__c;
                    String clientPhone=app.Client_Phone__c;
                    String clientMobile=app.Guest_Mobile_Phone__c;
                    
                    String agent_id=app.Contact__c;
                    String agent_name=app.Agent_First_Name__c;
                    String agent_email=app.Agent_Email__c;
                    
                    String case_source=app.DNIS_From_Case_source__c;
                    
                    String property_agency=app.Agency__c;
                    //Property__r.Time_Zone__c
                    String property_Time_Zone=app.Property__r.Time_Zone__c;
                    
                    String apptNotes=app.Comments__c;
                    
                    
                    
                    String args='?p3='+ objectId+','+appDate2+','+ nFrm +','+ nTo +','+agent_name+','+agent_email+','+guestEamil+','+propName+','+sats+','+clientPhone+','+case_source;
                    args+='&p7='+agent_id+'&p1='+appName+'&p4='+clientName+'&p6='+frm+'&p5='+propAddress+'&p11='+property_agency+'&p12='+property_Time_Zone+'&p13='+apptNotes+'&p17='+clientMobile+'&p14='+formatType;
                    

                    
                    if (!Test.isRunningTest())
                        {
                            //Execute the call
                             //CalloutWS.Wspost(objectId+' : '+objectNumber); 
                           
                        }
                         CalloutWS.Wspost(args);
                                            
                    
            }

//Test.startTest();
//Test.stopTest();
}