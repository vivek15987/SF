global class SalesForceRecordCorrection implements Schedulable {
   	global void execute(SchedulableContext sc) {
      	SFRecordCorrectionBatch GCCorrectionRecords = new SFRecordCorrectionBatch();
 	  	ID batchprocessid = Database.executeBatch(GCCorrectionRecords,50);            
 	  	System.debug('Updated GC Object : ' + batchprocessid);
       
      	SFGuestCardChangesForPBBell GCPBBellRecords = new SFGuestCardChangesForPBBell();
      	ID batchprocessid2 = Database.executeBatch( GCPBBellRecords, 50 );
      	System.Debug( 'Updated GC Objects for PBBell:' + batchprocessid2 );
         
        SFGuestCardChangesForBLT GCBLTRecords = new SFGuestCardChangesForBLT();
      	ID batchprocessid3 = Database.executeBatch( GCBLTRecords, 50 );
      	System.Debug( 'Updated GC Objects for PBBell' + batchprocessid3 );
        
    }
}