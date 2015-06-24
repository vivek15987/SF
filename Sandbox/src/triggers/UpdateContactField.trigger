trigger UpdateContactField on Case (after insert, after Update) 
{
    String name = '';
    String contact_id = '';
    Case c = trigger.new[0];
    if(c.ContactId != null ){
        List<Contact> co=[SELECT Id,FirstName,LastName,MobilePhone,Email,Recordtype.Name FROM Contact where Id=:c.ContactId];
        if(co.size() > 0 ){ 
            for(Contact cc:co)
            {
                if(cc.Recordtype.Name =='Guest')
                {
                    if(c.Correct_First_Name__c != null)
                    {
                        cc.FirstName=c.Correct_First_Name__c;
                    }
                    if(c.Corrected_Last_Name__c != null)
                    {
                        cc.LastName=c.Corrected_Last_Name__c;
                    }
                    if(c.Corrected_Alt_Phone__c != null)
                    {
                        cc.MobilePhone=c.Corrected_Alt_Phone__c;
                    }
                    if(c.Corrected_Email__c != null)
                    {
                        cc.Email=c.Corrected_Email__c;
                    }
                    contact_id = cc.Id;
                    name = cc.FirstName + ' ' + cc.LastName;
                }
            }
            update co; 
        }
        if (!system.isFuture() && !System.isBatch())  
        { 
            if( null != c.Ad_Source2__c ){ 
                List<Case> cs=[SELECT Id  FROM Case where ContactId=:c.ContactId AND Ad_Source2__c =:c.Ad_Source2__c];
                if(cs.size() > 7 ) {
                    if (!Test.isRunningTest() && !System.isBatch() )
                    {
                        //Execute the call 
                        SendContactCaseEmail.SendNotificationEmail(contact_id, name);
                    }
                } 
                
            }
        }
        
    }
}