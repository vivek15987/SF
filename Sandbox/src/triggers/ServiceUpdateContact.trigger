trigger ServiceUpdateContact on Service_Request1__c (after insert, after Update) 
{
    Service_Request1__c s = trigger.new[0];
    if(s.Corrected_First_Name__c != null || s.Corrected_Last_Name__c != null || s.Corrected_Mobile_Phone__c != null || s.Corrected_Email__c != null)
    {
        List<Contact> co=[SELECT Id,FirstName,LastName,MobilePhone,Email,Recordtype.Name FROM Contact where Id=:s.Contact_Name__c LIMIT 1];
        for(Contact cc:co)
        {
            if(cc.Recordtype.Name =='Guest')
            {
                if(s.Corrected_First_Name__c != null)
                {
                    cc.FirstName=s.Corrected_First_Name__c;
                }
                if(s.Corrected_Last_Name__c != null)
                {
                    cc.LastName=s.Corrected_Last_Name__c;
                }
                if(s.Corrected_Mobile_Phone__c != null)
                {
                    cc.MobilePhone=s.Corrected_Mobile_Phone__c;
                }
                if(s.Corrected_Email__c != null)
                {
                    cc.Email=s.Corrected_Email__c;
                }
                update cc;
            }
        }
    }
}