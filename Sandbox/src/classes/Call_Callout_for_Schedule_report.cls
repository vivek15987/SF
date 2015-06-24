global class Call_Callout_for_Schedule_report implements Schedulable {
    global void execute(SchedulableContext SC) 
     { 
   
      Callout_Schedule_report.Fetch_Report_link();
                         
    }
    }