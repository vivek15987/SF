@isTest
public class testSFGCRecordCorrection {

    static testMethod void testSFGCRecordCorrection(){

        Account a1 = new Account();
        a1.Name = 'Yo';
        insert a1;
        
        Case cs4 = new Case();
        cs4.Origin = 'Email';
        cs4.Yardi_Guest_Card_ID__c = NULL;
        cs4.Date_Time_Sent_Via_Workflow__c = date.today();
        cs4.Guest_Card_Status__c = 'Sent via Workflow';
        cs4.Integration_Failed__c = true;
        cs4.AccountId = a1.Id;
        insert cs4;

        SFGCRecordCorrectionBatch GCAHomesRecords1 = new SFGCRecordCorrectionBatch();        
        SFGCRecordCorrectionBatch GCAHomesRecords = new SFGCRecordCorrectionBatch( true );
        ID batchprocessid4 = Database.executeBatch( GCAHomesREcords, 20 );
        
        BlockedSFRecordsForBridge test = new BlockedSFRecordsForBridge();        
        BlockedSFRecordsForBridge testRecords = new BlockedSFRecordsForBridge( true );
        ID batchprocessid5 = Database.executeBatch( testRecords, 20 );
    }
    
}