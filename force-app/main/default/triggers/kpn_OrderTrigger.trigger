/*
*
*Name  : kpn_OrderTrigger
*Purpose : Order trigger to assign pricebook id on creation. When we create the Order PricebookID field is empty.
*This is not writeable from the Page layout. This field will be auto populated if we add few order products to 
*the order. But if user starts with the fresh order, add some new order products from LWC and click on Comfirm Order 
*button it will fail the process as SFDC throws the error if we try to insert Order products whose order doesnt have
*PricebookId assigned to it. To avoid checking the pricebook id of the order before inserting order products
*and updating the order (with extra dml operation), before issert trigger event is used to assign pricebookid
*to the Order.
*/
trigger kpn_OrderTrigger on Order (before insert, after insert, before update, after update, before delete, after delete, after unDelete) {
    /* Apex trigger pattern used is Trigger Handler with the Interface class */
    kpn_TriggerDispatcher.run(new kpn_OrderTriggerHandler(), 'OrderTrigger');
}