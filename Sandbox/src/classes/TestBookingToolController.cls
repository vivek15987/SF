@isTest
public class TestBookingToolController {
    static testMethod void testbookingtool() {
        
        Account a = new Account();
        a.name = 'Test Account';
        insert a;
        
        Property__c p = new Property__c();
        p.Account__c = a.Id;
        insert p;
        
        Case c = new Case();
        c.Status='Showing Set';
        c.Origin='Email';  
        c.Appointment_1_ID__c='';
        c.Appointment_1_Unit_ID__c='';
        c.Appointment_2_ID__c='';
        c.Appointment_2_Unit_ID__c='';
        c.Appointment_3_ID__c='';
        c.Appointment_3_Unit_ID__c='';
        insert c; 
        
        Contact ca = new Contact();
        ca.FirstName = 'Test 1';
        ca.LastName = 'Test';
        ca.AccountId = a.Id;
        insert ca;
        
        Contact ca1 = new Contact();
        ca1.FirstName = 'Test 2';
        ca1.LastName = 'Test';
        ca1.Weekend_Showings__c = 'Book upon availability';
        ca1.Same_Day_Showings__c = 'Book upon availability';
        ca1.AccountId = a.Id;
        insert ca1;
        
        Property_Agent__c pa = new Property_Agent__c();
        pa.Property__c = p.Id;
        pa.Contact__c = ca.Id;
        insert pa;
        
       
       Appointment__c a0 = new Appointment__c();
       a0.Invite_Status__c ='Invited';
       a0.Email__c='Email@gmail.com'; 
       a0.Case__c = c.Id;
       a0.Appointment_Date__c =system.today();  
       insert a0;
        
        Appointment__c a1 = new Appointment__c();
        a1.Invite_Status__c ='Accepted';
        a1.Email__c='Email@gmail.com';  
        a1.Property__c=p.Id; 
        a1.Case__c = c.Id;
        a1.Appointment_Date__c =system.today();  
        insert a1;
        
        
        Default_Availability__c da = new Default_Availability__c();
        da.Day__c = 'Monday';
        da.From__c = '8:00 a.m.';
        da.To__c = '6:00 p.m.';
        da.contact_rec_id__c = ca.Id;
        insert da;
        
        Default_Availability__c da1 = new Default_Availability__c();
        da1.Day__c = 'Tuesday';        
        da1.contact_rec_id__c = ca.Id;
        insert da1;
        
        Unvailability__c ua = new Unvailability__c();
        ua.av_Date__c = Date.newInstance(2014, 12, 3);
        ua.av_start_Time__c = '6:00 a.m.';
        ua.av_End_Time__c = '8:00 a.m.';
        ua.Saved_by__c = ca.Id;
        insert ua;
        
        Unvailability__c uaq = new Unvailability__c();        
        uaq.property__c = p.Id;
        uaq.av_Date__c = Date.newInstance(2014, 12, 4);     
        uaq.Saved_by__c = ca.Id;
        uaq.av_start_Time__c = '6:00 a.m.';
        uaq.av_End_Time__c = '8:00 a.m.';
        uaq.Type__c = 'Open House';
        insert uaq;        
        
        
        BookingToolController toolController = new BookingToolController(); 
        toolController.myMethod();
        BookingToolController.createAppointmentByAgent(ca.Id, '2/3/2015', p.Id, c.Id, '6 A.M.', '10 A.M.');
        Date myDate = Date.newInstance(2014, 12, 3);
        Date newDate = mydate.addDays(7);
        BookingToolController.getNextWeekAgentAvailability(p.Id,'2/3/2015','2/9/2015',false);
        BookingToolController.getNextWeekCocurrentBookings(p.Id,'12/3/2015','12/10/2015');       
        BookingToolController.getAppointmentsByAgent(ca, myDate, newDate);
        BookingToolController.getUnavailabiltyByOpenHouse(p.Id,'2/3/2015');         
        BookingToolController.getNextConcurrentShowings(p.Id,'2/3/2015');            
        
      //  system.today()
    }
}