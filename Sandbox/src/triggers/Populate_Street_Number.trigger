trigger Populate_Street_Number on Property__c (before insert, before update) {
    for( Property__c p: Trigger.new ){
        boolean flag=false;
        if(trigger.IsInsert)
        {
            if(p.Address_Line_1__c !=null)
            {
                flag=true;
            }
        }
        else if(trigger.IsUpdate)
        {
            if(p.Street_Number__c == null && p.Address_Line_1__c !=null)
            {
                flag=true;
            }        
            if(p.Address_Line_1__c!=trigger.old[0].Address_Line_1__c )
            {
                flag=true;
            }
        }
        
        if(flag)
        {
            if( p.Address_Line_1__c != null )
            {
               String[] address=p.Address_Line_1__c.split(' ');
                p.Street_Number__c=Address[0]; 
            }            
        }
    }
    
}