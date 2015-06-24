trigger UpdateNameOnReversePhoneLookUp on Contact (after insert) {  
    if (!system.isFuture() && !System.isBatch())  
    { 
        List<String> Contact_lst = new List<String>{};
    
        String contact_Id = ''; 
        String account_Id = ''; 
        String phone_number = ''; 
        String mobile_number = ''; 
        
        Contact c= trigger.new[0];
        
        if(c.RecordTypeId != null) { 
            List<RecordType> lstRecordType = [ select Name From RecordType Where Id=:c.RecordTypeId LIMIT 1];               
             
            if((c.Created_by_ShowPro_User__c == null || c.Created_by_ShowPro_User__c == false ) && ( lstRecordType.size() > 0 && lstRecordType[0].Name != null && lstRecordType[0].Name == 'Guest' ) ) { 
                if(c.Phone != null ){
                    phone_number = c.Phone;
                } else if(c.MobilePhone != null){
                    phone_number = c.MobilePhone;
                }
                
                if(c.AccountId != null){
                    account_Id = c.AccountId;
                }
                if(c.Id != null){
                    contact_Id = c.Id;
                }
                
                if(account_Id != '' && phone_number != '' && contact_Id != ''){
                    List<Account> lstAccount = [ select Id, Reverse_Look_Up__c From Account Where Id=:account_Id ]; 
                    for (Account a: lstAccount)
                    { 
                        if(a.Reverse_Look_Up__c == true){
                            if( !test.isRunningTest() ) { 
                                ReverseLookUp.myMethod( phone_number, contact_Id );
                            }
                        }
                    }
                } 
            }
        }
    }
}