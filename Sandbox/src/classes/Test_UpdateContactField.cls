@isTest
private class Test_UpdateContactField {
     static testMethod void MyUnitTestCon()
     {  
         Account a=new Account();
         a.Name ='Test';
         a.Phone='2130456';
         a.Type='Test Tyep';
         insert a;
         
         Contact c=new Contact();
         c.FirstName='Test Name'; 
         c.LastName='Tst Last';
         c.MobilePhone='21345684';
         c.Email='manish@gmail.com';
         insert c; 
         
         Source__c src = new Source__c(); 
         src.Account__c = a.Id;
         insert src;
         
         Case cc=new Case(); 
         cc.Status='Test Sta';
         cc.ContactId=c.Id;
         cc.Ad_Source2__c = src.Id;
         insert cc;
         
         Contact c1=new Contact();
         c1.FirstName='Test Name'; 
         c1.LastName='as';
         c1.MobilePhone='';
         c1.Email='';
         insert c1;
         
         Case cc1=new Case(); 
         cc1.Status='Test Sta';
         cc1.Correct_First_Name__c='Test First';
         cc1.ContactId=c1.Id;
         cc1.Ad_Source2__c = src.Id;
         insert cc1;
         
         Contact c2=new Contact();
         c2.FirstName=''; 
         c2.LastName='as';
         c2.MobilePhone='';
         c2.Email='';
         insert c2;
         
         Case cc2=new Case(); 
         cc2.Status='Test Sta';
         cc2.Corrected_Last_Name__c='Test First';
         cc2.ContactId=c2.Id;
         cc2.Ad_Source2__c =  src.Id;
         insert cc2;
         
         Contact c3=new Contact();
         c3.FirstName=''; 
         c3.LastName='as';
         c3.MobilePhone='123456789';
         c3.Email='';
         insert c3;
         
         Case cc3=new Case(); 
         cc3.Status='Test Sta';
         cc3.Corrected_Alt_Phone__c='123456789';
         cc3.ContactId=c3.Id;
         cc3.Ad_Source2__c =  src.Id;
         insert cc3;
         
         Contact c4=new Contact();
         c4.FirstName=''; 
         c4.LastName='as';
         c4.MobilePhone='';
         c4.Email='manish123@gmail.com';
         insert c4;
        
         Case cc4=new Case(); 
         cc4.Status='Test Sta';
         cc4.Corrected_Email__c='manish123@gmail.com';
         cc4.ContactId=c4.Id;
         cc4.Ad_Source2__c =  src.Id;
         insert cc4;
         
          
         Case cc5=new Case(); 
         cc5.Status='Test Sta';
         cc5.Corrected_Email__c='manish123@gmail.com';
         cc5.ContactId=c4.Id;
         cc5.Ad_Source2__c =  src.Id;
         insert cc5;
         
         Case cc6=new Case(); 
         cc6.Status='Test Sta';
         cc6.Corrected_Email__c='manish123@gmail.com';
         cc6.ContactId=c4.Id;
         cc6.Ad_Source2__c =  src.Id;
         insert cc6;
         
         Case cc7=new Case(); 
         cc7.Status='Test Sta';
         cc7.Corrected_Email__c='manish123@gmail.com';
         cc7.ContactId=c4.Id;
         cc7.Ad_Source2__c =  src.Id;
         insert cc7;
         
         Case cc8=new Case(); 
         cc8.Status='Test Sta';
         cc8.Corrected_Email__c='manish123@gmail.com';
         cc8.ContactId=c4.Id;
         cc8.Ad_Source2__c =  src.Id;
         insert cc8;
         
         Case cc9=new Case(); 
         cc9.Status='Test Sta';
         cc9.Corrected_Email__c='manish123@gmail.com';
         cc9.ContactId=c4.Id;
         cc9.Ad_Source2__c =  src.Id;
         insert cc9;
         
         Case cc10=new Case(); 
         cc10.Status='Test Sta';
         cc10.Corrected_Email__c='manish123@gmail.com';
         cc10.ContactId=c4.Id;
         cc10.Ad_Source2__c =  src.Id;
         insert cc10;
         
         Case cc11=new Case(); 
         cc11.Status='Test Sta';
         cc11.Corrected_Email__c='manish123@gmail.com';
         cc11.ContactId=c4.Id;
         cc11.Ad_Source2__c =  src.Id;
         insert cc11;
         
         Test.startTest();
         String name = c.FirstName + ' ' + c.LastName; 
         SendContactCaseEmail.SendNotificationEmail( c.Id , name);
         Test.stopTest();
     }
}