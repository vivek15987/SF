@isTest(SeeAllData=true)
class test_RetUrlSearchControllerOLD {
static testMethod void RetUrlSearchControllerOLD()
{      
      Account a = new Account();
      a.Name = 'My Name';
      a.AccountNumber = 'My Number';
     // a.Guest_Card_Email__c='test@anyonehome.com';
      insert a;
      update a;
    
        
        Property__c sche = new Property__c();
        sche.Account__c = a.id;
        //sche.Account__c = 'Accont';
        sche.Address_line_1__c = 'Address 1';
        sche.Address_line_2__c = 'Address 2';
        sche.City__c = 'New City';
        sche.Country__c = 'My Country';        
        sche.State__c = 'my Status';
        sche.bed_count__c=2;
        sche.price__c=1000;
       
                   
        insert sche;
                    
       Apexpages.StandardController stdController = new Apexpages.StandardController(sche);
      RetUrlSearchController schcls = new RetUrlSearchController();
        
      //   search_12 schcls = new search_12();
        
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery='Test';
     schcls.groQuery=' ';
     schcls.startQuery='100';
     schcls.endQuery='10000';
     schcls.startsquareQuery='10';
     schcls.endsquareQuery='200';
     schcls.startbedQuery='0';
     schcls.endbedQuery='2';

       Decimal startStr = decimal.valueOf(schcls.startQuery);
       Decimal endStr = decimal.valueOf(schcls.endQuery);
       Double startsquStr = Double.valueOf(schcls.startsquareQuery);
       Double endsquStr = Double.valueOf(schcls.endsquareQuery);
       Double startbedStr = Double.valueOf(schcls.startbedQuery);
       Double endbedStr = Double.valueOf(schcls.endbedQuery); 
        
           schcls.executeSearch();   
 //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery='Test';
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
       String accountStr1='%' + schcls.accQuery + '%';
       if (accountStr1!=NULL)
       {
       decimal startStr1 = 0;
       Decimal endStr1 = 0;
       Double startsquStr1 = 0;
       Double endsquStr1 = 0;
       Double startbedStr1 = 0;
       Double endbedStr1 = 0;
       
       schcls.executeSearch(); 
            }
          else
          {            
     schcls.nameQuery=NULL;
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=NULL;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
       String accountStr111='%' + schcls.accQuery + '%';
       decimal startStr111 = 0;
       Decimal endStr111 = 0;
       Double startsquStr111 = 0;
       Double endsquStr111 = 0;
       Double startbedStr111 = 0;
       Double endbedStr111 = 0;
           schcls.executeSearch(); 
           } 
       
    //-----------------------------------   
    
     //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery='Test';
     schcls.groQuery=' ';
     schcls.startQuery='1000';
     schcls.endQuery='';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
       String accountStr2='%' + schcls.accQuery + '%';
       Decimal startStr2 = decimal.valueOf(schcls.startQuery);
       Decimal endStr2 = 0;
       Double startsquStr2 = 0;
       Double endsquStr2 = 0;
       Double startbedStr2 = 0;
       Double endbedStr2 = 0;
            
           schcls.executeSearch();  
       
    //-----------------------------------  
    
    
         //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery='Test';
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='1000';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
      String accountStr3='%' + schcls.accQuery + '%';
      // Decimal startStr3 = decimal.valueOf(schcls.startQuery);
      decimal startStr3 = 0 ;
      Decimal endStr3 = decimal.valueOf(schcls.endQuery);
      // Decimal endStr2 = 0;
      // Double startsquStr1 = Double.valueOf(schcls.startsquareQuery);
      Double startsquStr3 = 0;
      // Double endsquStr3 = Double.valueOf(schcls.endsquareQuery);
      Double endsquStr3 = 0;
      // Double startbedStr3 = Double.valueOf(schcls.startbedQuery);
      Double startbedStr3 = 0;
      // Double endbedStr3 = Double.valueOf(schcls.endbedQuery); 
      Double endbedStr3 = 0;
            
           schcls.executeSearch();  
       
    //-----------------------------------  
    
    //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery='Test';
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='1000';
     schcls.endsquareQuery='';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
       String accountStr4='%' + schcls.accQuery + '%';
      // Decimal startStr4 = decimal.valueOf(schcls.startQuery);
      decimal startStr4 = 0 ;
      //Decimal endStr4 = decimal.valueOf(schcls.endQuery);
      Decimal endStr4 = 0;
      Double startsquStr4 = Double.valueOf(schcls.startsquareQuery);
     // Double startsquStr4 = 0;
      // Double endsquStr4 = Double.valueOf(schcls.endsquareQuery);
      Double endsquStr4 = 0;
      // Double startbedStr4 = Double.valueOf(schcls.startbedQuery);
      Double startbedStr4 = 0;
      // Double endbedStr4 = Double.valueOf(schcls.endbedQuery); 
      Double endbedStr4 = 0;
            
           schcls.executeSearch();  
       
    //-----------------------------------   
    
    //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery='Test';
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='2000';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
       String accountStr5='%' + schcls.accQuery + '%';
      // Decimal startStr5 = decimal.valueOf(schcls.startQuery);
      decimal startStr5 = 0 ;
      //Decimal endStr5 = decimal.valueOf(schcls.endQuery);
      Decimal endStr5 = 0;
      // Double startsquStr5 = Double.valueOf(schcls.startsquareQuery);
      Double startsquStr5 = 0;
      Double endsquStr5 = Double.valueOf(schcls.endsquareQuery);
     // Double endsquStr5 = 0;
      // Double startbedStr3 = Double.valueOf(schcls.startbedQuery);
      Double startbedStr5 = 0;
      // Double endbedStr3 = Double.valueOf(schcls.endbedQuery); 
      Double endbedStr5 = 0;
            
           schcls.executeSearch();  
       
    //-----------------------------------   
    
    
      //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery='Test';
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='';
     schcls.startbedQuery='2';
     schcls.endbedQuery='';
    
       String accountStr6='%' + schcls.accQuery + '%';
      // Decimal startStr5 = decimal.valueOf(schcls.startQuery);
      decimal startStr6 = 0 ;
      //Decimal endStr6 = decimal.valueOf(schcls.endQuery);
      Decimal endStr6 = 0;
      // Double startsquStr6 = Double.valueOf(schcls.startsquareQuery);
      Double startsquStr6 = 0;
     // Double endsquStr6 = Double.valueOf(schcls.endsquareQuery);
      Double endsquStr6 = 0;
      Double startbedStr6 = Double.valueOf(schcls.startbedQuery);
      //Double startbedStr5 = 0;
      // Double endbedStr3 = Double.valueOf(schcls.endbedQuery); 
      Double endbedStr6 = 0;
            
           schcls.executeSearch();  
       
    //-----------------------------------    
    
   //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery='Test';
     schcls.groQuery=' ';
     schcls.startQuery='1000';
     schcls.endQuery='2000';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
     String accountStr7='%' + schcls.accQuery + '%';
      Decimal startStr7 = decimal.valueOf(schcls.startQuery);
      //decimal startStr7 = 0 ;
      Decimal endStr7 = decimal.valueOf(schcls.endQuery);
     // Decimal endStr7 = 0;
      // Double startsquStr6 = Double.valueOf(schcls.startsquareQuery);
      Double startsquStr7 = 0;
     // Double endsquStr7 = Double.valueOf(schcls.endsquareQuery);
      Double endsquStr7 = 0;
     // Double startbedStr7 = Double.valueOf(schcls.startbedQuery);
      Double startbedStr7 = 0;
      // Double endbedStr7 = Double.valueOf(schcls.endbedQuery); 
      Double endbedStr7 = 0;
            
           schcls.executeSearch();  
       
    //----------------------------------- 
    
   
    
   //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery='Test';
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='1000';
     schcls.endsquareQuery='2000';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
      String accountStr8='%' + schcls.accQuery + '%';
      decimal startStr8 = 0 ;
      Decimal endStr8 = 0;
      Double startsquStr8 = Double.valueOf(schcls.startsquareQuery);
      Double endsquStr8 = Double.valueOf(schcls.endsquareQuery);
      Double startbedStr8 = 0;
      Double endbedStr8 = 0;
            
           schcls.executeSearch();  
       
    //----------------------------------- 
    
     //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='';
     schcls.startbedQuery='2';
     schcls.endbedQuery='3';
    
      String accountStr9='%' + schcls.accQuery + '%';
      decimal startStr9 = 0 ;
      Decimal endStr9 = 0;
      Double startsquStr9 = 0;
      Double endsquStr9 = 0;
      Double startbedStr9 = Double.valueOf(schcls.startbedQuery);
      Double endbedStr9 = Double.valueOf(schcls.endbedQuery); 
            
           schcls.executeSearch();  
       
   
     //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='1000';
     schcls.endQuery='2000';
     schcls.startsquareQuery='20';
     schcls.endsquareQuery='25';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
      String accountStr10='%' + schcls.accQuery + '%';
      decimal startStr10 =1000 ;
      Decimal endStr10 = 2000;
      Double startsquStr10 = 20;
      Double endsquStr10 = 25;
      Double startbedStr10 = 0;
      Double endbedStr10 = 0; 
            
           schcls.executeSearch(); 
        
      String accountStr20='';
      String accountStr21=NULL;
      decimal startStr20 =1000 ;
      Decimal endStr20 = 2000;
      Double startsquStr20 = 20;
      Double endsquStr20 = 25;
      Double startbedStr20 = 0;
      Double endbedStr20 = 0; 
            
           schcls.executeSearch();      
              
               //---------------------------------------  
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='1000';
     schcls.endQuery='2000';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='';
     schcls.startbedQuery='2';
     schcls.endbedQuery='3';
    
       String accountStr11='%' + schcls.accQuery + '%';
      decimal startStr11 =1000 ;
      Decimal endStr11 = 2000;
      Double startsquStr11 = 0;
      Double endsquStr11 = 0;
      Double startbedStr11 = 2;
      Double endbedStr11 = 3; 
            
           schcls.executeSearch(); 
   //---------------------------------------  
   
    schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='1000';
     schcls.endQuery='';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='';
     schcls.startbedQuery='2';
     schcls.endbedQuery='3';
    
       String accountStr13='%' + schcls.accQuery + '%';
      decimal startStr13 =1000 ;
      Decimal endStr13 =0 ;
      Double startsquStr13 = 0;
      Double endsquStr13 = 0;
      Double startbedStr13 = 2;
      Double endbedStr13 = 3; 
            
           schcls.executeSearch(); 
   //---------------------------------------  
   
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='1000';
     schcls.endsquareQuery='2000';
     schcls.startbedQuery='2';
     schcls.endbedQuery='3';
    
       String accountStr12='%' + schcls.accQuery + '%';
      decimal startStr12 =0 ;
      Decimal endStr12 =0 ;
      Double startsquStr12 = 1000;
      Double endsquStr12 = 2000;
      Double startbedStr12 = 2;
      Double endbedStr12 = 3; 
            
           schcls.executeSearch(); 
   //---------------------------------------  
   
   
   
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='1000';
     schcls.endQuery='2000';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='';
     schcls.startbedQuery='2';
     schcls.endbedQuery='';
    
       String accountStr14='%' + schcls.accQuery + '%';
      decimal startStr14 =1000 ;
      Decimal endStr14 =2000 ;
      Double startsquStr14 = 0;
      Double endsquStr14 = 0;
      Double startbedStr14 = 2;
      Double endbedStr14 = 0; 
            
           schcls.executeSearch(); 
   
   
   //--------------------------------------- 
   
   
   
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='1000';
     schcls.endQuery='';
     schcls.startsquareQuery='100';
     schcls.endsquareQuery='200';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
       String accountStr15='%' + schcls.accQuery + '%';
      decimal startStr15 =1000 ;
      Decimal endStr15 =0 ;
      Double startsquStr15 =100;
      Double endsquStr15 = 200;
      Double startbedStr15 = 0;
      Double endbedStr15 = 0; 
            
           schcls.executeSearch(); 
   //------------------------------------------------
   
   
      
   
   
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='1000';
     schcls.endQuery='2000';
     schcls.startsquareQuery='100';
     schcls.endsquareQuery='';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
       String accountStr17='%' + schcls.accQuery + '%';
      decimal startStr17 =1000 ;
      Decimal endStr17 =2000 ;
      Double startsquStr17 = 1000;
      Double endsquStr17 = 0;
      Double startbedStr17 = 0;
      Double endbedStr17 = 0; 
            
           schcls.executeSearch(); 
   
   
   //--------------------------------------- 
     
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='2000';
     schcls.startsquareQuery='1000';
     schcls.endsquareQuery='2000';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
       String accountStr16='%' + schcls.accQuery + '%';
      decimal startStr16 =0 ;
      Decimal endStr16 =2000 ;
      Double startsquStr16 = 1000;
      Double endsquStr16 = 2000;
      Double startbedStr16 = 0;
      Double endbedStr16 = 0; 
            
           schcls.executeSearch(); 
   
   
   //--------------------------------------- 
   
      //--------------------------------------- 
     
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='1000';
     schcls.endsquareQuery='';
     schcls.startbedQuery='2';
     schcls.endbedQuery='2';
    
       String accountStr22='%' + schcls.accQuery + '%';
      decimal startStr22 =0 ;
      Decimal endStr22 =0 ;
      Double startsquStr22 = 1000;
      Double endsquStr22 = 0;
      Double startbedStr22 = 2;
      Double endbedStr22 = 3; 
            
           schcls.executeSearch(); 
   
    //------------------------------------------
    
    
          //--------------------------------------- 
     
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='1000';
     schcls.startbedQuery='2';
     schcls.endbedQuery='2';
    
       String accountStr18='%' + schcls.accQuery + '%';
      decimal startStr18 =0 ;
      Decimal endStr18 =0 ;
      Double startsquStr18 = 0;
      Double endsquStr18 = 1000;
      Double startbedStr18 = 2;
      Double endbedStr18 = 3; 
            
           schcls.executeSearch(); 
   
    //------------------------------------------
    
         
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='1000';
     schcls.endQuery='';
     schcls.startsquareQuery='1000';
     schcls.endsquareQuery='';
     schcls.startbedQuery='2';
     schcls.endbedQuery='';
    
       String accountStr19='%' + schcls.accQuery + '%';
      decimal startStr19 =1000 ;
      Decimal endStr19 =0 ;
      Double startsquStr19 = 1000;
      Double endsquStr19 = 0;
      Double startbedStr19 = 2;
      Double endbedStr19 = 0; 
            
           schcls.executeSearch(); 
   
    //------------------------------------------
    
    
             
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='1000';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='1000';
     schcls.startbedQuery='';
     schcls.endbedQuery='3';
    
       String accountStr23='%' + schcls.accQuery + '%';
      decimal startStr23 =0 ;
      Decimal endStr23 =1000 ;
      Double startsquStr23 = 0;
      Double endsquStr23 = 1000;
      Double startbedStr23 = 0;
      Double endbedStr23 = 3; 
            
           schcls.executeSearch(); 
   
    //------------------------------------------
    
                 
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='1000';
     schcls.startsquareQuery='';
     schcls.endsquareQuery='1000';
     schcls.startbedQuery='';
     schcls.endbedQuery='';
    
       String accountStr24='%' + schcls.accQuery + '%';
      decimal startStr24 =0 ;
      Decimal endStr24 =1000 ;
      Double startsquStr24 = 0;
      Double endsquStr24 = 1000;
      Double startbedStr24 = 0;
      Double endbedStr24 = 0; 
            
           schcls.executeSearch(); 
   
    //------------------------------------------
    
        
                 
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='';
     schcls.startsquareQuery='1000';
     schcls.endsquareQuery='';
     schcls.startbedQuery='2';
     schcls.endbedQuery='';
    
       String accountStr25='%' + schcls.accQuery + '%';
      decimal startStr25 =0 ;
      Decimal endStr25 =0 ;
      Double startsquStr25 = 1000;
      Double endsquStr25 = 0;
      Double startbedStr25 = 2;
      Double endbedStr25 = 0; 
            
           schcls.executeSearch(); 
   
    //------------------------------------------
    
        
        
                 
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='1111';
     schcls.startsquareQuery='1000';
     schcls.endsquareQuery='10';
     schcls.startbedQuery='0';
     schcls.endbedQuery='';
    
       String accountStr26='%' + schcls.accQuery + '%';
      decimal startStr26 =0 ;
      Decimal endStr26 =1111 ;
      Double startsquStr26 = 1000;
      Double endsquStr26 = 10;
      Double startbedStr26 = 0;
      Double endbedStr26 = 0; 
            
           schcls.executeSearch(); 
   
    //------------------------------------------
    
            
                 
       schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery=' ';
     schcls.startQuery='';
     schcls.endQuery='0';
     schcls.startsquareQuery='100';
     schcls.endsquareQuery='0';
     schcls.startbedQuery='0';
     schcls.endbedQuery='10';
    
       String accountStr27='%' + schcls.accQuery + '%';
      decimal startStr27=0 ;
      Decimal endStr27=1111 ;
      Double startsquStr27 = 100;
      Double endsquStr27 = 0;
      Double startbedStr27 = 0;
      Double endbedStr27 = 10; 
            
           schcls.executeSearch(); 
   
    //------------------------------------------
    
      schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=a.name;
     schcls.groQuery='';
     schcls.startQuery='1000';
     schcls.endQuery='100000';
     schcls.startsquareQuery='100';
     schcls.endsquareQuery='1000';
     schcls.startbedQuery='10';
     schcls.endbedQuery='20';
    
       String accountStr28='%' + schcls.accQuery + '%';
      decimal startStr28=1000 ;
      Decimal endStr28=100000 ;
      Double startsquStr28 = 100;
      Double endsquStr28 = 1000;
      Double startbedStr28 = 10;
      Double endbedStr28 = 20; 
            
         //  schcls.executeSearch(); 
   
    //------------------------------------------
    
     schcls.nameQuery='Test';
     schcls.cityQuery='Detroit';
     schcls.stateQuery='MI';
     schcls.accQuery=NULL;
     schcls.groQuery='';
     schcls.startQuery='1000';
     schcls.endQuery='100000';
     schcls.startsquareQuery='100';
     schcls.endsquareQuery='1000';
     schcls.startbedQuery='10';
     schcls.endbedQuery='20';
    
      String accountStr29='%' + schcls.accQuery + '%';
      decimal startStr29=1000 ;
      Decimal endStr29=100000 ;
      Double startsquStr29 = 100;
      Double endsquStr29 = 1000;
      Double startbedStr29 = 10;
      Double endbedStr29 = 20; 
            
           schcls.executeSearch(); 
   
    //------------------------------------------
        delete sche;        
        delete a;         
    }
    }