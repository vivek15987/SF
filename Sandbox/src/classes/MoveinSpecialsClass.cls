global class MoveinSpecialsClass Implements Schedulable
            {                       
                        global void execute(SchedulableContext sc)
                        {
                                    specialoffer();
                        }
                        public void specialoffer()
                        {
                               String str;
                               List<Move_in_Special__c> ms =[Select Id,Name,Account__c,Account1__c,MSA1__c,Days_Vacant_End__c,Days_Vacant_Start__c,
                               Special_Expiration__c,Special_Start_Date__c From Move_in_Special__c];
                               for(Move_in_Special__c m:ms)
                               {                                              
                               List<Property__c> p=[Select Id,Account__c,Account1__c,MSA__c,Days_on_Market__c from Property__c 
                               where Account1__c=:m.Account1__c and MSA__c=:m.MSA1__c and Days_on_Market__c >=:m.Days_Vacant_Start__c and Days_on_Market__c <=:m.Days_Vacant_End__c];
                               for(Property__c pp:p)
                               {
                               pp.Move_in_Special1__c=m.Name;
                               update pp;    
                               } 
                               }
                                                                                    
                        }

            }