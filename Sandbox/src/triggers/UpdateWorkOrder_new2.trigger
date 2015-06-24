trigger UpdateWorkOrder_new2 on Service_Request1__c (before insert, before update)
{    
    Service_Request1__c[] serReq = trigger.new;
    Service_Request1__c s = serReq[0];
    decimal hour=0; 
    Integer i;    
    Integer j; 
    List<Work_Order_Dispatch__c> woSer=[Select Id from Work_Order_Dispatch__c where Account_Name__c=:s.Account__c and MSA_Name__c=:s.Property_Of_Interest_Market__c and Grouping__r.Name=:s.Property_Grouping__c and Service_Request_Type__c=:s.Service_Request_Type__c];
    if(woSer.size()>0)
    {
        s.Work_Order_Dispatch__c=woSer[0].Id;
    }
    else
    {
    //---Created on 09/12/2014------
    if(s.Force_Emergency__c== True && s.Customer_Service_Request__c==True)
    {
        List<Work_Order_Dispatch__c> wolistFC=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Emergency_Classification__c,Grouping__r.Name from Work_Order_Dispatch__c 
        where Account_Name__c=:s.Account__c and MSA_Name__c=:s.Property_Of_Interest_Market__c and Grouping__r.Name=:s.Property_Grouping__c and Request_Category1__c='Emergency Customer Service Request']; 
        for(Work_Order_Dispatch__c wfc:wolistFC)
        {
            s.Work_Order_Dispatch__c=wfc.Id;
        }
    }
    else if(s.Customer_Service_Request__c==True)
    {
        List<Work_Order_Dispatch__c> wolistC=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Emergency_Classification__c,Grouping__r.Name from Work_Order_Dispatch__c 
        where Account_Name__c=:s.Account__c and MSA_Name__c=:s.Property_Of_Interest_Market__c and Grouping__r.Name=:s.Property_Grouping__c and Request_Category1__c='Customer Service Request']; 
        for(Work_Order_Dispatch__c wc:wolistC)
        {
            s.Work_Order_Dispatch__c=wc.Id;
        }
    }
    //---------------------------
    else
    {      
    List<Work_Order_Dispatch__c> wo1=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Monday_Open__c,Monday_Closed__c,
    Tuesday_Open__c,Tuesday_Closed__c,Wednesday_Open__c,Wednesday_Closed__c,Thursday_Open__c,Thursday_Closed__c ,Friday_Open__c,
    Friday_Closed__c,Saturday_Open__c,Saturday_Closed__c ,Sunday_Open__c,Sunday_Closed__c ,Emergency_Classification__c,Grouping__r.Name from Work_Order_Dispatch__c 
    where Set_As_AH_Emer_Woogie__c=true and Account_Name__c=:s.Account__c and MSA_Name__c=:s.Property_Of_Interest_Market__c and Grouping__r.Name=:s.Property_Grouping__c];   
    
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
              //---Code for DH Emergency-06/13/2014 -----   
                  if(s.Property_Grouping__c != null && s.Use_Default_Work_Order_Dispatch__c=='True' && s.Final_Request_Disposition__c=='Emergency')
                  {                      
                      List<Work_Order_Dispatch__c> wo=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Emergency_Classification__c,Grouping__r.Name from Work_Order_Dispatch__c where Is_During_Hours_Emergency__c=True];
                      for(Work_Order_Dispatch__c w:wo)
                      {
                          if(w.Account_Name__c==s.Account__c && w.MSA_Name__c==s.Property_Of_Interest_Market__c && w.Grouping__r.Name==s.Property_Grouping__c)
                          {
                              s.Work_Order_Dispatch__c=w.Id;
                          }                       
                      } 
                  }
                  //-----------------------------
                  else
                  {                  
                    if(s.Property_Grouping__c != null && s.Use_Default_Work_Order_Dispatch__c=='True')
                    {                        
                        List<Work_Order_Dispatch__c> wo=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Emergency_Classification__c,Grouping__r.Name from Work_Order_Dispatch__c where Is_Standard_WOD__c=True];
                        for(Work_Order_Dispatch__c w:wo)
                        {
                            if(w.Account_Name__c==s.Account__c && w.MSA_Name__c==s.Property_Of_Interest_Market__c && w.Grouping__r.Name==s.Property_Grouping__c)
                            {
                                s.Work_Order_Dispatch__c=w.Id;
                            }                       
                        }    
                    }
                    else
                    {                        
                        List<Work_Order_Dispatch__c> wo=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Emergency_Classification__c from Work_Order_Dispatch__c where Set_As_AH_Emer_Woogie__c=false and Is_Standard_WOD__c=false];
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
            }
            else
            {
                s.Work_Order_Dispatch__c=ww.Id; 
            }
            
          }
        }        
        else
        {
            if(s.Property_Grouping__c != null && s.Use_Default_Work_Order_Dispatch__c=='True')
            {
                List<Work_Order_Dispatch__c> wo=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Emergency_Classification__c,Grouping__r.Name from Work_Order_Dispatch__c where Is_Standard_WOD__c=True];
                for(Work_Order_Dispatch__c w:wo)
                {
                    if(w.Account_Name__c==s.Account__c && w.MSA_Name__c==s.Property_Of_Interest_Market__c && w.Grouping__r.Name==s.Property_Grouping__c)
                    {
                        s.Work_Order_Dispatch__c=w.Id;
                    }                    
                }    
            }
            else
            {
                List<Work_Order_Dispatch__c> wo=[Select Id,Name,Account_Name__c,Request_Category1__c,MSA_Name__c,Emergency_Classification__c from Work_Order_Dispatch__c where Set_As_AH_Emer_Woogie__c=false and Is_Standard_WOD__c=false];
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
    }//end of else
   }
   //---Code for getting Created time in textbox--
   if(s.Created_Date_and_Time__c != null)
   {
       String ct;
       String[] parts = s.Created_Date_and_Time__c.format().split(' ');
       ct=(parts.size() == 3) ? (parts[1] + ' ' + parts[2]) : parts[1];
       s.Time_Request_Created__c=ct;
   }   
   else
   {
       String[] parts = s.CreatedDate.format().split(' ');String ct1=(parts.size() == 3) ? (parts[1] + ' ' + parts[2]) : parts[1];s.Time_Request_Created__c=ct1;
   }
    if( s.Work_Order_Dispatch__c != null){
        if( Trigger.IsInsert || ( Trigger.IsUpdate &&  Trigger.oldMap.get(s.Id).Work_Order_Dispatch__c != Trigger.newMap.get(s.Id).Work_Order_Dispatch__c ) ) {
        	List<Work_Order_Dispatch__c> wo = [Select Id,Company_Representative_Contact_Email__c, Company_Email_CC__c,Company_Email_CC_2__c, Company_Email_CC_3__c, Work_Order_Dispatch__c.Service_Technician__r.email__c from Work_Order_Dispatch__c where Id=:s.Work_Order_Dispatch__c];
            for(Work_Order_Dispatch__c w:wo)
            { 
                s.Dispatch_Email_Converted__c = w.Service_Technician__r.email__c;
                s.Company_Email_CC_Conv__c = w.Company_Email_CC__c;
                s.Company_Email_CC_2_Conv__c = w.Company_Email_CC_2__c;
                s.Company_Email_CC_3_Conv__c = w.Company_Email_CC_3__c;
                s.Company_Representative_Contact_Email_C__c = w.Company_Representative_Contact_Email__c;
            }    
        }
          
    }
    
}