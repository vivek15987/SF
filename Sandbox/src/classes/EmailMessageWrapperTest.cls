@isTest
public class EmailMessageWrapperTest {
    static testMethod void testEmailWrapper()
    {
        Map<String, String>  mapSubjectParams = new   Map<String, String>();
        Map<String, String> mapBodyParams = new  Map<String, String>();
        Id testId;
        EmailMessageWrapper wrapper = new EmailMessageWrapper( 'test@anyonehome.com','mahek.joshipura@anyonehome.com',testId,'vivek.shah@anyonehome.com','test',mapSubjectParams,'',mapBodyParams );
    
    }

}