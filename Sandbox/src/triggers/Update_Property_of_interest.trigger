trigger Update_Property_of_interest on Service_Request1__c (before insert, before update) {
Service_Request1__c s = trigger.new[0];
//Service_Request1__c s_old =  //new Service_Request1__c(); //Trigger.old[0];//.old[0];
Boolean flag = false;
//---Code to populating "Property of Interest" field in Service Request----
    if( Trigger.IsInsert ) {
        flag = true;
    }
    
    if( Trigger.IsUpdate ) {
        flag = false;
    
        if( s.Account__c !=  Trigger.oldMap.get(s.Id).Account__c || s.Property_of_Interest__c != Trigger.oldMap.get(s.Id).Property_of_Interest__c ){
            flag = true;
        }
    }
    
    if( flag ) {
        if(s.Account_Name__c != null)
        {    
            List<Source__c> sour=[Select Id, Account__c,Property__c,Property__r.Account__c from Source__c where Id=:s.Source__c];  
            for(Source__c so:sour)
            {	
               
                if(so.Property__c != null)
                {
                    if(s.Account_Name__c==so.Property__r.Account__c)
                    {
                        s.Property_of_Interest__c=so.Property__c;  
                        s.Multi_Family_SR__c=true; 
                    }               
                } 
                if( Trigger.IsInsert && so != null ) {
                	so.Most_Recent_Case__c =  System.now();     
                } 
            }
            Upsert sour;
        }    
        //----------------------------------------------------------------------------
        
        //-------Update Grouping field from property 11/14/2014----------------------
        if(s.Property_of_Interest__c != null)
        {
            List<Property__c> proplst=[Select Group_Membership__c from Property__c where Id=:s.Property_of_Interest__c];
            if(proplst[0].Group_Membership__c != null)
            {
                s.Grouping__c=proplst[0].Group_Membership__c;
            }
        }
        
        //---------------------------------------------------------------------------
        //-------Update Unit Needing Service field from Unit 2/18/2015----------------------
        if(s.Property_of_Interest__c != null)
        {
            List<Property__c> proplst=[Select Id, Multi_Family_Property__c from Property__c where Id=:s.Property_of_Interest__c];
            if(proplst.size()>0)
            {
                if(proplst[0].Multi_Family_Property__c==false)
                {
                    List<Unit__c> unitlst=[Select id,Name,Building_Name_Number__c,Level__c from Unit__c where Property__c=:proplst[0].Id];
                    if(unitlst.size()>0 && unitlst.size()<2) 
                    {
                        s.Unit_Needing_Service__c=unitlst[0].Id;
                        s.Unit_Name__c=unitlst[0].Name;
                        s.Building_Name_Number__c=unitlst[0].Building_Name_Number__c;
                        s.Level__c=unitlst[0].Level__c;
                    }
                }
            }   
        }
        
        if(s.Unit_Needing_Service__c !=null)
        {
            List<Unit__c> unitlst=[Select Name,Building_Name_Number__c,Level__c from Unit__c where Id=:s.Unit_Needing_Service__c];
            s.Unit_Name__c=unitlst[0].Name;
            s.Building_Name_Number__c=unitlst[0].Building_Name_Number__c;
            s.Level__c=unitlst[0].Level__c;
        }
    }
    
//---------------------------------------------------------------------------

}