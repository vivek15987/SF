trigger UpdateProperty_Price_Active_byFP on Floor_Plan__c (after insert, after update)
{
    Floor_Plan__c fp=trigger.New[0];
    Property__c p=[Select Id,Active__c,Price__c,Multi_Family_Property__c from Property__c where Id=:fp.Property__c];
    if(p.Multi_Family_Property__c==false && p.Active__c != 'New Property Queue' )
    {
        p.Active__c=(fp.Active__c==true)?'Yes':'No';
        p.Price__c=fp.Effective_Rent__c;
        update p;
    }
}