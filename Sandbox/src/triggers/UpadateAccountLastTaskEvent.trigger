trigger UpadateAccountLastTaskEvent on Task (after insert,after update) {
    
    Task updatedTask = trigger.new[0];    
    if( updatedTask.AccountId != null ) {
        List<Account> lstAccount = [ Select Id,AM_ID__c,Next_Open_Task_by_AM__c from Account Where Id =: updatedTask.AccountId ];
    
        if( lstAccount.size() > 0 ) {
            Account account = lstAccount.get(0);
            if( account.AM_ID__c == updatedTask.OwnerId && updatedTask.Status == 'Completed' ) {
                account.Last_Completed_Task_by_AM__c = Date.today();
            }           
            
            if( account.AM_ID__c == updatedTask.OwnerId ){
                List<Task> lstPendingTask = [ Select Id,ActivityDate from Task 
                                         				 Where OwnerId=: updatedTask.OwnerId 
                                                         AND Status != 'Completed'
                                            			 AND AccountId =: account.Id
                                        				 ORDER BY ActivityDate];
                if( lstPendingTask.size() > 0 ) {
                    Task nextPendingTask = lstPendingTask.get( 0 );
                    account.Next_Open_Task_by_AM__c = nextPendingTask.ActivityDate;
                }           
            }
                 
            update account;
        }
    }
}