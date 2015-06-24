@isTest(SeeAllData=true)
  
  Private class Test_Call_Callout_scheduler_class
   {
  static testMethod void MyTest() 
   {  
  
     Call_Callout_for_Schedule_report c1 = new Call_Callout_for_Schedule_report();
    c1.execute(null);
    
     
   }
   }