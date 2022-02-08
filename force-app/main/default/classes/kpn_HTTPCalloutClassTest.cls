/*
 * Class Name :kpn_HTTPCalloutClassTest
 * Purpose : Test class for kpn_HTTPCalloutClass
*/
@isTest
public with sharing class kpn_HTTPCalloutClassTest {
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
    
    static testMethod void testPostCallout() {
        Test.setMock(HttpCalloutMock.class, new kpn_HTTPCalloutMockClass());  
        Order odr =[Select id, OrderNumber, Type, Status, Account.AccountNumber from Order limit 1 ];
        List<OrderItem> ordrItemLst=[SELECT Id, UnitPrice, Quantity, OrderId,Order.Status,Product2Id,Product2.Name, Product2.ProductCode  FROM OrderItem where OrderId =:odr.id];
        
        System.Test.startTest();
        HTTPResponse strResp = kpn_HTTPCalloutClass.confirmOrderPostCallout(ordrItemLst,odr);
        System.assert(strResp.getStatusCode() == 200,'Order is not confirmed in the external system');
        System.Test.stopTest();
    }
}