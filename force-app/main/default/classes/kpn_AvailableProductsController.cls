/*
 * Class Name :kpn_AvailableProductsController
 * Purpose : Referred by LWC component kpn_availableProductList
 */
public with sharing class kpn_AvailableProductsController {

  
    /*
 	* Method Name :getAllProductList
	* Input param :Order Id
 	* Return : Returns List of PricebookEntry
 	*/
    @AuraEnabled(Cacheable=true)
    public static List<PricebookEntry> getAllProducts(String orderId) {
       
        Map<Id,PricebookEntry> priceBookEntryMap = new Map <Id,PricebookEntry>();
        List<PricebookEntry> priceBookEntList=new List<PricebookEntry>();
        
       
        String stdPriceBookId = Util.getStdPricebookId();
        
        // get all the product ids from active price list entries of standard pricebook , use map to avoid duplicate products
        
        for(PricebookEntry priceEntryRec : [SELECT Id, Product2Id,PriceBook2Id,Product2.Name,UnitPrice,Product2.ProductCode FROM PricebookEntry where PriceBook2Id =:stdPriceBookId]){
            priceBookEntryMap.put(priceEntryRec.Product2Id,priceEntryRec);
        }
        system.debug('priceBookEntryMap--'+priceBookEntryMap);

        if(priceBookEntryMap.size()>0){
            for(PricebookEntry priceBkEntry :priceBookEntryMap.values()){
                priceBookEntList.add(priceBkEntry);
            }
        }      
        return priceBookEntList;
    }
   
    
}