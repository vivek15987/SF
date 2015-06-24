trigger UpdateWorkOrder_new on Service_Request1__c (before insert, before update) {
    
    Service_Request1__c s = trigger.new[0];
    decimal hour=0; 
        
    List<Work_Order_Dispatch__c> wo1=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Monday_Open__c,Monday_Closed__c,
    Tuesday_Open__c,Tuesday_Closed__c,Wednesday_Open__c,Wednesday_Closed__c,Thursday_Open__c,Thursday_Closed__c ,Friday_Open__c,
    Friday_Closed__c,Saturday_Open__c,Saturday_Closed__c ,Sunday_Open__c,Sunday_Closed__c ,Emergency_Classification__c from Work_Order_Dispatch__c 
    where Set_As_AH_Emer_Woogie__c=true and Account_Name__c=:s.Account__c and MSA_Name__c=:s.Property_Of_Interest_Market__c];
    if (s.Work_Order_Dispatch__c == null)
    {
        hour=s.Hour_Min_of_Day_Created__c;
        Boolean runUpdate=false;
        
        
        If(s.Use_AH_Emer_Woogie__c==True && s.Final_Request_Disposition__c=='Emergency')
        { 
         for(Work_Order_Dispatch__c ww:wo1)
          {
          
            If(s.Day_of_Week_Created__c==Decimal.valueof('1'))
            {
                If(ww.Monday_Open__c<hour && ww.Monday_Closed__c >hour)
                {
                    runUpdate=True;
                }
                else
                {
                    runUpdate=false;
                }
            }
            else if(s.Day_of_Week_Created__c==Decimal.valueof('2'))
            {
                If( ww.Tuesday_Open__c <hour && ww.Tuesday_Closed__c >hour)
                {
                    runUpdate=True;
                }
                else
                {
                    runUpdate=false;
                }
            }
            else if(s.Day_of_Week_Created__c==Decimal.valueof('3'))
            {
                If( ww.Wednesday_Open__c<hour && ww.Wednesday_Closed__c >hour)
                {
                    runUpdate=True;
                }
                else
                {
                    runUpdate=false;
                }
            }
            else if(s.Day_of_Week_Created__c==Decimal.valueof('4'))
            {
                If( ww.Thursday_Open__c<hour && ww.Thursday_Closed__c >hour )
                {
                    runUpdate=True;
                }
                else
                {
                    runUpdate=false;
                }
            }
            else if(s.Day_of_Week_Created__c==Decimal.valueof('5'))
            {
                If( ww.Friday_Open__c<hour && ww.Friday_Closed__c>hour )
                {
                    runUpdate=True;
                }
                else
                {
                    runUpdate=false;
                }
            }
            else if(s.Day_of_Week_Created__c==Decimal.valueof('6'))
            {
                If(ww.Saturday_Open__c< hour && ww.Saturday_Closed__c >hour)
                {
                    runUpdate=True;
                }
                else
                {
                    runUpdate=false;
                }
            }
            else if(s.Day_of_Week_Created__c==Decimal.valueof('7'))
            {
                If( ww.Sunday_Open__c <hour && ww.Sunday_Closed__c >hour)
                {
                    runUpdate=True;
                }
                else
                {
                    runUpdate=false;
                }
            }
            
            if(runUpdate==True)
            {
                List<Work_Order_Dispatch__c> wo=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Emergency_Classification__c from Work_Order_Dispatch__c where Set_As_AH_Emer_Woogie__c=false];
                for(Work_Order_Dispatch__c w:wo)
                {
                    if(w.Account_Name__c==s.Account__c && w.MSA_Name__c==s.Property_Of_Interest_Market__c && w.Request_Category1__c==s.Request_Category__c && w.Emergency_Classification__c==s.Request_Classification_LU__c)
                    {
                        s.Work_Order_Dispatch__c=w.Id;
                    }
                    else if(w.Account_Name__c==s.Account__c && w.MSA_Name__c==s.Property_Of_Interest_Market__c && w.Request_Category1__c==s.Request_Category__c && w.Emergency_Classification__c=='All Requests')
                    {
                        s.Work_Order_Dispatch__c=w.Id;
                    }
                } 
            }
            else
            {
                s.Work_Order_Dispatch__c=ww.Id; 
            }
            
          }
        }
        
        else
        {
            List<Work_Order_Dispatch__c> wo=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Emergency_Classification__c from Work_Order_Dispatch__c where Set_As_AH_Emer_Woogie__c=false];
            for(Work_Order_Dispatch__c w:wo)
            {
                if(w.Account_Name__c==s.Account__c && w.MSA_Name__c==s.Property_Of_Interest_Market__c && w.Request_Category1__c==s.Request_Category__c && w.Emergency_Classification__c==s.Request_Classification_LU__c)
                {
                    s.Work_Order_Dispatch__c=w.Id;
                }
                else if(w.Account_Name__c==s.Account__c && w.MSA_Name__c==s.Property_Of_Interest_Market__c && w.Request_Category1__c==s.Request_Category__c && w.Emergency_Classification__c=='All Requests')
                {
                    s.Work_Order_Dispatch__c=w.Id;
                }
            }
        }
    }
   else
   {
        
  }

}