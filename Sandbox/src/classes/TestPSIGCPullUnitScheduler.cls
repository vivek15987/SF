@istest
class TestPSIGCPullUnitScheduler {
    static testmethod void test() {
        Test.startTest();
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;
        
        Integration__c i1 = new Integration__c(); 
        i1.Account__c = a.Id;
        i1.Push_Guest_Cards_to_PSI__c = true;
        i1.PSI_API_URL__c = 'https://timepass.com';
        i1.PSI_Username__c = 'Username';
        i1.PSI_Password__c = 'Password';
        i1.Get_PSI_Unit_Availability__c = 'Hourly';
        i1.PSI_Integration_Active__c = true;
        i1.Grouping__c = g.Id; 
        i1.Deactivate_units_not_returned_in_feed__c = true;
        i1.PSI_Active_Unit_Statues__c = 'Occupied (Unavailable)';
        i1.PSI_InActive_Unit_Statues__c = 'On Notice (Unavailable)';
        i1.PSI_Active_No_Showings_Unit_Statues__c = 'UnOccupied (Unavailable)';
        insert i1;
        
        Property__c p1 = new Property__c();
        p1.Name = 'New Property';
        p1.Account__c = a.Id;
        p1.PSI_Prop_ID__c = 'anyhom5';
        p1.Address_Line_1__c = 'AAAAAAAAA';
        p1.City__c = 'Pune';
        p1.State__c = ' MH';
        p1.Zip_Code__c = '411013';
        p1.Group_Membership__c = g.Id;
        insert p1;
        
        Floor_Plan__c f1 = new Floor_Plan__c();
        f1.Account__c = a.Id;
        f1.Property__c = p1.Id;
        f1.PSI_Floor_Plan_ID__c = '251534';
        insert f1;
        
        Unit__c u1 = new Unit__c();
        u1.Account__c = a.Id;
        u1.Property__c = p1.Id;
        u1.Floor_Plan__c = f1.Id;
        u1.PSI_Unit_ID__c = '3191963';      
        insert u1;
        
        Unit__c u2 = new Unit__c();
        u2.Account__c = a.Id;
        u2.Property__c = p1.Id;
        u2.Floor_Plan__c = f1.Id;
        u2.PSI_Unit_ID__c = '';      
        insert u2;
         
        PSIGCPullUnitScheduler psipullUnit = new PSIGCPullUnitScheduler( 3 );
        psipullUnit = new PSIGCPullUnitScheduler();
        
        System.schedule( 'PSIGCPullUnitScheduler', '0 0 * * * ?', new PSIGCPullUnitScheduler(3) );
        
        PSIGCPullUnitBatch UnitBatch = new PSIGCPullUnitBatch();
        UnitBatch = new PSIGCPullUnitBatch();
        Database.executeBatch( UnitBatch, 4 );
       
        Test.stopTest();  
   }
}