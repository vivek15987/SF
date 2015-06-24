@isTest
private class Test_ReportPortal_AccountFlags   {
static testMethod void AccountFlags(){
 string AccountId ='';
 string Show_Call_Recordings_in_Reports ='';
 string Enable_Specials_in = '';
 string Show_MF_Reports_in_Reporting_Platform = '';
 string Show_SF_Reports_in_Reporting_Platform ='';
 string Allow_Property_Updates_in_ReportPlatform ='' ; 
 string Show_SR_Reports_in_Reporting_Platform = '';
 string type='';
 string Name='';

Account ac= new Account();
ac.Name='Test';
ac.Show_Call_Recordings_in_Reports__c =false;
ac.Enable_Specials_in__c =false;
ac.Show_MF_Reports_in_Reporting_Platform__c =false;
ac.Show_SF_Reports_in_Reporting_Platform__c =false;
ac.Allow_Property_Updates_in_ReportPlatform__c =false;
ac.Show_SR_Reports_in_Reporting_Platform__c =false;
ac.Type='Management Company';
insert ac;



Account ac1= new Account();
ac1.Id=ac.id;
ac1.Name='Test Account';
ac1.Show_Call_Recordings_in_Reports__c =boolean.valueof(Show_Call_Recordings_in_Reports);
ac1.Enable_Specials_in__c =boolean.valueof(Enable_Specials_in);
ac1.Show_MF_Reports_in_Reporting_Platform__c =boolean.valueof(Show_MF_Reports_in_Reporting_Platform);
ac1.Show_SF_Reports_in_Reporting_Platform__c =boolean.valueof(Show_SF_Reports_in_Reporting_Platform);
ac1.Allow_Property_Updates_in_ReportPlatform__c =boolean.valueof(Allow_Property_Updates_in_ReportPlatform);
ac1.Show_SR_Reports_in_Reporting_Platform__c =boolean.valueof(Show_SR_Reports_in_Reporting_Platform);
ac1.Type=Type;
update ac1;

if(ac1.Show_Call_Recordings_in_Reports__c==true || ac1.Enable_Specials_in__c==true ||ac1.Show_MF_Reports_in_Reporting_Platform__c ==true ||ac1.Show_SF_Reports_in_Reporting_Platform__c ==true ||ac1.Allow_Property_Updates_in_ReportPlatform__c ==true || ac1.Show_SR_Reports_in_Reporting_Platform__c ==true )
{


    string args='';       
   if (!Test.isRunningTest())
          {
               //Execute the call
                   
              AccountId = ac.Id;
            Show_Call_Recordings_in_Reports = 'true';
              Enable_Specials_in = 'true';
             Show_MF_Reports_in_Reporting_Platform =  'true';
             Show_SF_Reports_in_Reporting_Platform =  'true' ;
            Allow_Property_Updates_in_ReportPlatform =   'true' ; 
            Show_SR_Reports_in_Reporting_Platform =  'true' ;
             
             args='?p1='+AccountId+'&p2='+Show_Call_Recordings_in_Reports+'&p3='+Enable_Specials_in +'&p4='+Show_MF_Reports_in_Reporting_Platform +'&p5='+Show_SF_Reports_in_Reporting_Platform +'&p6='+Allow_Property_Updates_in_ReportPlatform+'&p7='+Show_SR_Reports_in_Reporting_Platform;
             
         }
         ReportPortal_AccountFlags_Callout.Wspost(args);
      }                                      
 
}

}