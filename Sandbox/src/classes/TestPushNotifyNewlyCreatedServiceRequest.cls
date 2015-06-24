@isTest
public class TestPushNotifyNewlyCreatedServiceRequest {
	static testMethod void createservicerequest() {
        
        Account a = new Account();
       	a.Name = 'Test Account';
       	insert a;
        
        Property__c p1 = new Property__c();
        p1.Name = 'New Property';
        p1.Account__c = a.id;
        p1.Address_Line_1__c = 'AAAAAAAAA';
        p1.City__c = 'Pune';
        p1.State__c = ' MH';
        p1.Zip_Code__c = '411013';
        p1.PSI_Prop_ID__c = '104143';
       	insert p1;
        
        Contact c = new Contact();
        c.FirstName = 'Test6';
        c.LastName = 'Test6';
        c.AccountId = a.Id;        
        c.Anyone_Home_Type__c = 'Agent';
        c.MobilePhone = '11111';
        c.Email = 'aaaaaa@s.com';
        c.Phone	= '222';
        insert c;
        
        Floor_Plan__c floorplan = new Floor_Plan__c();
        floorplan.PSI_Floor_Plan_ID__c = 'ABD';
        floorplan.Property__c = p1.Id;
        floorplan.Account__c = a.Id;
        insert floorplan;
        
        Unit__c Unit = new Unit__c();
        Unit.Floor_Plan__c = floorplan.Id;
        Unit.Property__c = p1.Id;
        Unit.Account__c = a.Id;
        Unit.PSI_Unit_ID__c = 'PQR';
        Unit.Name = 'xyz';
        Unit.Bedrooms__c = 2.00;
        Unit.Bathrooms__c = 2.00;
        Unit.Square_Feet__c = '20';
        Unit.Maximum_Rent__c = 200;
        Unit.Market_Rent__c = 100;
        
        insert Unit;
        
        Service_Request1__c sr = new Service_Request1__c();
        sr.Property_of_Interest__c = p1.Id;
        sr.Account_Name__c = a.Id;
        sr.Unit_Needing_Service__c = Unit.Id;
        insert sr;
    }
}