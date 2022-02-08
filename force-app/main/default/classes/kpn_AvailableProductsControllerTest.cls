/*
 * Class Name :kpn_AvailableProductsControllerTest
 * Purpose : Test class for kpn_AvailableProductsController
*/
@isTest
public class kpn_AvailableProductsControllerTest {

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
 	* Method Name :testAvailableProduct
	* param      :
 	* return : testmethod to test getAllProducts method
 	*/
    public static testMethod void testAvailableProduct(){
        
        Order odr =[Select id from Order];
        System.Test.startTest();
        List<PricebookEntry> pbEntLst=kpn_AvailableProductsController.getAllProducts(odr.Id);
        System.assert(pbEntLst.size()>0,'PricebookEntry List should not be null');
        System.Test.stopTest();
    } 
}