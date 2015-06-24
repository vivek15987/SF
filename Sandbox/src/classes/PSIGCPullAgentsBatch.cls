global class PSIGCPullAgentsBatch implements Database.Batchable<Contact>, Database.AllowsCallouts{
	List<Contact> arrobjContacts;
    
    public Boolean isPSIGCPullAgentsScheduler = true;
    public PSIGCPullAgentsController psi = new PSIGCPullAgentsController();
    
    public PSIGCPullAgentsBatch( Boolean isPSIGCPullAgentsScheduler ) {
        this.isPSIGCPullAgentsScheduler = isPSIGCPullAgentsScheduler;
       /* List<Floor_Plan__c> FPs = [SELECT Floorplan_ID__c FROM Floor_Plan__c WHERE Floorplan_ID__c IN ( '109-1.1', '109-2.1', '109-loft', '109-s.1', '114.1.1', '114.2.1', '114.2.2', '114.2.2t', '120.1.1', '120.2.1', '120.2.2', '126.1.1', '126.11th', '126.2.1', '126.21th', '12611m', '12621m', '12621thm', '129-1.1', '129-2.2', '130-1.1', '130-1.1l', '130-2.2', '130-2.2l', '139.1.1', '139.1.1l', '139.2.1h', '139.2.1t', '139.3.1t', '139.stud', '151.1.1a', '151.1.1b', '151.1.1c', '151.2.1r', '151.2.2', '151.2.2r', '15111ar', '15111br', '15111cr', '152.1.1a', '152.1.1b', '152.11ar', '152.11br', '152.2.1', '152.2.1r', '15221lr', '152house', '1x1', '1x1b20', '1x1b8', '1x1pr', '1x1prr', '1x1r', '201.1.1', '201.1.1r', '201.11dr', '201.2.1', '201.2.1r', '201.3.2', '201.jr', '201.jr.r', '209.a.1', '209.a.2', '209.b.1', '209.b.2', '209.b.3', '209.b.4', '209.stud', '2x1', '2x1b8', '2x1pr', '2x1prr', '2x1r', '2x1yd', '2x1ydr', '301.1.1', '301.2.1', '305.1.1', '305.1.1r', '305.2.1', '305.2.2', '305.2.2r', '3578-11r', '3578-21a', '3578-21b', '3578-21r', '3578-2b2', '3578-2br', '3578-2da', '3578-2dr', '3578-2r2', '3578-32a', '3578-32r', '3578-3r2', '3579-11r', '3579-1x1', '3579-21r', '3579-22r', '3579-2x1', '3579-2x2', '3579-32r', '3579-3x2', '3589-1d', '3589-1dr', '3589-1u', '3589-1ur', '3589-2d', '3589-2dr', '3589-2u', '3589-2ur', '3bd3bh', '3x1r', 'a1-ashp', 'a1a-ashp', 'a2-ashp', 'almea1', 'almea2', 'almea3', 'almea4', 'almeb1', 'almeb2', 'almeb3', 'almeb4', 'almeb5', 'almeb6.1', 'almeb6.2', 'almeb6.3', 'almeb6.4', 'almeb7', 'almec1', 'almec2', 'almel1', 'b1-ashp', 'b2-ashp', 'b2a-ashp', 'b3-ashp', 'bu1030r2', 'bu1040r2', 'bur.1008', 'bur.1016', 'bur.1024', 'bur.1025', 'bur.1036', 'bur.1200', 'bur.730r', 'bur.767r', 'bur.775r', 'bur.792', 'bur.792r', 'bur.980', 'bur1008r', 'bur1016r', 'bur1024r', 'bur1035r', 'bur1036r', 'bur1040r', 'bur1047r', 'bur1050r', 'bur1060r', 'bur1076r', 'bur1200r', 'bur775r2', 'bur792r2', 'bur980r2', 'c1-ashp', 'c1a-ashp', 'hgrv-a1', 'hgrv-a2', 'hgrv-a3', 'hgrv-a4', 'hgrv-b1', 'hgrv-b2', 'hgrv-c1', 'hgrv-c2', 'hgrv-d1', 'hgrv-d2', 'rvsa10a', 'rvsa10b', 'rvsa10c', 'rvsa10d', 'rvsa10e', 'rvsa10f', 'rvsa10g', 'rvsa10h', 'rvsb20a', 'rvsb20b', 'rvsb20c', 'ut000538', 'vive-a1', 'vive-a2', 'vive-a2g', 'vive-b1', 'vive-b1g', 'vive-b2', 'vive-b2g', 'vive-c1', 'vive-l1', 'wait' )];
        
        for( Floor_Plan__c Fp: FPs ) {
            List<Floor_Plan__c> OriginalFP = [SELECT Id, Property__r.Name, Account__r.Name FROM Floor_Plan__c WHERE Floorplan_ID__c = : Fp.Floorplan_ID__c AND LastModifiedDate = TODAY];
            
            if( !OriginalFP.isEmpty() && OriginalFP.size() == 1 ) {
                System.debug('Original FP "' + OriginalFP.get(0).Floorplan_ID__c + '"  is of Property "' + OriginalFP.get(0).Property__r.Name + '" for Account "' + OriginalFP.get(0).Account__r.Name + '"' );
                List<Floor_Plan__c> DuplicatesFP = [ SELECT Id FROM Floor_Plan__c WHERE Floorplan_ID__c = :Fp.Floorplan_ID__c AND Id != :OriginalFP.get(0).Id ];
                
                System.debug('DuplicatesFP - '+ DuplicatesFP);
            }
            
            
            
        }*/
        
    }
    
    global Iterable<Contact> start(Database.BatchableContext BC) {
      	
        
		psi.pullPSIAgents( isPSIGCPullAgentsScheduler );
        arrobjContacts = psi.arrobjContacts;
        
        return arrobjContacts;
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
       	upsert scope;     
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}