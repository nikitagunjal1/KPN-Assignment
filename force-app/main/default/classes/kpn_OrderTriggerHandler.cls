/*
*
* Name    : kpn_OrderTriggerHandler
* Purpose : Order Object Trigger Handler.
*/

public class kpn_OrderTriggerHandler implements kpn_ITriggerHandler{
     
    //Use this variable to disable this trigger from transaction
    public static Boolean TriggerDisabled = false;
     
    //check if the trigger is disabled from transaction
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
     
    public void beforeInsert(List<sObject> newList) {
       
         String stdPriceBookId = Util.getStdPricebookId();
         for(Order order : (List<Order>)newList){   // Bulk Processing
             order.Pricebook2Id = stdPriceBookId;
         }
    }
     
    public void afterInsert(List<sObject> newList , Map<Id, sObject> newMap) {
         
    }
     
    public void beforeUpdate(List<sObject> newList, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap) {
         
    }
     
    public void afterUpdate(List<sObject> newList, Map<Id, sObject> newMap,  List<sObject> oldList, Map<Id, sObject> oldMap) {
         
    }
     
    public void beforeDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
         
    }
     
    public void afterDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
         
    }
     
    public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap) {
         
    }

}