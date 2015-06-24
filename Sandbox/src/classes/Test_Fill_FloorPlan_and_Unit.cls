@isTest
public class Test_Fill_FloorPlan_and_Unit
{
    static testmethod void testfillfloorplan()
    {
       Account a=new Account();
       a.Name='test';
       a.Type='test';       
       insert a;
       
       Property__c p = new Property__c();
       p.Name='Test Namee';    
       p.Active__c='Yes';
       p.Price__c=decimal.valueof('12.30');
       p.Account__c=a.Id;
       p.Square_Footage__c=decimal.valueof('23.30');
       p.Bed_Count__c=decimal.valueof('23.30');
       p.Bath_Count__c=decimal.valueof('23.30');
       p.Pet_Policy__c='Test pet';
       p.Lease_Terms__c=decimal.valueof('23.30');
       p.Address_Line_1__c='Address';
       p.City__c='Test City';
       p.State__c='Test State';
       p.Zip_Code__c='Zip';
       p.Default_Appointment_Length__c='Test app';
       insert p; 
       
       Floor_Plan__c fp=new Floor_Plan__c();
       fp.Name='test';
       fp.Account__c=a.Id;
       fp.Property__c=p.Id;
       insert fp;
       
       Unit__c u=new Unit__c();
       u.Name='test unit';
       u.Account__c=a.Id;
       u.Property__c=p.id;
       u.Floor_Plan__c = fp.id;
       insert u;
       
       Case c=new Case();
       c.Status='Inquiry';
       c.Accountid=u.Account__c;
       c.Floor_Plan_of_Interest__c=fp.Id;
       c.Property_of_Interest__c = u.Property__c;
       c.Unit_of_Interest__c=u.id;
       //c.Unit_of_Interest_2__c=u.id;     
       insert c;
       
       Appointment__c app = new Appointment__c();
       app.Invite_Status__c = 'Invited';
       app.Case__c=c.Id;
       app.Appointment_Date__c = Date.Parse('12/12/2013');
       app.Invite_Status__c = 'Accepted';  
       insert app;       
              
    }
}