trigger updateServiceRequest on Emergency_Dispatch__c (after update) {
    Emergency_Dispatch__c c = Trigger.new[0]; 
    String svcId=c.Service_Request__c;
    String accptedBy='';   
    Service_Request1__c SRappCK=[Select Emergency_Dispatch_Accepted_By__c, Phone_tree_1_Result__c,Phone_Tree_2_Result__c, Phone_Tree_3_Result__c, Phone_Tree_4_Result__c, Phone_Tree_5_Result__c, Phone_Tree_6_Result__c from Service_Request1__c where Id=:svcId];
    String ckAcceptedBy=SRappCK.Emergency_Dispatch_Accepted_By__c;    
    String phone_result_1 = SRappCK.Phone_tree_1_Result__c; 
    String phone_result_2 = SRappCK.Phone_Tree_2_Result__c;
    String phone_result_3 = SRappCK.Phone_Tree_3_Result__c; 
    String phone_result_4 = SRappCK.Phone_Tree_4_Result__c; 
    String phone_result_5 = SRappCK.Phone_Tree_5_Result__c; 
    String phone_result_6 = SRappCK.Phone_Tree_6_Result__c; 
    boolean lastCallTreeFlag = false;
    String tempString = '';
    set<string> all_status = new set<string>{'answered & accepted', 'no answer & finalized'}; 
        if(String.isNotBlank(c.Phone_Tree_6__c ) ){
            if(String.isNotBlank(c.Phone_Tree_6_Result__c) && c.Phone_Tree_6_Result__c.toLowerCase() == 'answered & rejected'){
                lastCallTreeFlag = true; 
            }
        } else if(String.isNotBlank(c.Phone_Tree_5__c ) ){
            if(String.isNotBlank(c.Phone_Tree_5_Result__c) && c.Phone_Tree_5_Result__c.toLowerCase() == 'answered & rejected'){
                lastCallTreeFlag = true;   
            }
        }   else if( String.isNotBlank(c.Phone_Tree_4__c )) {
            if(String.isNotBlank(c.Phone_Tree_4_Result__c) && c.Phone_Tree_4_Result__c.toLowerCase() == 'answered & rejected'){
                lastCallTreeFlag = true; 
            }
        } else if(String.isNotBlank(c.Phone_Tree_3__c ) ){
            if(String.isNotBlank(c.Phone_Tree_3_Result__c) && c.Phone_Tree_3_Result__c.toLowerCase() == 'answered & rejected'){
                lastCallTreeFlag = true; 
            }
        } else if(String.isNotBlank(c.Phone_Tree_2__c ) ){
            if(String.isNotBlank(c.Phone_Tree_2_Result__c) && c.Phone_Tree_2_Result__c.toLowerCase() == 'answered & rejected'){
                lastCallTreeFlag = true; 
            }
        }   else if(String.isNotBlank(c.Phone_Tree_1__c ) ) {
            if(String.isNotBlank(c.Phone_Tree_1_Result__c) && c.Phone_Tree_1_Result__c.toLowerCase() == 'answered & rejected'){
                lastCallTreeFlag = true; 
            }    
        }
            
        if(((String.isNotBlank(c.Phone_Tree_1_Result__c) && all_status.contains(c.Phone_Tree_1_Result__c.toLowerCase()) ) || (String.isNotBlank(c.Phone_Tree_2_Result__c) && all_status.contains(c.Phone_Tree_2_Result__c.toLowerCase()) ) || (String.isNotBlank(c.Phone_Tree_3_Result__c) &&  all_status.contains(c.Phone_Tree_3_Result__c.toLowerCase()) ) || ( String.isNotBlank(c.Phone_Tree_4_Result__c) && all_status.contains(c.Phone_Tree_4_Result__c.toLowerCase()) ) || (String.isNotBlank(c.Phone_Tree_5_Result__c) && all_status.contains(c.Phone_Tree_5_Result__c.toLowerCase()) ) || (String.isNotBlank(c.Phone_Tree_6_Result__c) &&  all_status.contains(c.Phone_Tree_6_Result__c.toLowerCase())) ) || lastCallTreeFlag) {
            
            //Execute when Emergency object Phone tree result value is 'answered & accepted'
            if(String.isNotBlank(c.Phone_Tree_1_Result__c) && c.Phone_Tree_1_Result__c.toLowerCase()=='answered & accepted'  )
            {              
                Service_Request1__c sr1_aa = new Service_Request1__c();
                sr1_aa.Id=svcId;       
                sr1_aa.Status__c='Ready to Send';            
                sr1_aa.Emergency_Dispatch_Accepted_By__c=c.Phone_Tree_1__c;            
                sr1_aa.Emergency_Dispatch_Status__c='Deliver Result to Customer';
                sr1_aa.Phone_tree_1_Result__c='Accepted';
                sr1_aa.Phone_Tree_1_Notes__c=c.Phone_Tree_1_Time__c;
                if(String.isNotBlank(c.Phone_Tree_1__c )) {
                    List<Contact> conlst=[Select Id from Contact where Name=:c.Phone_Tree_1__c];  
                    sr1_aa.Service_Technician_Assigned__c=(conlst.size()>0)?conlst[0].Id:null; 
                }
                update sr1_aa;
            } else if(String.isNotBlank(c.Phone_Tree_1_Result__c) && (c.Phone_Tree_1_Result__c.toLowerCase()=='no answer & finalized' || c.Phone_Tree_1_Result__c.toLowerCase()=='no answer'))
            {        
                Service_Request1__c sr1_na = new Service_Request1__c();
                sr1_na.Id=svcId;          
                sr1_na.Phone_tree_1_Result__c='No Answer';
                sr1_na.Phone_Tree_1_Notes__c=c.Phone_Tree_1_Time__c;
                update sr1_na;       
            } else if(String.isNotBlank(c.Phone_Tree_1_Result__c) && c.Phone_Tree_1_Result__c.toLowerCase()=='answered & rejected')
            {        
                Service_Request1__c sr1_ad = new Service_Request1__c();
                sr1_ad.Id=svcId;          
                sr1_ad.Phone_tree_1_Result__c='Rejected';
                sr1_ad.Phone_Tree_1_Notes__c=c.Phone_Tree_1_Time__c;
                update sr1_ad;       
            } else if( phone_result_1 != null){
                Service_Request1__c sr1_no = new Service_Request1__c();
                sr1_no.Id=svcId;          
                sr1_no.Phone_tree_1_Result__c='';
                sr1_no.Phone_Tree_1_Notes__c=c.Phone_Tree_1_Time__c;
                update sr1_no;    
            } 
            
            if(String.isNotBlank(c.Phone_Tree_2_Result__c) && c.Phone_Tree_2_Result__c.toLowerCase()=='answered & accepted')
            {            
                Service_Request1__c sr2_aa = new Service_Request1__c();
                sr2_aa.Id=svcId;       
                sr2_aa.Status__c='Ready to Send';           
                sr2_aa.Emergency_Dispatch_Accepted_By__c=c.Phone_Tree_2__c;           
                sr2_aa.Emergency_Dispatch_Status__c='Deliver Result to Customer';
                sr2_aa.Phone_tree_2_Result__c='Accepted';
                sr2_aa.Phone_Tree_2_Notes__c=c.Phone_Tree_2_Time__c;
                if(String.isNotBlank(c.Phone_Tree_2__c )) {
                    List<Contact> conlst=[Select Id from Contact where Name=:c.Phone_Tree_2__c];  
                    sr2_aa.Service_Technician_Assigned__c=(conlst.size()>0)?conlst[0].Id:null;
                }
                update sr2_aa;
            } else if(String.isNotBlank(c.Phone_Tree_2_Result__c) && ( c.Phone_Tree_2_Result__c.toLowerCase()=='no answer & finalized' || c.Phone_Tree_2_Result__c.toLowerCase()=='no answer'))
            {
                Service_Request1__c sr2_na = new Service_Request1__c();
                sr2_na.Id=svcId; 
                sr2_na.Phone_tree_2_Result__c='No Answer';
                sr2_na.Phone_Tree_2_Notes__c=c.Phone_Tree_2_Time__c;
                update sr2_na;           
            } else if(String.isNotBlank(c.Phone_Tree_2_Result__c) && c.Phone_Tree_2_Result__c.toLowerCase()=='answered & rejected')
            {
                Service_Request1__c sr2_ad = new Service_Request1__c();
                sr2_ad.Id=svcId; 
                sr2_ad.Phone_tree_2_Result__c='Rejected';
                sr2_ad.Phone_Tree_2_Notes__c=c.Phone_Tree_2_Time__c;
                update sr2_ad;           
            } else if( phone_result_2 != null){
                Service_Request1__c sr2_no = new Service_Request1__c();
                sr2_no.Id=svcId;          
                sr2_no.Phone_tree_2_Result__c='';
                sr2_no.Phone_Tree_2_Notes__c=c.Phone_Tree_2_Time__c;
                update sr2_no;    
            } 
            
            
            
            if(String.isNotBlank(c.Phone_Tree_3_Result__c) && c.Phone_Tree_3_Result__c.toLowerCase()=='answered & accepted')
            {              
                Service_Request1__c sr3_aa = new Service_Request1__c();
                sr3_aa.Id=svcId;     
                sr3_aa.Status__c='Ready to Send';           
                sr3_aa.Emergency_Dispatch_Accepted_By__c=c.Phone_Tree_3__c;            
                sr3_aa.Emergency_Dispatch_Status__c='Deliver Result to Customer';
                sr3_aa.Phone_tree_3_Result__c='Accepted';
                sr3_aa.Phone_Tree_3_Notes__c=c.Phone_Tree_3_Time__c;
                if(String.isNotBlank(c.Phone_Tree_3__c )) {
                    List<Contact> conlst=[Select Id from Contact where Name=:c.Phone_Tree_3__c]; 
                    sr3_aa.Service_Technician_Assigned__c=(conlst.size()>0)?conlst[0].Id:null;
                } 
                update sr3_aa;
            } else if(String.isNotBlank(c.Phone_Tree_3_Result__c) && (c.Phone_Tree_3_Result__c.toLowerCase()=='no answer & finalized' || c.Phone_Tree_3_Result__c.toLowerCase()=='no answer'))
            {
                Service_Request1__c sr3_na = new Service_Request1__c();
                sr3_na.Id=svcId;          
                sr3_na.Phone_tree_3_Result__c='No Answer';
                sr3_na.Phone_Tree_3_Notes__c=c.Phone_Tree_3_Time__c;
                update sr3_na;            
            }  else if(String.isNotBlank(c.Phone_Tree_3_Result__c) && c.Phone_Tree_3_Result__c.toLowerCase()=='answered & rejected')
            {
                Service_Request1__c sr3_ad = new Service_Request1__c();
                sr3_ad.Id=svcId;          
                sr3_ad.Phone_tree_3_Result__c='Rejected';
                sr3_ad.Phone_Tree_3_Notes__c=c.Phone_Tree_3_Time__c;
                update sr3_ad;            
            } else if( phone_result_3 != null){
                Service_Request1__c sr3_no = new Service_Request1__c();
                sr3_no.Id=svcId;          
                sr3_no.Phone_tree_3_Result__c='';
                sr3_no.Phone_Tree_3_Notes__c=c.Phone_Tree_3_Time__c;
                update sr3_no;    
            } 
            
            
            
            
            if(String.isNotBlank(c.Phone_Tree_4_Result__c) && c.Phone_Tree_4_Result__c.toLowerCase()=='answered & accepted')
            {            
                Service_Request1__c sr4_aa = new Service_Request1__c();
                sr4_aa.Id=svcId;        
                sr4_aa.Status__c='Ready to Send';           
                sr4_aa.Emergency_Dispatch_Accepted_By__c=c.Phone_Tree_4__c;            
                sr4_aa.Emergency_Dispatch_Status__c='Deliver Result to Customer';
                sr4_aa.Phone_tree_4_Result__c='Accepted';
                sr4_aa.Phone_Tree_4_Notes__c=c.Phone_Tree_4_Time__c; 
                if(String.isNotBlank(c.Phone_Tree_4__c )) {
                    List<Contact> conlst=[Select Id from Contact where Name=:c.Phone_Tree_4__c];   
                    sr4_aa.Service_Technician_Assigned__c=(conlst.size()>0)?conlst[0].Id:null;
                }
                update sr4_aa;           
            } else if(String.isNotBlank(c.Phone_Tree_4_Result__c) && (c.Phone_Tree_4_Result__c.toLowerCase()=='no answer & finalized' || c.Phone_Tree_4_Result__c.toLowerCase()=='no answer'))
            {
                Service_Request1__c sr4_na = new Service_Request1__c();
                sr4_na.Id=svcId;            
                sr4_na.Phone_tree_4_Result__c='No Answer';
                sr4_na.Phone_Tree_4_Notes__c=c.Phone_Tree_4_Time__c;
                update sr4_na;           
            } else if(String.isNotBlank(c.Phone_Tree_4_Result__c) && c.Phone_Tree_4_Result__c.toLowerCase()=='answered & rejected')
            {
                Service_Request1__c sr4_ad = new Service_Request1__c();
                sr4_ad.Id=svcId;            
                sr4_ad.Phone_tree_4_Result__c='Rejected';
                sr4_ad.Phone_Tree_4_Notes__c=c.Phone_Tree_4_Time__c;
                update sr4_ad;           
            } else if( phone_result_4 != null){
                Service_Request1__c sr4_no = new Service_Request1__c();
                sr4_no.Id=svcId;          
                sr4_no.Phone_tree_4_Result__c='';
                sr4_no.Phone_Tree_4_Notes__c=c.Phone_Tree_4_Time__c;
                update sr4_no;    
            }  
            
            
            if(String.isNotBlank(c.Phone_Tree_5_Result__c) && c.Phone_Tree_5_Result__c.toLowerCase()=='answered & accepted')
            { 
                Service_Request1__c sr5_aa = new Service_Request1__c();
                sr5_aa.Id=svcId;        
                sr5_aa.Status__c='Ready to Send';           
                sr5_aa.Emergency_Dispatch_Accepted_By__c=c.Phone_Tree_5__c;            
                sr5_aa.Emergency_Dispatch_Status__c='Deliver Result to Customer';
                sr5_aa.Phone_tree_5_Result__c='Accepted';
                sr5_aa.Phone_Tree_5_Notes__c=c.Phone_Tree_5_Time__c;
                if(String.isNotBlank(c.Phone_Tree_5__c )) {
                    List<Contact> conlst=[Select Id from Contact where Name=:c.Phone_Tree_5__c];  
                    sr5_aa.Service_Technician_Assigned__c=(conlst.size()>0)?conlst[0].Id:null;
                }
                update sr5_aa;           
            } else if(String.isNotBlank(c.Phone_Tree_5_Result__c) && (c.Phone_Tree_5_Result__c.toLowerCase()=='no answer & finalized' || c.Phone_Tree_5_Result__c.toLowerCase()=='no answer'))
            {
                Service_Request1__c sr5_na = new Service_Request1__c();
                sr5_na.Id=svcId;       
                sr5_na.Phone_tree_5_Result__c='No Answer';
                sr5_na.Phone_Tree_5_Notes__c=c.Phone_Tree_5_Time__c;
                update sr5_na;           
            } else if(String.isNotBlank(c.Phone_Tree_5_Result__c) && c.Phone_Tree_5_Result__c.toLowerCase()=='answered & rejected')
            {
                Service_Request1__c sr5_ad = new Service_Request1__c();
                sr5_ad.Id=svcId;       
                sr5_ad.Phone_tree_5_Result__c='Rejected';
                sr5_ad.Phone_Tree_5_Notes__c=c.Phone_Tree_5_Time__c;
                update sr5_ad;           
            } else if( phone_result_5 != null){
                Service_Request1__c sr5_no = new Service_Request1__c();
                sr5_no.Id=svcId;          
                sr5_no.Phone_tree_5_Result__c='';
                sr5_no.Phone_Tree_5_Notes__c=c.Phone_Tree_5_Time__c;
                update sr5_no;    
            } 
            
            
            
            if(String.isNotBlank(c.Phone_Tree_6_Result__c) && c.Phone_Tree_6_Result__c.toLowerCase()=='answered & accepted')
            {            
                Service_Request1__c sr6_aa = new Service_Request1__c();
                sr6_aa.Id=svcId;      
                sr6_aa.Status__c='Ready to Send';           
                sr6_aa.Emergency_Dispatch_Accepted_By__c=c.Phone_Tree_6__c;            
                sr6_aa.Emergency_Dispatch_Status__c='Deliver Result to Customer';
                sr6_aa.Phone_tree_6_Result__c='Accepted';
                sr6_aa.Phone_Tree_6_Notes__c=c.Phone_Tree_6_Time__c;
                if(String.isNotBlank(c.Phone_Tree_6__c )) { 
                    List<Contact> conlst=[Select Id from Contact where Name=:c.Phone_Tree_6__c];   
                    sr6_aa.Service_Technician_Assigned__c=(conlst.size()>0)?conlst[0].Id:null;
                }
                update sr6_aa;          
            } else if(String.isNotBlank(c.Phone_Tree_6_Result__c) && ( c.Phone_Tree_6_Result__c.toLowerCase()=='no answer & finalized' || c.Phone_Tree_6_Result__c.toLowerCase()=='no answer'))
            {
                Service_Request1__c sr6_na = new Service_Request1__c();
                sr6_na.Id=svcId;          
                sr6_na.Phone_tree_6_Result__c='No Answer';
                sr6_na.Phone_Tree_6_Notes__c=c.Phone_Tree_6_Time__c;
                update sr6_na;
            } else if(String.isNotBlank(c.Phone_Tree_6_Result__c) && c.Phone_Tree_6_Result__c.toLowerCase()=='answered & rejected')
            {
                Service_Request1__c sr6_ad = new Service_Request1__c();
                sr6_ad.Id=svcId;          
                sr6_ad.Phone_tree_6_Result__c='Rejected';
                sr6_ad.Phone_Tree_6_Notes__c=c.Phone_Tree_6_Time__c;
                update sr6_ad;
            } else if( phone_result_6 != null){
                Service_Request1__c sr6_no = new Service_Request1__c();
                sr6_no.Id=svcId;          
                sr6_no.Phone_tree_6_Result__c='';
                sr6_no.Phone_Tree_6_Notes__c=c.Phone_Tree_6_Time__c;
                update sr6_no;    
            } 
            
        } 
}