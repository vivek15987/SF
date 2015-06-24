@isTest(SeeAllData=true)
public class TestUpdateNameOnReversePhoneLookUp {
    static testMethod void validateNameOnReversePhonelookUp() {
        Test.startTest();
         Account a=new Account();
         a.Name ='TEST'; 
         a.Phone='9999999';
         a.Type='Test Surgaya'; 
         a.Reverse_Look_Up__c = true;
         insert a;   
        
        String recordName = 'Guest';
        List<RecordType> r = [ select Name From RecordType Where Name=:recordName LIMIT 1];              
        if(r.size() > 0 && r[0].Name == 'Guest' ){  
             Contact c = new Contact();
             c.FirstName = 'New';
             c.LastName = 'User';
             c.Phone = '+16502530000';
             c.MobilePhone = ''; 
             c.Email = 'surgaya.khundrakpam@anyonehome.com';
             c.AccountId = a.Id;
             c.RecordTypeId = r[0].Id; 
             insert c;  
            
            String contact_id = c.Id;
            List<RecordType> r1 = [ select Name From RecordType Where Id=:c.RecordTypeId LIMIT 1];    
            if(a.Reverse_Look_Up__c == true && r1.size() > 0 && r1[0].Name == 'Guest'){
                ReverseLookUp.myMethod( '+16502530000', contact_id );   
            } 
        }
        Test.stopTest(); 
     } 
}