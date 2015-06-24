public with sharing class TriggerFactory
{
    public static void createTriggerDispatcher(Schema.sObjectType soType)
    {
        ITriggerDispatcher dispatcher = getTriggerDispatcher(soType);
        if (dispatcher == null)
            throw new TriggerException('No Trigger dispatcher registered for Object Type: ' + soType);
        execute(dispatcher);
    }
    
    private static void execute(ITriggerDispatcher dispatcher)
    {
    	TriggerParameters tp = new TriggerParameters(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap,
									Trigger.isBefore, Trigger.isAfter, Trigger.isDelete, 
									Trigger.isInsert, Trigger.isUpdate, Trigger.isUnDelete, Trigger.isExecuting);
        // Handle before trigger events
        if (Trigger.isBefore) {
            dispatcher.bulkBefore();
            if (Trigger.isDelete)
                dispatcher.beforeDelete(tp);
            else if (Trigger.isInsert)
                dispatcher.beforeInsert(tp);
            else if (Trigger.isUpdate)
                dispatcher.beforeUpdate(tp);         
        }
        else	// Handle after trigger events
        {
            dispatcher.bulkAfter();
            if (Trigger.isDelete)
                dispatcher.afterDelete(tp);
            else if (Trigger.isInsert)
                dispatcher.afterInsert(tp);
            else if (Trigger.isUpdate)
                dispatcher.afterUpdate(tp);
        }
        dispatcher.andFinally();
    } 

    /** 
	* @description Gets the appropriate dispatcher based on the SObject. It constructs the instance of the dispatcher
	*				dynamically using the Type API. The name of the dispatcher has to follow this format:
	*				<ObjectName>TriggerDispatcher. For e.g. for the Feedback__c object, the dispatcher has to be named
	*				as FeedbackTriggerDispatcher.
	* @param Schema.sObjectType Object type to create the dispatcher
	* @return ITriggerDispatcher A trigger dispatcher  if one exists or null.
	*/
    private static ITriggerDispatcher getTriggerDispatcher(Schema.sObjectType soType)
    {
    	String originalTypeName = soType.getDescribe().getName();
    	String dispatcherTypeName = null;
    	if (originalTypeName.toLowerCase().endsWith('__c')) {
    		Integer index = originalTypeName.toLowerCase().indexOf('__c');
    		dispatcherTypeName = originalTypeName.substring(0, index) + 'TriggerDispatcher';
    	}
    	else
    		dispatcherTypeName = originalTypeName + 'TriggerDispatcher';

		Type obType = Type.forName(dispatcherTypeName);
		ITriggerDispatcher dispatcher = (obType == null) ? null : (ITriggerDispatcher)obType.newInstance();
    	return dispatcher;
    }
}