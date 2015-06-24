trigger Send_Email_Phonetree on Emergency_Dispatch__c (before insert, before update) {
Emergency_Dispatch__c ed=trigger.New[0];
Boolean flag1=true;
Boolean flag2=true;
Boolean flag3=true;
Boolean flag4=true;
Boolean flag5=true;
Boolean flag6=true;

    //---Validate Phone Tree 1---
    if (ed.Phone_Tree_1__c == ' ')
    {
        flag1 = false;    
    } 
    else
    {
        if (ed.Phone_Tree_1_Result__c != null)
        {
            if (ed.Phone_Tree_1_Result__c == 'answered & accepted')
            {
                flag1 = true;
            }
            else
            {
                flag1 = false;
            }
        }   
        
    }
    //---Validate Phone Tree 2---
    if (ed.Phone_Tree_2__c == ' ')
    {
       flag2 = false;       
    }
    else
    {
       if (ed.Phone_Tree_2_Result__c != null)
        {
           if (ed.Phone_Tree_2_Result__c == 'answered & accepted')
            {
                flag2 = true;
            }
            else
            {
                flag2 = false;
            }
        } 
    }
    //---Validate Phone Tree 3---
    if (ed.Phone_Tree_3__c == ' ')
    {
          flag3 = false;  
    }
    else
    {
        if (ed.Phone_Tree_3_Result__c != null)
        {
            if (ed.Phone_Tree_3_Result__c == 'answered & accepted')
            {
                flag3 = true;
            }
            else
            {
                flag3 = false;
            }
        }       
    }
    //---Validate Phone Tree 4---
    if (ed.Phone_Tree_4__c == ' ')
    {
       flag4 = false;        
    }
    else
    {
        if (ed.Phone_Tree_4_Result__c != null)
        {
           if (ed.Phone_Tree_4_Result__c == 'answered & accepted')
            {
                flag4 = true;
            }
            else
            {
                flag4 = false;
            }
        }     
    }
    //---Validate Phone Tree 5---
    if (ed.Phone_Tree_5__c == ' ')
    {
        flag5 = false;       
    }
    else
    {
        if (ed.Phone_Tree_5_Result__c != null)
        {
           if (ed.Phone_Tree_5_Result__c == 'answered & accepted')
            {
                flag5 = true;
            }
            else
            {
                flag5 = false;
            }
        }
        
    }
     //---Validate Phone Tree 6---
    if (ed.Phone_Tree_6__c == ' ')
    {
         flag6 = false;        
    }
    else
    {
        if (ed.Phone_Tree_6_Result__c != null)
        {
           if (ed.Phone_Tree_6_Result__c == 'answered & accepted')
            {
                flag6 = true;
            }
            else
            {
                flag6 = false;
            }
        }       
    }
    
    //---Perform Action--- 
    if (flag1 == false && flag2 == false && flag3 == false && flag4 == false && flag5 == false && flag6 == false)
    {
        ed.No_Response__c=True;
    }
    else
    {
        ed.No_Response__c=false;
    }  
}