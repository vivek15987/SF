global class UpdateAppointmentBatch implements Database.Batchable<Appointment__c>, Database.AllowsCallouts{
	public List<Appointment__c> UpdatedAppointments = new List<Appointment__c>(); 
    public String PropertyName;
    
    global UpdateAppointmentBatch( String PropertyName ) {
        this.PropertyName = PropertyName;
    }
    
    global Iterable<Appointment__c> start(Database.BatchableContext BC) {
        List<Appointment__c> appList = new List<Appointment__c>();
        
        appList =[Select Id, Invite_Status__c, CanceledRejected_By__c  From Appointment__c where Property_name__c=:this.PropertyName and Appointment_Date__c>=today AND (Invite_Status__C='Invited' OR Invite_Status__C='Accepted') ];
        
        for( Appointment__c apt: appList ) {
            apt.Invite_Status__c = 'Canceled' ;
            apt.CanceledRejected_By__c = 'Automated System (home leased)';
            UpdatedAppointments.add(apt);
        }
        
        return UpdatedAppointments;
    }
    
    global void execute(Database.BatchableContext BC, List<Appointment__c> appointments){
       	upsert appointments;     
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}