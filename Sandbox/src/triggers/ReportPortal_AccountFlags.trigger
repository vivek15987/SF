trigger ReportPortal_AccountFlags on Account(before update) 
{
  Map<Id,Account> acc = new Map<Id,Account>();
  acc = trigger.oldMap;
system.debug('Old map - ' +acc);
 string AccountId ='';
 string Show_Call_Recordings_in_Reports ='';
 string Enable_Specials_in = '';
 string Show_MF_Reports_in_Reporting_Platform = '';
 string Show_SF_Reports_in_Reporting_Platform ='';
 string Allow_Property_Updates_in_ReportPlatform ='' ; 
 string Show_SR_Reports_in_Reporting_Platform = '';
            
  for(Account a : trigger.new)
  {
     Account old = new Account ();
     old = acc.get(a.Id);
      system.debug('Old Account - ' +old);
     if(a.Show_Call_Recordings_in_Reports__c != old.Show_Call_Recordings_in_Reports__c 
          || a.Enable_Specials_in__c != old.Enable_Specials_in__c 
          || a.Show_MF_Reports_in_Reporting_Platform__c != old.Show_MF_Reports_in_Reporting_Platform__c 
          || a.Show_SF_Reports_in_Reporting_Platform__c != old.Show_SF_Reports_in_Reporting_Platform__c
          || a.Allow_Property_Updates_in_ReportPlatform__c != old.Allow_Property_Updates_in_ReportPlatform__c
          || a.Show_SR_Reports_in_Reporting_Platform__c != old.Show_SR_Reports_in_Reporting_Platform__c)
     {
         system.debug('Inside if condition');
          if (!Test.isRunningTest())
          {
               //Execute the call
             AccountId = a.Id; Show_Call_Recordings_in_Reports = String.ValueOf(a.Show_Call_Recordings_in_Reports__c); Enable_Specials_in =  String.ValueOf(a.Enable_Specials_in__c);  Show_MF_Reports_in_Reporting_Platform =  String.ValueOf(a.Show_MF_Reports_in_Reporting_Platform__c);  Show_SF_Reports_in_Reporting_Platform =  String.ValueOf(a.Show_SF_Reports_in_Reporting_Platform__c) ;
             Allow_Property_Updates_in_ReportPlatform =   String.ValueOf(a.Allow_Property_Updates_in_ReportPlatform__c) ;  Show_SR_Reports_in_Reporting_Platform =  String.ValueOf(a.Show_SR_Reports_in_Reporting_Platform__c) ; string args='?p1='+AccountId+'&p2='+Show_Call_Recordings_in_Reports+'&p3='+Enable_Specials_in +'&p4='+Show_MF_Reports_in_Reporting_Platform +'&p5='+Show_SF_Reports_in_Reporting_Platform +'&p6='+Allow_Property_Updates_in_ReportPlatform+'&p7='+Show_SR_Reports_in_Reporting_Platform; ReportPortal_AccountFlags_Callout.Wspost(args);
			 system.debug('Last line - '+args);              
         } }}}