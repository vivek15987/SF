trigger UpdateMarketName2 on Case (before insert,before update){
    Case c= trigger.new[0];
    Integer j;
    Integer k;
    Boolean flag = false;
    if( (!Test.isRunningTest()) ) {
        
        if( Trigger.IsInsert ) {
            flag = true;
        }
        
        if( Trigger.IsUpdate ) {
            flag = false;
        
            if( c.AccountId !=  Trigger.oldMap.get(c.Id).AccountId || c.Property_of_Interest__c != Trigger.oldMap.get(c.Id).Property_of_Interest__c 
              	|| c.Ad_Source2__c != Trigger.oldMap.get(c.Id).Ad_Source2__c ){
                flag = true;
            }
        }
        //System.debug(' flag ' + flag);
        if( flag ) {
            if(c.AccountId != null && null != c.Ad_Source2__c )
            {    
                List<Source__c> sour=[Select Id, Account__c,Property__c,Property__r.Account__c from Source__c where Id=:c.Ad_Source2__c];  
                system.debug('Trigger sour - ' + sour );
                
                for(Source__c so:sour)
                {
                    if(so.Property__c != null)
                    {
                        if(c.AccountId==so.Property__r.Account__c)
                        {
                            c.Property_of_Interest__c=so.Property__c;  
                            c.Multi_Family_Case__c=true;
                        }               
                    }
                    if( Trigger.IsInsert && so != null ) {
                        so.Most_Recent_Case__c =  System.now();     
                    } 
                }
                Upsert sour;
            }
            
            //------------------------------------
            
            //--Code to populating "MSA Email 3 and MSA Email 4" field in case--------
            if(c.Property_of_Interest__c != null)
            {
                Property__c pp=[Select Id,Account_MSA_Junction__c,Account_MSA_Junction__r.MSA_Email_3__c,Account_MSA_Junction__r.MSA_Email_4__c from Property__c where Id=:c.Property_of_Interest__c];
                if(pp.Account_MSA_Junction__c != null)
                {
                    c.MSA_Email_3__c=pp.Account_MSA_Junction__r.MSA_Email_3__c;
                    c.MSA_Email_4__c=pp.Account_MSA_Junction__r.MSA_Email_4__c;
                }
            }
            //-----------------------------------------------    
            if(c.Account1__c!='' && c.Property_of_Interest1__c!='' && c.Property_Of_Interest_MSA__c!='')
            {
                for(Account_MSA_Connection__c[] ac :[Select Id,Name,Account1__c,MSA1__c from Account_MSA_Connection__c where Account1__c=:c.Account1__c and MSA1__c=:c.Property_Of_Interest_MSA__c])
                {
                    j=ac.size();
                }
                if(j>1)
                {
                    if(c.Group_Membership__c !=null && c.Group_Membership__c !='')
                    {
                        List<Account_MSA_Connection__c> amc=[Select Id,Name,Account1__c,MSA1__c,Group__c from Account_MSA_Connection__c 
                                                             where Account1__c=:c.Account1__c and MSA1__c=:c.Property_Of_Interest_MSA__c and Group__c=:c.Group_Membership__c];
                        for(Account_MSA_Connection__c am:amc)
                        {
                            c.Account_MSA_Junction__c = am.Id;                                                                          
                        }
                    }
                    else
                    {
                        List<Account_MSA_Connection__c> amc1=[Select Id,Name,Account1__c,MSA1__c,Group__c from Account_MSA_Connection__c 
                                                              where Account1__c=:c.Account1__c and MSA1__c=:c.Property_Of_Interest_MSA__c and Group__c=:c.Source_Grouping__c];
                        for(Account_MSA_Connection__c am1:amc1)
                        {
                            c.Account_MSA_Junction__c = am1.Id;                                                                          
                        }
                    }
                }
                else
                {
                    List<Account_MSA_Connection__c> amc2=[Select Id,Name,Account1__c,MSA1__c from Account_MSA_Connection__c 
                                                          where Account1__c=:c.Account1__c and MSA1__c=:c.Property_Of_Interest_MSA__c];
                    for(Account_MSA_Connection__c am2:amc2)
                    {
                        c.Account_MSA_Junction__c = am2.Id;                                                                          
                    }
                }
            }
            
            //---Code to set true and false value of "Group Allows GC to Agent" field ----
            if(c.AccountId != null)
            {
                List<Account> acc=[Select Id, Name, Deliver_GC_Inquiries_i_Prop_Agent__c from Account where Id=:c.AccountId];
                for(Account a:acc)
                {
                    if(a.Deliver_GC_Inquiries_i_Prop_Agent__c == true)
                    {
                        c.Group_Allows_GC_to_Agent__c=true;
                    }
                    else if(c.Property_of_Interest__c !=null)
                    {
                        Property__c pp=[Select Id,Group_Membership__r.Deliver_GC_Inquiries_o_Prop_Agent__c from Property__c where Id=:c.Property_of_Interest__c];
                        if(pp.Group_Membership__r.Deliver_GC_Inquiries_o_Prop_Agent__c==true)
                        {
                            c.Group_Allows_GC_to_Agent__c=true;
                        }
                        else
                        {
                            c.Group_Allows_GC_to_Agent__c=false;
                        }
                    }
                }
            }
            //-------------------------------------------------------------------
            
            //--This code for populating Primary Agent Assigned to POI field----- 
            if(c.Property_of_Interest1__c!='')
            {    
                Integer i;
                List<Property_Agent__c> pa=[Select Id ,Contact__r.Firstname,Contact__r.LastName,Email__c,Roles__c from Property_Agent__c where Property__c=:c.Property_of_Interest__c and Roles__c=null];
                if(pa.size()>0)
                {
                    for(Property_Agent__c ppa:pa)
                    {
                        c.Primary_Agent_for_Property_Of_Interest__c=ppa.Contact__r.Firstname+' '+ppa.Contact__r.LastName;
                        c.Primary_Agent_Assigned_to_POI__c=ppa.Email__c; 
                    } 
                }
                else
                {
                    
                    List<Property_Agent__c> pa1=[Select Id ,Contact__r.Firstname,Contact__r.LastName,Email__c,Roles__c from Property_Agent__c where Property__c=:c.Property_of_Interest__c and Roles__c='Primary Agent'];
                    if(pa1.size() > 0)
                    {
                        for(Property_Agent__c ppa1:pa1)
                        {
                            c.Primary_Agent_for_Property_Of_Interest__c=ppa1.Contact__r.Firstname+' '+ppa1.Contact__r.LastName;
                            c.Primary_Agent_Assigned_to_POI__c=ppa1.Email__c;   
                        }
                    }
                }    
            }
            
            if(c.Created_Date_and_Time__c != null )
            {
                String[] parts = c.Created_Date_and_Time__c.format().split(' ');
                String ct=(parts.size() == 3) ? (parts[1] + ' ' + parts[2]) : parts[1];
                c.Time_Case_Created__c=ct;
            }   
            else
            {
                String[] parts = c.CreatedDate.format().split(' ');
                String ct1=(parts.size() == 3) ? (parts[1] + ' ' + parts[2]) : parts[1];c.Time_Case_Created__c=ct1;
            }            
        }       
    }
}