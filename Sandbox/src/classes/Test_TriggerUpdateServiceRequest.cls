@isTest
private class Test_TriggerUpdateServiceRequest {
    static testMethod void TestUpdateServiceRequest()
    {
        Account a=new Account();
        a.Name ='Test';
        a.Phone='2130456';
        a.Type='Test Tyep';        
        insert a;

		Grouping__c g = new Grouping__c();
        g.Name = 'Group1';
        g.Account__c = a.Id;
        insert g;
        
        Contact c1=new Contact();
        c1.FirstName='Test1 Name'; 
        c1.LastName='Tst Last';
        c1.MobilePhone='21345684';
        c1.Email='sr@gmail.com';
        insert c1; 
        
        Contact c2=new Contact();
        c2.FirstName='Test2 Name'; 
        c2.LastName='Tst Last';
        c2.MobilePhone='21345684';
        c2.Email='sr1@gmail.com';
        insert c2; 
        
        Contact c3=new Contact();
        c3.FirstName='Test3 Name'; 
        c3.LastName='Tst Last';
        c3.MobilePhone='21345684';
        c3.Email='sur@gmail.com';
        insert c3; 
        
		Property__c p = new Property__c();
        p.Account__c = a.Id;
        p.Group_Membership__c = g.Id;
        insert p;
       
        MSA__c mc=new MSA__c();
        mc.Name='Test ma';
        mc.County_Number__c=decimal.valueof('456');
        mc.MSA_No__c='msan';
        mc.State__c='sss';
        insert mc;      
        
        Work_Order_Dispatch__c w= new Work_Order_Dispatch__c();
        w.Name ='Test';
        w.Account__c=a.Id;
        w.MSA__c=mc.Id;
        w.Set_As_AH_Emer_Woogie__c=false;
        insert w;       
        
        Service_Technician__c st = new Service_Technician__c();
        st.Contact__c = c1.Id;
        st.Work_Order_Dispatch__c = w.Id;
        insert st;
        
        Service_Request_Type__c srt = new Service_Request_Type__c();
        srt.Account__c = a.Id;         
        srt.Grouping__c = g.Id;
        insert srt;
        
        Service_Request1__c sr1_aa = new Service_Request1__c();       
        sr1_aa.Status__c='Initiate Emergency Dispatch';
        sr1_aa.Case_Origin__c='Email';
        sr1_aa.Emergency_Dispatch_Status__c='Not Accepted';
        sr1_aa.Emergency_Dispatch_Accepted_By__c=null;
        sr1_aa.Account_Name__c=a.Id;
        sr1_aa.Work_Order_Dispatch__c=w.Id;         
        sr1_aa.Force_Emergency__c=True;     
        sr1_aa.Service_Request_Type__c = srt.Id;
        sr1_aa.Property_of_Interest__c = p.Id;
        insert sr1_aa;
     
        Emergency_Dispatch__c ed1=new Emergency_Dispatch__c();        
        ed1.Service_Request__c= sr1_aa.id ;    
        ed1.Phone_Tree_6_Result__c = 'answered & rejected'; 
        ed1.Work_Order_Dispatch__c = w.Id;
        insert ed1;
        ed1.Phone_Tree_2_Result__c='answered & accepted';
        update ed1; 
         ed1.Phone_Tree_2_Result__c='no answer';
        update ed1;   
         ed1.Phone_Tree_2_Result__c='answered & declined';
        update ed1;
               
        Emergency_Dispatch__c ed2=new Emergency_Dispatch__c();  
        ed2.Service_Request__c= sr1_aa.id ;          
        insert ed2;
        ed2.Phone_Tree_3_Result__c='answered & accepted';
        update ed2;   
         ed2.Phone_Tree_3_Result__c='no answer';
        update ed2;
         ed2.Phone_Tree_3_Result__c='answered & declined';
        update ed2;
        
        Emergency_Dispatch__c ed3=new Emergency_Dispatch__c();     
        ed3.Service_Request__c= sr1_aa.id ;     
        insert ed3;
        ed3.Phone_Tree_4_Result__c='answered & accepted';
        update ed3;
        ed3.Phone_Tree_4_Result__c='no answer';
        update ed3;
         ed3.Phone_Tree_4_Result__c='answered & declined';
        update ed3;
                       
        Emergency_Dispatch__c ed4=new Emergency_Dispatch__c();        
        ed4.Service_Request__c= sr1_aa.id ;      
        insert ed4;
        ed4.Phone_Tree_5_Result__c='answered & accepted';
        update ed4; 
        ed4.Phone_Tree_5_Result__c='no answer';
        update ed4;
        ed4.Phone_Tree_5_Result__c='answered & declined';
        update ed4;
       
        Emergency_Dispatch__c ed5=new Emergency_Dispatch__c();        
        ed5.Service_Request__c= sr1_aa.id ;  
        insert ed5;
        ed5.Phone_Tree_6_Result__c='answered & accepted';
        update ed5;  
        ed5.Phone_Tree_6_Result__c='no answer';
        update ed5;
        ed5.Phone_Tree_6_Result__c='answered & declined';
        update ed5;
    
    }
    
   /* static testMethod void TestUpdateServiceRequest_for_no_answer()
    {
    
        Account a=new Account();
        a.Name ='Test';
        a.Phone='2130456';
        a.Type='Test Tyep';        
        insert a;

        
        Property__c p = new Property__c();
        p.Account__c = a.Id;
        insert p;
        
        MSA__c mc=new MSA__c();
        mc.Name='Test ma';
        mc.County_Number__c=decimal.valueof('456');
        mc.MSA_No__c='msan';
        mc.State__c='sss';
        insert mc; 
        
        Work_Order_Dispatch__c w= new Work_Order_Dispatch__c();
        w.Name ='Test';
        w.Account__c=a.Id;
        w.MSA__c=mc.Id;
        w.Set_As_AH_Emer_Woogie__c=false;
        insert w;  
         
        Service_Request_Type__c srt = new Service_Request_Type__c();
         srt.Account__c = a.Id;
        insert srt;
        
        Service_Request1__c sr1_na = new Service_Request1__c();       
        sr1_na.Status__c='Initiate Emergency Dispatch';
        sr1_na.Case_Origin__c='Email';
        sr1_na.Emergency_Dispatch_Status__c='Not Accepted';
        sr1_na.Emergency_Dispatch_Accepted_By__c=null; 
        sr1_na.Account_Name__c=a.Id;
        sr1_na.Work_Order_Dispatch__c=w.Id;  
        sr1_na.Force_Emergency__c=True;       
        sr1_na.Service_Request_Type__c = srt.Id;
        sr1_na.Property_of_Interest__c = p.Id;
        insert sr1_na;
               
        Emergency_Dispatch__c ed7=new Emergency_Dispatch__c();        
        ed7.Service_Request__c= sr1_na.id ;      
        insert ed7;
        ed7.Phone_Tree_1_Result__c='no answer';
        update ed7;
               
        Emergency_Dispatch__c ed8=new Emergency_Dispatch__c();        
        ed8.Service_Request__c= sr1_na.id ;     
        insert ed8;
        ed8.Phone_Tree_2_Result__c='no answer';
        update ed8;
               
        Emergency_Dispatch__c ed9=new Emergency_Dispatch__c();        
        ed9.Service_Request__c= sr1_na.id ;      
        insert ed9;
        ed9.Phone_Tree_3_Result__c='no answer';
        update ed9;
               
        Emergency_Dispatch__c ed10=new Emergency_Dispatch__c();        
        ed10.Service_Request__c= sr1_na.id ;     
        insert ed10;
        ed10.Phone_Tree_4_Result__c='no answer';
        update ed10;
                       
        Emergency_Dispatch__c ed11=new Emergency_Dispatch__c();        
        ed11.Service_Request__c= sr1_na.id ;      
        insert ed11;
        ed11.Phone_Tree_5_Result__c='no answer';
        update ed11;
               
        Emergency_Dispatch__c ed12=new Emergency_Dispatch__c();        
        ed12.Service_Request__c= sr1_na.id ;      
        insert ed12;
        ed12.Phone_Tree_6_Result__c='no answer';
        update ed12;  
    }*/
    
    /*static testMethod void TestUpdateServiceRequest_for_Not_Accepted()
    {
        Account a=new Account();
        a.Name ='Test';
        a.Phone='2130456';
        a.Type='Test Tyep';        
        insert a;
        
        Property__c p = new Property__c();
        p.Account__c = a.Id;
        insert p;
        
        MSA__c mc=new MSA__c();
        mc.Name='Test ma';
        mc.County_Number__c=decimal.valueof('456');
        mc.MSA_No__c='msan';
        mc.State__c='sss';
        insert mc; 
        
        Work_Order_Dispatch__c w= new Work_Order_Dispatch__c();
        w.Name ='Test';
        w.Account__c=a.Id;
        w.MSA__c=mc.Id;
        w.Set_As_AH_Emer_Woogie__c=false;
        insert w;  
        
        Service_Request_Type__c srt = new Service_Request_Type__c();
        srt.Account__c = a.Id;
        insert srt;
        
        Service_Request1__c sr1_ad = new Service_Request1__c();       
        sr1_ad.Status__c='Initiate Emergency Dispatch';
        sr1_ad.Case_Origin__c='Email';
        sr1_ad.Emergency_Dispatch_Status__c='Not Accepted';
        sr1_ad.Emergency_Dispatch_Accepted_By__c=null; 
        sr1_ad.Account_Name__c=a.Id;
        sr1_ad.Work_Order_Dispatch__c=w.Id;
        sr1_ad.Service_Request_Type__c = srt.Id;
        sr1_ad.Property_of_Interest__c = p.Id;
        insert sr1_ad;
               
        Emergency_Dispatch__c ed13=new Emergency_Dispatch__c();        
        ed13.Service_Request__c= sr1_ad.id ;      
        insert ed13;
        ed13.Phone_Tree_1_Result__c='answered & declined';
        update ed13;
               
        Emergency_Dispatch__c ed14=new Emergency_Dispatch__c();        
        ed14.Service_Request__c= sr1_ad.id ;      
        insert ed14;
        ed14.Phone_Tree_2_Result__c='answered & declined';
        update ed14;
                      
        Emergency_Dispatch__c ed15=new Emergency_Dispatch__c();        
        ed15.Service_Request__c= sr1_ad.id ;    
        insert ed15;
        ed15.Phone_Tree_3_Result__c='answered & declined';
        update ed15;

        Emergency_Dispatch__c ed16=new Emergency_Dispatch__c();        
        ed16.Service_Request__c= sr1_ad.id ;      
        insert ed16;
        ed16.Phone_Tree_4_Result__c='answered & declined';
        update ed16;        
               
        Emergency_Dispatch__c ed17=new Emergency_Dispatch__c();        
        ed17.Service_Request__c= sr1_ad.id ;      
        insert ed17;
        ed17.Phone_Tree_5_Result__c='answered & declined';
        update ed17; 
    }*/
}