trigger pushServiceRequesttoMysql on Service_Request1__c (after insert) {
	Service_Request1__c s = trigger.new[0];
    if(!Test.isRunningTest() && false == s.Created_by_ShowPro_User__c ) {
    	PushDataToMysql.push(JSON.serialize(s));
    }
}