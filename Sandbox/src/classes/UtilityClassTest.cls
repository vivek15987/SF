@isTest(SeeAllData=true) 
public class UtilityClassTest {
    static testMethod void testUtilityClass()
    {   
        Test.startTest();
       /* List<EmailMessageWrapper> listEmailMessageWrapper = new List<EmailMessageWrapper>();
        
        String agentName = 'Surgaya Khundrakpam';
        String email = 'Email';
 		String currDate = '2014-12-01';   
 		String currTime = '4:30 PM';
		String prospectName = 'Sur Khund'; 
 		String comments = 'This is a test email';
 		String prospectId = 'Surkh';
     	
        Map<String, String> mapSubjectParams = new Map<String, String> { 
            '{!Lead_Event__c.Agent__c}' => agentName 
 		};
							 
		Map<String, String> mapBodyParams = new Map<String, String> { 
 			'{!Lead_Event__c.Type__c}' => email, 
 			'{!Lead_Event__c.Date__c}' => currDate,   
 			'{!Lead_Event__c.Time__c}' => currTime, 
 			'{!Lead_Event__c.Prospect__c}' => prospectName, 
 			'{!Lead_Event__c.Comments__c}' => comments,
 			'{!Lead_Event__c.ProspectId__c}' => prospectId
 		};
										
        listEmailMessageWrapper.add(new EmailMessageWrapper('customercare@anyonehome.com', 'devs@anyonehome.com', null, null, null, mapSubjectParams, null, mapBodyParams));
 		 
        List<Messaging.Singleemailmessage> listSingleEmailMessages = new List<Messaging.Singleemailmessage>();
  
        listSingleEmailMessages = UtilityClass.sendEmail(listEmailMessageWrapper, 'showpro_new_reminder_task'); */
         
        Test.stopTest();
    } 
}