global class Appointment_Invite_Status Implements Schedulable
{                       
    global void execute(SchedulableContext sc)
    {    
       Update_Appointment_Invite_Status b=new Update_Appointment_Invite_Status();
       database.executeBatch(b);                          
    }                    
}