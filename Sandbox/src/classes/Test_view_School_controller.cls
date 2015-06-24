@isTest
public class Test_view_School_controller {
    static testMethod void test_view_School_controller()
    {
        Test.startTest();
        Account a = new Account();
        a.name = 'Test Account';
        insert a;
        
        Zip_Code__c z = new Zip_Code__c();
        z.State__c = 'AK';
        z.Latitude__Latitude__s = 25.79;
        z.Latitude__Longitude__s = 25.79;
        z.Longitude__Longitude__s  = -80.13;
        z.Longitude__Latitude__s = -80.13;
        insert z;
        
        Property__c p = new Property__c();
        p.Account__c = a.Id;
        p.Zip_Code_Lookup__c = z.id;
        insert p;
        
        View_school_controller VS_controller = new View_school_controller();
        VS_controller.myMethod(); 
        
        ApexPages.CurrentPage().getparameters().put('pid', p.id);        
        ApexPages.StandardController sc = new ApexPages.StandardController( p );
        View_school_controller controller1 = new View_school_controller(sc); 
        View_school_controller.getSchools(p.id); 
        Test.stopTest();
    }
}