global class TestBatch implements Database.Batchable<sObject>{
    
   
    
   global TestBatch(){
      //Query=q; Entity=e; Field=f;Value=v;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'Select Id from Case Limit 100';
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
         List<Case> cases = new List<Case>();

         for(sObject s : scope){
           // s.put(Field,Value); 
         	Case c = (Case) s;
           c.Status = 'Inquiry';
            cases.add(c);
         }
     	 //update scope;
     
    }

   global void finish(Database.BatchableContext BC){
   }
}