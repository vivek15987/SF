@isTest
public class testSalesForceRecordCorrection {

    static testMethod void yardiGCCorrection() {
        Account a1 = new Account();
        a1.Name = 'na';
        insert a1;
        
        Case cs = new Case();
        cs.Origin = 'Email';
       	cs.Move_in_Date__c = date.today();
        cs.Date_Time_Sent_Via_Workflow__c = date.today();
        cs.Guest_Card_Status__c = 'Sent via Workflow';
        cs.Integration_Failed__c = false;
        cs.GC_Entered__c = true;
        cs.Desired_Rent_Start__c = 2;
        cs.Desired_Lease_length__c = 2;
        cs.Notes__c = 'Hello Hi iiiiii ';
        cs.AccountId = a1.Id;
        insert cs;
        
        SFRecordCorrectionBatch GCCorrectionRecords = new SFRecordCorrectionBatch( true );
 	  	ID batchprocessid = Database.executeBatch(GCCorrectionRecords,50); 
        GCCorrectionRecords = new SFRecordCorrectionBatch();
        batchprocessid = Database.executeBatch(GCCorrectionRecords,50); 
        
        Case cs2 = new Case();
        cs2.Origin = 'Email';
       	cs2.Move_in_Date__c = date.today();
        cs2.Date_Time_Sent_Via_Workflow__c = date.today();
        cs2.Guest_Card_Status__c = 'Sent via Workflow';
        cs2.Integration_Failed__c = false;
        cs2.GC_Entered__c = false;
        cs2.Desired_Rent_Start__c = 2;
        cs2.Desired_Lease_length__c = 2;
        cs2.Notes__c = 'Hello Hi iiiiii ';
        cs2.Integration_Failed__c = TRUE;
        cs2.AccountId = a1.Id;
        insert cs2;
        
        SFGuestCardChangesForPBBell GCPBBellRecords = new SFGuestCardChangesForPBBell( true );
      	ID batchprocessid2 = Database.executeBatch( GCPBBellRecords, 50 );
        GCPBBellRecords = new SFGuestCardChangesForPBBell();
      	batchprocessid2 = Database.executeBatch( GCPBBellRecords, 50 );

        Case cs3 = new Case();
        cs3.Origin = 'Email';
       	cs3.Move_in_Date__c = date.today();
        cs3.Date_Time_Sent_Via_Workflow__c = date.today();
        cs3.Guest_Card_Status__c = 'Sent via Workflow';
        cs3.Integration_Failed__c = false;
        cs3.GC_Entered__c = false;
        cs3.Desired_Rent_Start__c = 2;
        cs3.Desired_Lease_length__c = 2;
        cs3.Notes__c = 'Hello Hi iiiiii ';
        cs3.AccountId = a1.Id;
        cs3.Integration_Failed__c = TRUE;
        insert cs3;
        
        SFGuestCardChangesForBLT GCBLTRecords = new SFGuestCardChangesForBLT( true );
      	ID batchprocessid3 = Database.executeBatch( GCBLTRecords, 50 );

        System.schedule('jobName', '0 0 * * * ?', new SalesForceRecordCorrection());
        
    }
}