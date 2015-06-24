trigger Modified_CaseField on Contact (after update) {
    Contact[] contactNew=trigger.new;
    Contact conNew=contactNew[0];
    Contact[] contactOld=trigger.old;
    Contact conOld=contactOld[0];
    Boolean flag=false;
    
    if( conNew.Status__c!=conOld.Status__c || conNew.Agent_Assigned__c!=conOld.Agent_Assigned__c
       || conNew.Phone!=conOld.Phone || conNew.Agent_Notes__c!=conOld.Agent_Notes__c 
       || conNew.Reason_For_Moving__c != conOld.Reason_For_Moving__c 
       || conNew.Desired_Move_In_Date__c!=conOld.Desired_Move_In_Date__c 
       || conNew.Email!=conOld.Email
       || conNew.Desired_Rent_Range_Start__c!=conOld.Desired_Rent_Range_Start__c
       || conNew.Desired_Rent_Range_Max__c!=conOld.Desired_Rent_Range_Max__c 
       || conNew.Desired_Lease_Length__c!=conOld.Desired_Lease_Length__c 
       || conNew.Number_of_Pets__c!=conOld.Number_of_Pets__c || conNew.Pet_Types__c!=conOld.Pet_Types__c 
       || conNew.Pet_Breed_and_Name__c!=conOld.Pet_Breed_and_Name__c 
       || conNew.Reason_for_Not_Setting_a_Showing__c!=conOld.Reason_for_Not_Setting_a_Showing__c
       || conNew.Bed_Count_Pref__c != conOld.Bed_Count_Pref__c 
       || conNew.Bed_Count_Pref__c!=conOld.Bed_Count_Pref__c
       || conNew.Bath_Count_Pref__c!=conOld.Bath_Count_Pref__c
       || conNew.Number_of_Occupants__c!=conOld.Number_of_Occupants__c
       || conNew.Most_Recent_UOI__c!=conOld.Most_Recent_UOI__c    
       || conNew.Most_Recent_FPOI__c!=conOld.Most_Recent_FPOI__c
       || conNew.Most_Recent_POI__c!=conOld.Most_Recent_POI__c )
    {
        flag = true;
    }

	System.debug(' FLAG ' + flag );
    
    if ( flag ){
        List<Case> caselst=[Select Status,Agent_Assigned__c,SuppliedPhone,Notes__c,Reason_for_Moving__c,Move_in_Date__c,SuppliedEmail,
                            Desired_Rent_Start__c,Desired_Rent_Range_End__c,Desired_Lease_length__c,Pet_Count__c,Pet_Type__c,Breed__c,Reasons_For_Not_Setting_a_Showing__c,
                            Bed_Count_Pref__c,Bath_Count_Pref__c,Of_Occupants__c,Unit_of_Interest__c,Floor_Plan_of_Interest__c,Property_of_Interest__c,
                            GC_Entered__c,Integration_Failed__c,integration_fail_success_message__c,Pop_Card_Entered_in_PMS__c,PC_Integration_Failed__c,
                            PC_Integration_Fail_Success_Message__c from Case where ContactId=:conNew.Id order by CreatedDate desc limit 1];
        
        if(caselst.size() >0)
        {
            caselst[0].Status=conNew.Status__c;
            caselst[0].Agent_Assigned__c=conNew.Agent_Assigned__c;
            caselst[0].SuppliedPhone=conNew.Phone;
            
            if( conNew.Agent_Notes__c != conOld.Agent_Notes__c ) {
                caselst[0].Notes__c=conNew.Agent_Notes__c;
            }
            
            caselst[0].Reason_for_Moving__c=conNew.Reason_For_Moving__c;
            caselst[0].Move_in_Date__c=conNew.Desired_Move_In_Date__c;
            caselst[0].SuppliedEmail=conNew.Email;
            caselst[0].Desired_Rent_Start__c=conNew.Desired_Rent_Range_Start__c;
            caselst[0].Desired_Rent_Range_End__c=conNew.Desired_Rent_Range_Max__c;
            if( conNew.Desired_Lease_Length__c != null ){
            	caselst[0].Desired_Lease_length__c=Integer.valueof(conNew.Desired_Lease_Length__c);    
            }
            caselst[0].Pet_Count__c=conNew.Number_of_Pets__c;
            caselst[0].Pet_Type__c=conNew.Pet_Types__c;
            caselst[0].Breed__c=conNew.Pet_Breed_and_Name__c;
            caselst[0].Reasons_For_Not_Setting_a_Showing__c=conNew.Reason_for_Not_Setting_a_Showing__c;
            if( conNew.Bed_Count_Pref__c != null ){
            	caselst[0].Bed_Count_Pref__c=String.valueof(conNew.Bed_Count_Pref__c);
            }
            if( conNew.Bath_Count_Pref__c != null ){
                caselst[0].Bath_Count_Pref__c=String.valueof(conNew.Bath_Count_Pref__c);
            }
            caselst[0].Of_Occupants__c=conNew.Number_of_Occupants__c;
            caselst[0].Unit_of_Interest__c=conNew.Most_Recent_UOI__c;
            caselst[0].Floor_Plan_of_Interest__c=conNew.Most_Recent_FPOI__c;
            caselst[0].Property_of_Interest__c=conNew.Most_Recent_POI__c;
        	caselst[0].GC_Entered__c=False;
            caselst[0].Integration_Failed__c=False;
            caselst[0].integration_fail_success_message__c='';
            //New code added on 3/13/2015-----
            caselst[0].Pop_Card_Entered_in_PMS__c=False;
            caselst[0].PC_Integration_Failed__c=False;
            caselst[0].PC_Integration_Fail_Success_Message__c='';
            //caselst[0].ResMan_Success_Error_Message__c='';
            //caselst[0].ResMan_Integration_Failed__c=False;
            //caselst[0].ResMan_GC_Entered__c=False;
            System.debug(ProcessorControl.isNotRecursive);    
            if(ProcessorControl.isNotRecursive)
            {
                System.debug(conNew.Most_Recent_POI__c);
                update caselst[0];
            }
         }
    }
}