/*
 * Class Name :kpn_OrderProductsController
 * Purpose : Referred by LWC component kpn_cartProducts
 */
public with sharing class kpn_OrderProductsController {
    /*
 	* Method Name :getOrderedProducts
	* param      :Order Id
 	* return : Returns List of OrderItem
 	*/
    @AuraEnabled
    public static List<OrderItem> getOrderedProducts(String ordrId) {
        return [SELECT Id, UnitPrice,TotalPrice,PricebookEntryId,Quantity,OrderId,Order.Status,Product2Id,Product2.Name,Product2.ProductCode  FROM OrderItem WHERE OrderId =:ordrId];
    }

     /*
 	* Method Name :upsertOrderPrducts
	* param      :Order Id
 	* return : Returns List of OrderItem
 	*/
     @AuraEnabled
     public static List<Id> upsertOrderPrducts(List<OrderItem> updatedOrdrList) {
        List<ID> orderItemIds = new List<ID>();
        if(updatedOrdrList.size()>0){           
            system.debug('updatedOrdrList--'+updatedOrdrList);
          
            try{
                // Upsert the order line items
                Database.UpsertResult [] upsertRecResult =   database.upsert(updatedOrdrList); 
                if(upsertRecResult.size() > 0){
                    for(Database.upsertResult result : upsertRecResult){
                        if(result.isSuccess()){
                            orderItemIds.add(result.getId());
                        }
                    }
                }
            } catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
        }
        return orderItemIds;
     }
 
    /*
 	* Method Name :confirmOrder
	* param      :List of OrderItem,Order Id
 	* return : Returns current Order record after Status update and Inserting OrderItems
 	*/
  
    @AuraEnabled
    public static Order confirmOrder(List<ID> orderProductIdList, String ordrId){//(List<OrderItem> updatedOrdrList,String ordrId) {
       
        system.debug('orderProductIdList--'+orderProductIdList);
        Order odr=[SELECT Id,Pricebook2.Name,Account.AccountNumber, OrderNumber, Type, Status  FROM Order where id=:ordrId];
        List<OrderItem> orderItemList = [select Id, UnitPrice,TotalPrice,Quantity,Product2Id,Product2.Name,Product2.ProductCode FROM OrderItem WHERE Id IN:orderProductIdList ];
        
        // Make a Confirm Order callout only if product IDs  are presents in the list
        system.debug('orderItemList--'+orderItemList);
        if(orderItemList.size()>0){
            HTTPResponse response =  kpn_HTTPCalloutClass.confirmOrderPostCallout(orderItemList, odr);    // future method     
              // If response is 200 that means order is confirmed in the external successfully, then update the order status to activated
            if(response.getStatusCode()==200){
                odr.Status = 'Activated';
                update odr;
            }           
        }    
        return odr;
        
    }
}