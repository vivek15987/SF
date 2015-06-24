public class RetUrlSearchController 
{
public String nameQuery {get; set;}
public String cityQuery {get; set;}
public String stateQuery {get; set;}
//public String countryQuery {get; set;}
public String accQuery {get; set;}
public String groQuery {get; set;}
public String startQuery {get; set;}
public String endQuery {get; set;}
public String startsquareQuery {get; set;}
public String endsquareQuery {get; set;}
public String startbedQuery {get; set;}
public String endbedQuery {get; set;}
public List<Property__c> accounts {get; set;}
 public PageReference executeSearch()
 { 
  String queryStr='%' + nameQuery + '%';
  String cityStr='%' + cityQuery + '%';
  String stateStr='%' + stateQuery + '%';
  //String countryStr='%' + countryQuery + '%';
  String accountStr='%' + accQuery + '%';
  String groupStr='%' + groQuery + '%';
  
   if(startQuery.length() < 1)  
  {  
  startQuery='0';
  }
  if(endQuery.length() < 1)
  {
  endQuery='0';  
  }
  if(startsquareQuery.length()<1)
  {
  startsquareQuery='0';
  }
  if(endsquareQuery.length()<1)
  {
  endsquareQuery='0';
  }
  if(startbedQuery.length()<1)
  {
  startbedQuery='0';
  }
  if(endbedQuery.length()<1)
  {
  endbedQuery='0';
  }
  Decimal startStr = decimal.valueOf(startQuery);
  Decimal endStr = decimal.valueOf(endQuery);
  Double startsquStr = Double.valueOf(startsquareQuery);
  Double endsquStr = Double.valueOf(endsquareQuery);
  Double startbedStr = Double.valueOf(startbedQuery);
  Double endbedStr = Double.valueOf(endbedQuery); 
  //Id accountStr=Id.valueOf(accQuery);
 // Id groupStr=Id.valueOf(groQuery);
 
     if((startStr< 1) && (endStr < 1) && (startsquStr< 1) && (endsquStr < 1) && (startbedStr< 1) && (endbedStr < 1))
     {     
      accounts = [Select Id,Name,Address_line_1__c,Account1__c,Account__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
       WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr and State__c like :stateStr and Active__c !='No'];            
      return null;
     }     
      
     //all six field//     
     else if((startStr>0) && (endStr >0) && (startsquStr>0) && (endsquStr >0) && (startbedStr > 0) && (endbedStr > 0))
     { 
       if(accountStr !=null && accountStr !='')
       {
       accounts = [Select Id,Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
       WHERE Account1__c like:accountStr and Price__c >=:startStr and Price__c <=:endStr and Square_Footage__c >=:startsquStr and Square_Footage__c <=:endsquStr 
       and Bed_Count__c >=:startbedStr and Bed_Count__c <=:endbedStr and Active__c !='No'];
        return null;    
       }
       else{  
      accounts = [Select Id,Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
       WHERE Price__c >=:startStr and Price__c <=:endStr and Square_Footage__c >=:startsquStr and Square_Footage__c <=:endsquStr 
       and Bed_Count__c >=:startbedStr and Bed_Count__c <=:endbedStr and Active__c !='No'];            
      return null;
       }
     }
     /////////////////////////
     
       //all four//       
     else if(startStr >0 && endStr >0 && startsquStr >0 && endsquStr >0)
     {
     if(accountStr !=null && accountStr !='' )
     {  
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Price__c >=:startStr and Price__c <=:endStr and Square_Footage__c >=:startsquStr and Square_Footage__c <=:endsquStr and Active__c !='No' order by Name];            
     return null;   
     } 
     else
     {    
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Price__c >=:startStr and Price__c <=:endStr and Square_Footage__c >=:startsquStr and Square_Footage__c <=:endsquStr and Active__c !='No' order by Name];            
     return null;
     }
     } 
        
     else if(startsquStr >0 && endsquStr >0 && startbedStr >0 && endbedStr >0)
     {
     if(accountStr !=null && accountStr !='' )
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Square_Footage__c >=:startsquStr and Square_Footage__c <=:endsquStr and Bed_Count__c >=:startbedStr and Bed_Count__c <=:endbedStr and Active__c !='No' order by Name];            
     return null;
     }
     else
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Square_Footage__c >=:startsquStr and Square_Footage__c <=:endsquStr and Bed_Count__c >=:startbedStr and Bed_Count__c <=:endbedStr and Active__c !='No' order by Name];            
     return null;
     }
     }
     ////////////////////
     
       //price with bed//  
     else if(startStr >0 && endStr>0 && startbedStr >0 && endbedStr >0)
     { 
     if(accountStr !=null && accountStr !='' )
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Price__c >=:startStr and Bed_Count__c >=:startbedStr and Bed_Count__c <=:endbedStr and Price__c <=:endStr and Active__c !='No' order by Name];            
     return null;
     }
     else
     {  
      accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Price__c >=:startStr and Bed_Count__c >=:startbedStr and Bed_Count__c <=:endbedStr and Price__c <=:endStr and Active__c !='No' order by Name];            
      return null;
     }
     }  
     
     else if(startStr >0 && startbedStr >0 && endbedStr >0 )
     { 
     if(accountStr !=null && accountStr !='' )
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Price__c >=:startStr and Bed_Count__c >=:startbedStr and Bed_Count__c <=:endbedStr and Active__c !='No' order by Name];            
     return null;
     }
     else
     {  
      accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Price__c >=:startStr and Bed_Count__c >=:startbedStr and Bed_Count__c <=:endbedStr and Active__c !='No' order by Name];            
      return null;
     }
     } 
     
     else if(startStr >0 && endStr>0 && startbedStr >0)
     {
     if(accountStr !=null && accountStr !='' )
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Price__c >=:startStr and Bed_Count__c >=:startbedStr and Price__c <=:endStr and Active__c !='No' order by Name];            
      return null;
     }
     else
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Price__c >=:startStr and Bed_Count__c >=:startbedStr and Price__c <=:endStr and Active__c !='No' order by Name];            
      return null;
     }
     }
     
        //////////////////////   
     //all three field//
     else if(startStr >0 && startsquStr >0 && endsquStr >0)
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr 
      and State__c like :stateStr and Price__c >=:startStr and Square_Footage__c >=:startsquStr and Square_Footage__c <=:endsquStr and Active__c !='No' order by Name];            
      return null;
     }
 else if(startStr >0 && endStr >0 && startsquStr >0)
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr 
      and State__c like :stateStr and Price__c >=:startStr and Square_Footage__c >=:startsquStr and Price__c <=:endStr and Active__c !='No' order by Name];            
      return null;
     }
     else if(endStr >0 && startsquStr >0 && endsquStr >0)
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr 
      and State__c like :stateStr and Price__c <=:endStr and Square_Footage__c >=:startsquStr and Square_Footage__c <=:endsquStr and Active__c !='No' order by Name];            
      return null;
     }
     else if(startsquStr >0 && startbedStr >0 && endbedStr >0)
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr 
      and State__c like :stateStr and Square_Footage__c >=:startsquStr and Bed_Count__c >=:startbedStr and Bed_Count__c <=:endbedStr and Active__c !='No' order by Name];            
      return null;
     }
     else if(endsquStr >0 && startbedStr >0 && endbedStr >0)
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr 
      and State__c like :stateStr and Square_Footage__c <=:endsquStr and Bed_Count__c >=:startbedStr and Bed_Count__c <=:endbedStr and Active__c !='No' order by Name];            
      return null;
     }
     
     else if(startStr >0 && startsquStr>0 && startbedStr >0)
     {
     if(accountStr !=null && accountStr !='' )
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Price__c >=:startStr and Bed_Count__c >=:startbedStr and Square_Footage__c >=:startsquStr and Active__c !='No' order by Name];            
     return null;
     }
     else
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Price__c >=:startStr and Bed_Count__c >=:startbedStr and Square_Footage__c >=:startsquStr and Active__c !='No' order by Name];            
     return null;
     }
     }
     
     else if(endStr >0 && endsquStr>0 && endbedStr >0)
     {
     if(accountStr !=null && accountStr !='' )
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Price__c <=:endStr and Bed_Count__c <=:endbedStr and Square_Footage__c <=:endsquStr and Active__c !='No' order by Name];            
      return null;
     }
     else
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Price__c <=:endStr and Bed_Count__c <=:endbedStr and Square_Footage__c <=:endsquStr and Active__c !='No' order by Name];            
      return null;
     }
     }
      ///////////////////////////////
   
     else if(startStr >0 && endStr < 1 || startStr >0 && startsquStr >0 )
     {   
      accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr 
      and State__c like :stateStr and Price__c >=:startStr and Square_Footage__c >=:startsquStr and Active__c !='No' order by Name];            
      return null;
     }    
     else if(startStr <1 && endStr >0 || endStr >0 && startsquStr >0)
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr
     and State__c like :stateStr and Price__c <=:endStr and Square_Footage__c >=:startsquStr and Active__c !='No' order by Name];            
     return null;
     }
     
     else if(endStr >0 && endsquStr > 0)
     {
     if(accountStr !=null && accountStr !='' )
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Price__c <=:endStr and Square_Footage__c <=:endsquStr and Active__c !='No' order by Name];            
     return null;
     }
     else
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Price__c <=:endStr and Square_Footage__c <=:endsquStr and Active__c !='No' order by Name];            
     return null;
     }
     }
     
    //square with bed//
     else if(startsquStr >0 && startbedStr >0)
     { 
     if(accountStr !=null && accountStr !='' )
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Square_Footage__c >=:startsquStr and Bed_Count__c >=:startbedStr and Active__c !='No' order by Name];            
      return null;
     }
     else
     {  
      accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Square_Footage__c >=:startsquStr and Bed_Count__c >=:startbedStr and Active__c !='No' order by Name];            
      return null;
     }
     } 
     
     else if(startsquStr >0 && endbedStr >0)
     {  
     if(accountStr !=null && accountStr !='' )
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Square_Footage__c >=:startsquStr and Bed_Count__c <=:endbedStr and Active__c !='No' order by Name];            
      return null;
     }
     else
     { 
      accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Square_Footage__c >=:startsquStr and Bed_Count__c <=:endbedStr and Active__c !='No' order by Name];            
      return null;
     } 
     }
     /////////////// 
    
     else if(startStr>0 && endStr>0)
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr
     and State__c like :stateStr and Price__c <=:endStr and Price__c >=:startStr and Active__c !='No' order by Name];            
     return null;
     }
       //Square Footage//
     else if(startsquStr >0 && endsquStr < 1)
     {
      accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr 
      and State__c like :stateStr and Square_Footage__c >=:startsquStr and Active__c !='No' order by Name];            
      return null;
     }  
     else if(startsquStr<1 && endsquStr > 0)
     {
      accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr 
      and State__c like :stateStr and Square_Footage__c <=:endsquStr and Active__c !='No' order by Name];            
      return null;
     }
     else if((startsquStr>=1) && (endsquStr>=1))
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr
     and State__c like :stateStr and Square_Footage__c  <=:endsquStr and Square_Footage__c >=:startsquStr and Active__c !='No' order by Name];            
     return null;
     }
     //Bed Count//
     else if(startbedStr > 0 && endbedStr < 1)
     {
      accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr 
      and State__c like :stateStr and Bed_Count__c >=:startbedStr and Active__c !='No' order by Name];            
      return null;
     }
     else if(startbedStr < 1 && endbedStr > 0)
     {
      accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
      WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr 
      and State__c like :stateStr and Bed_Count__c <=:endbedStr and Active__c !='No' order by Name];            
      return null;
       
     }
     else if((startbedStr>=1) && (endbedStr>=1))
     {
     accounts = [Select Id, Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr
     and State__c like :stateStr and Bed_Count__c <=:endbedStr and Bed_Count__c >=:startbedStr and Active__c !='No' order by Name];            
     return null;
     }
     
     else
     {
     accounts = [Select Id,Name,Address_line_1__c,Account1__c,Group_Membership__c,Group_Membership1__c,City__c,Country__c,Price__c,State__c,Square_Footage__c ,Bed_Count__c,Active__c FROM Property__c
     WHERE Account1__c like:accountStr and Group_Membership1__c like:groupStr and Address_line_1__c like:queryStr and City__c like :citystr and State__c like :stateStr
     and Price__c <=:endStr and Price__c >=:startStr and Square_Footage__c <=:endsquStr and Square_Footage__c >=:startsquStr and Bed_Count__c <=:endbedStr
     and Bed_Count__c >=:startbedStr and Active__c !='No' order by Name];            
     return null;
      }      
     
    }
    
  
 public RetUrlSearchController()
 {
 
  String accountname=ApexPages.currentPage().getParameters().get('aid'); 
  String propertyname=ApexPages.currentPage().getParameters().get('cpn');   
 String  sourceaccount=ApexPages.currentPage().getParameters().get('csa');     
  //if(null != accountname)
  //{
  //accQuery= accountname;
  //}
if( propertyname==null || propertyname=='')
{
accQuery=sourceaccount;
}
else
{
accQuery= accountname;
}
  String urlQuery=ApexPages.currentPage().getParameters().get('query'); 
  if ( (null != urlQuery) && (0!=urlQuery.length()) )
  {  
   nameQuery=urlQuery;   
   executeSearch();
  }
 }
}