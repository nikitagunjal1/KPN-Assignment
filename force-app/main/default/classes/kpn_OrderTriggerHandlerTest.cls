/*
 * Class Name :kpn_OrderTriggerHandlerTest
 * Purpose : Test class for kpn_OrderTriggerHnadler
*/
@isTest
public class kpn_OrderTriggerHandlerTest {
  
    @testSetup static void setup() {
       
        // Create Account
        Account acc = Util.createAccount();
        
        //Create Contract
        Contract ct = Util.createContract(acc.id);
    	
        //Activate Contract
        Util.activateContract(ct);
     
        // Create Product
        Product2 prod = Util.createProduct('Product 1', 'ABC', 'Test product');
        
        // Get standard price book id
        Id pricebookId = Util.getStdPricebookId();
        system.debug('pricebookId---->'+pricebookId);
        
        // Create PricebookEntry    
        PricebookEntry standardPrice = Util.createPricebookEntry(pricebookId,prod.id, 2000);
        
        // Create Order        
        Order odr = Util.createOrder(acc.id,ct.id);
      
    }
    
    /*
 	* Method Name :testDisableOrder
	* param       :none
 	* return      :testmethod to test disable order method
 	*/
     public static testMethod void testDisableOrder(){
        
        System.Test.startTest();
        kpn_OrderTriggerHandler.TriggerDisabled = true;
        // Create Account
        Account acc = Util.createAccount();
        
        //Create Contract
        Contract ct = Util.createContract(acc.id);
    	
        //Activate Contract
        Util.activateContract(ct);
     
        // Create Product
        Product2 prod = Util.createProduct('Product 1', 'ABC', 'Test product');
        
        // Get standard price book id
        Id pricebookId = Util.getStdPricebookId();
        system.debug('pricebookId---->'+pricebookId);
        
        // Create PricebookEntry    
        PricebookEntry standardPrice = Util.createPricebookEntry(pricebookId,prod.id, 2000);
        
        // Create Order        
        Order odr = Util.createOrder(acc.id,ct.id);
        kpn_OrderTriggerHandler handler = new kpn_OrderTriggerHandler();
        handler.isDisabled();
        System.assert(odr.Pricebook2Id == null,'Order trigger is not disabled');   
        System.Test.stopTest();
    } 
    /*
 	* Method Name :testCreateOrder
	* param       :none
 	* return      :testmethod to test before and after insert method
 	*/
    public static testMethod void testCreateOrder(){
        
       
        System.Test.startTest();
        Order odr =[Select id,Pricebook2Id,Status from Order limit 1 ];
        System.assert(odr.Pricebook2Id != null,'Order trigger is disabled');   
        System.Test.stopTest();
    } 
    /*
 	* Method Name :testUpdateOrder
	* param       :none
 	* return      :testmethod to test before and after update method
 	*/
     public static testMethod void testUpdateOrder(){
        
        
        System.Test.startTest();
        Order odr =[Select id,Pricebook2Id,Status from Order limit 1];
        odr.EffectiveDate = system.today()+1;
        update odr;
        System.assert(odr.EffectiveDate ==system.today()+1,'Order not updated');   
        System.Test.stopTest();
    } 

    /*
 	* Method Name :testDeleteOrder
	* param       :none
 	* return      :testmethod to test before and after delete & after undelete method
 	*/
     public static testMethod void testDeleteOrder(){
        
        System.Test.startTest();
        Order odr =[Select id,Pricebook2Id,Status from Order limit 1];
        delete odr;
        List<Order> orderLst = [Select id,Pricebook2Id,Status from Order where id=:odr.id];
        System.assert( orderLst.size()== 0,'Order not deleted');   
        undelete odr;
        orderLst = [Select id,Pricebook2Id,Status from Order where id=:odr.id];
        System.assert( orderLst.size()> 0,'Order not undeleted');   
        System.Test.stopTest();
    } 
    
   
}