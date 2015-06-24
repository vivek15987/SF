trigger pushCasetoMysql on Case (after insert) {
	Case c = trigger.new[0];
    if(!Test.isRunningTest() && false == c.Agent_Created_via_ShowPro__c && false == c.Created_by_MyShowing_com__c ) {
    	PushDataToMysql.push(JSON.serialize(c));
    }
}