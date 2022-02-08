/*
* Name    : kpn_TriggerDispatcher
* Purpose : Trigger Dispatcher.
*/
public class kpn_TriggerDispatcher {
     
    /*
    * Description : It will invoke the appropriate methods on the handler depending on the trigger context.
    * Parameters : ITriggerHandler handler
    */
    public static void run(kpn_ITriggerHandler handler, string triggerName){
         
        //Check if the trigger is disabled
        if (handler.IsDisabled()){
            return;
        }
         
        
        /* I have used custom metadata instead of LISt type custom setting as LIST type
        setting is deprecated. And advantage with metadata is that its records can be deployed
        with the code and no extra post deployment step is needed to create data.
        */

        //Get the trigger active information from custom settings by trigger name
        Boolean isActive = kpn_TriggerSetting__mdt.getInstance(triggerName).kpn_isActive__c;
        system.debug('isActive--'+isActive);

         
        if(isActive){ 
            //Check trigger context from trigger operation type
            switch on Trigger.operationType {
                 
                when BEFORE_INSERT {
                    //Invoke before insert trigger handler
                    handler.beforeInsert(trigger.new);
                }
                when AFTER_INSERT {
                    //Invoke after insert trigger handler
                    handler.afterInsert(trigger.new, trigger.newMap);
                }
                when BEFORE_UPDATE {
                    //Invoke before update trigger handler
                    handler.beforeUpdate(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
                }
                when AFTER_UPDATE {
                    //Invoke after update trigger handler
                    handler.afterUpdate(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
                }
                when BEFORE_DELETE {
                    //Invoke before delete trigger handler
                    handler.beforeDelete(trigger.old, trigger.oldMap);
                }
                when AFTER_DELETE {
                    //Invoke after delete trigger handler
                    handler.afterDelete(trigger.old, trigger.oldMap);
                }
                when AFTER_UNDELETE {
                    //Invoke after undelete trigger handler
                    handler.afterUnDelete(trigger.new, trigger.newMap);
                }
            }
        }
    }
}