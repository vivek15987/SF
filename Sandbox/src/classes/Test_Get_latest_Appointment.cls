@isTest
private class Test_Get_latest_Appointment {
    static testMethod void Unitlatest_Appointment()
    {  
        Contact ct=new Contact();
        ct.FirstName='Test Name'; 
        ct.LastName='Tst Last';
        ct.MobilePhone='21345684';
        ct.Email='surgaya@gmail.com';
        insert ct; 
        
        Case c = new Case();  
        c.Status='Test'; 
        insert c; 
        
        Appointment__c a=new Appointment__c();
        a.case__c=c.Id;
        a.Appointment_Date__c=Date.parse('3/8/2014');
        a.Contact__c = ct.Id;
        insert a;
        
        Test.starttest();
        Test.stoptest();
    }
}