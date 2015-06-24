@isTest(SeeAllData=true) 
public class UpdatePopCardIntegrationToEnableTest {

    static testMethod void validateUpdatePopCardIntegrationToEnable () {
         
         Account a=new Account();
         a.Name ='Test';
         a.Phone='2130456';
         a.Type='Test Tyep';
         a.Enable_PopCard_Integration__c=false;
         insert a;
        
         Property__c p1 = new Property__c();
         p1.Account__c = a.Id;
         p1.Enable_PopCard_Integration__c = false;
         insert p1;
        
         Property__c p2 = new Property__c();
         p2.Account__c = a.Id;
         p2.Enable_PopCard_Integration__c = false;
         insert p2;
        
         Property__c p3 = new Property__c();
         p3.Account__c = a.Id;
         p3.Enable_PopCard_Integration__c = false;
         insert p3;
        
        a.Enable_PopCard_Integration__c=false;
        
        update a;
         
         Test.startTest();        
         Test.stopTest();         
    }        
}