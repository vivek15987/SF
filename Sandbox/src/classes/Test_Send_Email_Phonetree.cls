@isTest
private class Test_Send_Email_Phonetree {
static testMethod void Send_Email_Phonetree()
{ 
Account a=new Account();
a.Name='Test';
a.Phone='22222';
a.Type='Test';
insert a;

Contact c=new Contact();
c.FirstName='Test';
c.LastName='Test1';
c.AccountId=a.Id;
c.MobilePhone='222222';  
c.LeadSource='Test';       
insert c;

Service_Technician__c st=new Service_Technician__c();
st.Contact__c=c.Id;
insert st;

MSA__c mc=new MSA__c();
mc.Name='Test ma';
mc.County_Number__c=decimal.valueof('456');
mc.MSA_No__c='msan';
mc.State__c='sss';
insert mc;

Work_Order_Dispatch__c w= new Work_Order_Dispatch__c();
w.Name='Test';
w.Service_Technician__c=st.Id;
w.Phone_Tree_2__c=st.Id;
w.Phone_Tree_3__c=st.Id;
w.Phone_Tree_4__c=st.Id;
w.Phone_Tree_5__c=st.Id;
w.Phone_Tree_6__c=st.Id;
w.Account__c=a.Id;
w.MSA__c=mc.Id;
insert w;

Work_Order_Dispatch__c w1= new Work_Order_Dispatch__c();
w1.Name='Test';
w1.Account__c=a.Id;
w1.MSA__c=mc.Id;
insert w1;

Emergency_Dispatch__c ed=new Emergency_Dispatch__c(); 
ed.Work_Order_Dispatch__c=w.Id;      
ed.Phone_Tree_1_Result__c='answered & accepted'; 
ed.Phone_Tree_2_Result__c='answered & accepted';       
ed.Phone_Tree_3_Result__c='answered & accepted'; 
ed.Phone_Tree_4_Result__c='answered & accepted'; 
ed.Phone_Tree_5_Result__c='answered & accepted';  
ed.Phone_Tree_6_Result__c='answered & accepted';    
insert ed;

Emergency_Dispatch__c ed1=new Emergency_Dispatch__c(); 
ed1.Work_Order_Dispatch__c=w.Id;      
ed1.Phone_Tree_1_Result__c='answered & decline'; 
ed1.Phone_Tree_2_Result__c='answered & decline';       
ed1.Phone_Tree_3_Result__c='answered & decline'; 
ed1.Phone_Tree_4_Result__c='answered & decline'; 
ed1.Phone_Tree_5_Result__c='answered & decline';  
ed1.Phone_Tree_6_Result__c='answered & decline';    
insert ed1;

Emergency_Dispatch__c ed2=new Emergency_Dispatch__c(); 
ed2.Work_Order_Dispatch__c=w1.Id;  
insert ed2;
}
}