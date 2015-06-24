@isTest 
public class TestPSIStatusMapping {
    
    static testMethod void Testpsistatusmapping() {
        
        Test.startTest();
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Integration__c i1 = new Integration__c();
        i1.Account__c = a.Id;
        i1.PSI_Username__c = 'user_name';
        i1.PSI_Password__c = 'password';
        i1.PSI_API_URL__c = 'URL';
        i1.PSI_Active_Unit_Statues__c = 'ABC; DEF;';
        i1.PSI_InActive_Unit_Statues__c = 'GHI';
        i1.PSI_Active_No_Showings_Unit_Statues__c = 'JKL';
        insert i1;

        Test.stopTest();
        
    }
}