trigger updateMostRecentContactNotes on Case (after insert,after update) {
    ProcessorControl.isNotRecursive=false;
    Case newCase = trigger.new[0]; 
    
    if( null != newCase.ContactId ) {
        String intContactId = newCase.ContactId;
        List<Contact> lstContacts = [ SELECT Name, Most_Recent_POI__c from Contact WHERE Id =:intContactId FOR UPDATE];
        
        Contact contact = lstContacts[0];
        
        if( null != newCase.Property_of_Interest__c ) {
             contact.Most_Recent_POI__c = newCase.Property_of_Interest__c;     
        }
       
        if( null != newCase.Floor_Plan_of_Interest__c ) {
            contact.Most_Recent_FPOI__c = newCase.Floor_Plan_of_Interest__c;
        }
        
        if( null != newCase.Unit_of_Interest__c ) {
            contact.Most_Recent_UOI__c = newCase.Unit_of_Interest__c;
        }
        
        if( null != newCase.Of_Occupants__c ) {
            contact.Number_of_Occupants__c = newCase.Of_Occupants__c;
        }
        
        if( null != newcase.Bed_Count_Pref__c ) {
            contact.Bed_Count_Pref__c = Decimal.valueOf(newCase.Bed_Count_Pref__c);
        }
        
        if( null != newCase.Bath_Count_Pref__c ) {
            contact.Bath_Count_Pref__c = Decimal.valueOf(newCase.Bath_Count_Pref__c);
        }
        
        if( null != newCase.Affordable_Inquiry__c ) {
            if( 'Yes' == newCase.Affordable_Inquiry__c ) {
                contact.Affordable_Inquiry__c = true;    
            } else {
                contact.Affordable_Inquiry__c = false;
            } 
        }
        
        if( null != newCase.Realtor_Inquiry__c ) {
            contact.Realtor_Inquiry__c = newCase.Realtor_Inquiry__c;
        }
        
        if( null != newCase.Reasons_For_Not_Setting_a_Showing__c ) {
            contact.Reason_for_Not_Setting_a_Showing__c = newCase.Reasons_For_Not_Setting_a_Showing__c;    
        }
        
        if( null != newCase.Origin ) {
            contact.Origin_Ad_Source__c = newCase.Origin;
        }
        
        if( null != newCase.Reason_for_Moving__c ) {
            contact.Reason_For_Moving__c = newCase.Reason_for_Moving__c;
        }
        
        if( null != newCase.Move_in_Date__c ) {
            contact.Desired_Move_In_Date__c = newCase.Move_in_Date__c;   
        }
        
        if( null != newCase.Desired_Rent_Start__c ) {
            contact.Desired_Rent_Range_Start__c = newCase.Desired_Rent_Start__c;
        } 
        
        if( null != newCase.Desired_Rent_Range_End__c ) {
            contact.Desired_Rent_Range_Max__c = newCase.Desired_Rent_Range_End__c;
        }
            
        if( null != newCase.Desired_Lease_length__c ) {
            contact.Desired_Lease_Length__c = String.valueOf(newCase.Desired_Lease_length__c);
        }
        
        if( null != newCase.Pet_Count__c ) {
            contact.Number_of_Pets__c = newCase.Pet_Count__c;
        }
        
        if( null != newCase.Pet_Type__c ) {
            contact.Pet_Types__c = newCase.Pet_Type__c;
        }
        
        if( null != newCase.Realtor_Name__c ) {
            contact.Realtor_Name__c = newCase.Realtor_Name__c;
        }
        
        if( null != newCase.Notes__c ) {
            contact.Most_Recent_Call_Notes__c = newCase.Notes__c;
        }
        
        if( null != newCase.Breed__c ) {
            contact.Pet_Breed_and_Name__c = newCase.Breed__c;
        }
        
        if( null != newCase.Pet_Name__c ) {
            contact.Pet_Breed_and_Name__c = contact.Pet_Breed_and_Name__c + ', ' + newCase.Pet_Name__c;
        }
        
        if( null != newCase.LastModifiedDate ) {
            String dateOutput =  newCase.LastModifiedDate.format('dd/MM/yyyy');
            contact.Lastest_Event__c =   dateOutput;
        }
        
        update contact;   
    }
}