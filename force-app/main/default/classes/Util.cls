/*
 * Class Name :Util
 * Purpose    :This class is used to write the methods which can be reused for any classes / test classes.
 */

public with sharing class Util {     
    
    private static Pricebook2 stdPriceBook;  // Singleton, remember when first referenced

    /*
 	* Method Name :getStdPricebookId
	* param       :none
 	* return      :Return Price book Id ( with Singleton pattern)
 	*/
    public static ID getStdPricebookId() {
        // Used a singleton pattern to avoid initializing the object repeatedly in the transaction
        if (Test.isRunningTest()) {
            return Test.getStandardPricebookId();
        }
        else{
            return getStdPricebook().id;        
        }
    } 


    /*
 	* Method Name :getStdPriceBook
	* param       :none
 	* return      :Return Price book Id ( with Singleton pattern)
 	*/
    public static Pricebook2    getStdPriceBook () {
        if (stdPriceBook == null) {
            stdPriceBook    = [select id, name from Pricebook2 where isStandard = true limit 1];
        }    
        return stdPriceBook;    
    }

    /*
 	* Method Name :createAccount
	* param       :none
 	* return      :Return Account record
 	*/
    public static Account createAccount() {
        // Insert Account
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        return acc;    
    }

    /*
 	* Method Name :createContract
	* param       :Account Id
 	* return      :Return Contract record
 	*/
    public static Contract createContract(string accId) {
        // Insert Contract
        Contract ct = new Contract();
        ct.AccountId = accId;
        ct.Status = 'Draft';
        ct.StartDate = Date.Today();
        ct.ContractTerm = 12;
        insert ct;
        return ct;
    }     
          
    /*
 	* Method Name :activateContract
	* param       :Contract record
 	* return      :none
 	*/
    public static void activateContract(Contract ct) {
        
        //Activate Contract
        ct.Status='Activated';
        update ct;
    }   

    /*
 	* Method Name :createProduct
	* param       :Product name, Product code, Product description
 	* return      :Returns Product record
 	*/
    public static Product2 createProduct(String prodName, String prodCode, String prodDesc) {
        // Insert Product
        Product2 prod = new Product2();
        prod.Name = prodName;
        prod.Description= prodDesc;
        prod.productCode = prodCode;
        prod.isActive = true;
        insert prod;
        return prod;
          
    } 
         
    /*
 	* Method Name :createPricebookEntry
	* param       :Pricebook Id,Product Id
 	* return      :Returns Pricebook Entry record
 	*/
    public static PricebookEntry createPricebookEntry(String pricebookId, String prodId, Integer unitPrice) {     
        // Insert PricebookEntry    
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = pricebookId;
        standardPrice.Product2Id = prodId;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        return standardPrice;
    }    
    
    /*
 	* Method Name :createOrder
	* param       :Pricebook Id,Account Id, Contract id 
 	* return      :Returns order record
 	*/
    public static Order createOrder(String accId, String cntrId) {  
        // Insert Order          
        Order odr = new Order();
        odr.Name = 'Test Order ';
        odr.Status = 'Draft';
        odr.EffectiveDate = system.today();
        odr.EndDate = system.today() + 4;
        odr.AccountId = accId;
        odr.ContractId = cntrId;      
        insert odr;
        return odr;
    }

    /*
 	* Method Name :createOrderItem
	* param       :Priceboek entry Id,Order Id, Product id 
 	* return      :Returns order item record
 	*/
    public static OrderItem createOrderItem(String pricebookentryId, String odrId, String prdId, Integer quantity, Integer unitPrice) {   
        // Insert Order Item          
        OrderItem odrItm = new OrderItem();
        odrItm.OrderId = odrId;
        odrItm.Quantity = quantity;
        odrItm.UnitPrice = unitPrice;
        odrItm.Product2id = prdId;
        odrItm.PricebookEntryId=pricebookentryId;
        insert odrItm;
        return odrItm;
    }      
   
}