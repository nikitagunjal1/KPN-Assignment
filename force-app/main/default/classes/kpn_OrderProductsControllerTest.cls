/*
 * Class Name :kpn_OrderProductsControllerTest
 * Purpose : Test class for kpn_OrderProductsController
*/
@isTest
public with sharing class kpn_OrderProductsControllerTest {
      /*
 	* Method Name :setup
	* param      :
 	* return : test data setup method
 	*/
     @testSetup static void setup() {
        
        // Create Account
        Account acc = Util.createAccount();
    
        //Create Contract
        Contract ct = Util.createContract(acc.id);
        
        //Activate Contract
        Util.activateContract(ct);
    
        // Create Product
        Product2 prod = Util.createProduct('test product 1','prod1', 'this is test product');
        
        // Get standard price book id
        Id pricebookId = Test.getStandardPricebookId();
        system.debug('pricebookId---->'+pricebookId);
        
        // Create PricebookEntry    
        PricebookEntry standardPrice = Util.createPricebookEntry(pricebookId,prod.id, 2000);
        
        // Create Order        
        Order odr = Util.createOrder(acc.id,ct.id);
    
        // Create Order Item
    	Util.createOrderItem(standardPrice.id,odr.id,prod.id,10,200);        
    }
     /*
 	* Method Name :testOrderProductMethod1
	* param      :
 	* return : testmethod to test getOrderedProducts method
 	*/
    public static testMethod void getOrderedProductsTest(){
        
        Order odr =[Select id from Order];
        System.Test.startTest();
        List<OrderItem> ordrItemLst=kpn_OrderProductsController.getOrderedProducts(odr.Id);
        System.assert(ordrItemLst.size()>0,'OrderItem List should not be null');
        System.Test.stopTest();
        
       
	} 
    /*
 	* Method Name :upsertOrderPrductsTest
	* param      :
 	* return : testmethod to test upsertOrderPrducts method
 	*/
    public static testMethod void upsertOrderPrductsTest(){
        
		Order odr =[Select id from Order limit 1 ];
        List<OrderItem> ordrItemLst=[SELECT Id, UnitPrice, Quantity, OrderId,Order.Status,Product2Id,Product2.Name  FROM OrderItem where OrderId =:odr.id];
        Test.setMock(HttpCalloutMock.class, new kpn_HTTPCalloutMockClass());  
        System.Test.startTest();
        List<Id> orderItemIds = kpn_OrderProductsController.upsertOrderPrducts(ordrItemLst);
        System.assert(orderItemIds.size()>0,'Order Item List Canot be Empty');
       
        System.Test.stopTest();
	}    
    

    /*
 	* Method Name :confirmOrderTest
	* param      :
 	* return : testmethod to test confirmOrder method
 	*/
     public static testMethod void confirmOrderTest(){
        
		Order odr =[Select id from Order limit 1 ];
        List<Id> orderItemIds= new List<Id>();
        for(OrderItem OI: [SELECT Id FROM OrderItem where OrderId =:odr.id]){
            orderItemIds.add(OI.Id);
        }
        Test.setMock(HttpCalloutMock.class, new kpn_HTTPCalloutMockClass());  
        System.Test.startTest();
        Order order = kpn_OrderProductsController.confirmOrder(orderItemIds,odr.Id);
        System.assert(order.Status == 'Activated','Order is not confirmed in the external system');
        System.Test.stopTest();
	} 
}