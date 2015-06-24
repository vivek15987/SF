public with sharing class TestPageController {

    Public User user{get;set;}
    Public String strFileContents{get;set;}
    Private Boolean IsTrueController = true;
	Public List<User> Alluser = new List<User>();
    public List<Integer> dates = new List<Integer>();
    public List<Integer> WeekLength = new List<Integer>();
    public List<Integer> NumberOfWeek = new List<Integer>();
    public List<String> DailyReport = new List<String>();

     public TestPageController() {
         IsTrueController = false;
         user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User WHERE lastname LIKE '%Wankhade%'];
         Alluser = ( List<User> ) this.getAllUsers();
         dates = ( List<Integer> ) this.getdates();
         WeekLength = ( List<Integer> ) this.getWeekLength();
         NumberOfWeek = ( List<Integer> ) this.getNumberOfWeek();
         DailyReport = this.getFromTestClass();
    }

    public List<User> getAllUsers(){
        Set<ID> userIds = new Set<Id>();
        userIds.add( '005i00000047mP4AAI' );//Geeta
        userIds.add( '005i00000045E7cAAE' );//Rohan
        userIds.add( '005i0000004z5mXAAQ' );//swati R
        userIds.add( '005i0000005RTogAAG' );//Tejas
        userIds.add( '005i0000003Mu7JAAS' );//Surgaya
        userIds.add( '005i0000003MdF4AAK' );//Vivek
        userIds.add( '005i00000048ChUAAU' );//Tushar

        return [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User WHERE Id IN ( '005i00000047mP4AAI', '005i00000045E7cAAE', '005i0000004z5mXAAQ', '005i0000005RTogAAG', '005i0000003Mu7JAAS', '005i0000003MdF4AAK', '005i00000048ChUAAU' ) ORDER BY FirstName];
    }
       
    public List<Integer> getdates(){
        List<Integer> temp_var = new List<Integer>();
        Integer i;
        for( i=1;i<32;i++ ){
        	temp_var.add(i);   
        }
        return temp_var;
    }
    
    public List<Integer> getWeekLength(){
        Integer i;
        List<Integer> temp_var = new List<Integer>();
        for( i=1;i<8;i++ ){
            temp_var.add(i);   
        }
        return temp_var;
    }
    
    public List<Integer> getNumberOfWeek(){
        List<Integer> temp_var = new List<Integer>();
        Integer i;
        for( i=1;i<6;i++ ){
            temp_var.add(i);
        }
        return temp_var;
    }
    
    public List<String> getFromTestClass() {
        
        List<String> temp = new List<String>();
        StaticResource sr = [
            select Body
            from StaticResource
            where Name = 'TestClass'
        ];
        String fileContent = sr.Body.toString();
        for( String s:fileContent.split( ';' ) ){
         	temp.add(s);
         }
        return temp;
    }
    public void save(){
        // update user;
    }
    
    public void cancel(){
        
    }
}