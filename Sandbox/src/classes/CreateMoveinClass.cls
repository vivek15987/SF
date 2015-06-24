global class CreateMoveinClass Implements Schedulable
            {                       
                        global void execute(SchedulableContext sc)
                        {
                                    specialoffer1();
                        }
                        public void specialoffer1()
                        {
                               List<Property__c> p=[Select Id,Name,Account1__c,MSA__c,Days_on_Market__c from Property__c ];
                                 
                              List<Move_in_Special__c> ms =[Select Id,Name,Account1__c,MSA1__c,Days_Vacant_End__c,Days_Vacant_Start__c,
                              Special_Expiration__c,Special_Start_Date__c,Special_Trigger__c From Move_in_Special__c where Special_Start_Date__c >=today and Special_Expiration__c <=today];                                                                        
                              
                             for(Move_in_Special__c m:ms)    
                              {
                              for(Property__c pp:p)
                              {
                               if(m.Special_Trigger__c == 'Account' && pp.Account1__c==m.Account1__c &&  pp.Days_on_Market__c >=m.Days_Vacant_Start__c && pp.Days_on_Market__c <=m.Days_Vacant_End__c) 
                               { 
                                pp.Move_in_Special1__c=m.Name;
                                update pp;    
                               }
                               else if(m.Special_Trigger__c == 'MSA' && pp.MSA__c==m.MSA1__c && pp.Account1__c==m.Account1__c &&  pp.Days_on_Market__c >=m.Days_Vacant_Start__c && pp.Days_on_Market__c <=m.Days_Vacant_End__c) 
                               {
                               pp.Move_in_Special1__c=m.Name;
                               update pp;  
                               }
                              }                        
                             } 
                        }                            
                            
             }