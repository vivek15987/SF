/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class upsertMarketNameOnCaseTest {

    static testMethod void myUnitTest() {
    
       Account accObj = new Account();
       accObj.name = 'Test Account';
       accObj.Type = 'Management Company';
       insert accObj;
       
       MSA__c msaObj = new MSA__c();
       msaObj.Name = 'Test MSA';
       msaObj.County_Number__c = 10;
       msaObj.MSA_No__c = '100';
       msaObj.State__c = 'USA';
       insert msaObj;
       
       Zip_Code__c zipCodeObj = new Zip_Code__c();
       zipCodeObj.Name = 'Test ZipCode';
       zipCodeObj.State__c = 'UK';
       zipCodeObj.MSA__c = msaObj.Id;
       insert zipCodeObj;
       
       Account_MSA_Connection__c accountMSAObj = new Account_MSA_Connection__c();
       accountMSAObj.Name = 'Test Account MSA Object';
       accountMSAObj.Account__c = accObj.Id;
       accountMSAObj.MSA__c = msaObj.Id;
       insert accountMSAObj;
       
       Property__c propertyObj = new Property__c();
       propertyObj.Name = 'Test Property';
       propertyObj.Active__c = 'Prep';
       propertyObj.Price__c = 100;
       propertyObj.Square_Footage__c = 10;
       propertyObj.Bed_Count__c =10;
       propertyObj.Bath_Count__c =10;
       propertyObj.Pet_Policy__c = 'Yes';
       propertyObj.Lease_Terms__c = 10;
       propertyObj.Address_Line_1__c = 'RichMond';
       propertyObj.City__c = 'ScotLand';
       propertyObj.State__c = 'USA';
       propertyObj.Zip_Code__c = '12345';
       propertyObj.Default_Appointment_Length__c = '60';
       propertyObj.Account__c = accObj.Id; 
       propertyObj.Zip_Code_Lookup__c = zipCodeObj.Id;
       insert propertyObj;
       
       Case caseObj = new Case();
       caseObj.Status = 'Inquiry';
       caseObj.Guest_Card_Status__c = 'In Progress';
       caseObj.Property_of_Interest__c = propertyObj.Id;
       caseObj.AccountId = accObj.Id;
       Test.StartTest();
           insert caseObj;
       Test.StopTest();
    }
}