/*
 * Class Name :kpn_HTTPCalloutClass
 * Purpose : Used for HTTP Callout to the external system
 */
public with sharing class kpn_HTTPCalloutClass {
    /*
 	* Method Name :OrderProduct
	* Wrapper Class to JSON list or Order Products for request payload
 	* 
 	*/
    Public Class OrderProduct{
        Public String name{get;set;}
        Public String code{get;set;}
        Public Decimal unitPrice;
        Public Decimal  quantity;

        Public OrderProduct (String Name, String Code, Decimal UnitPrice, Decimal Quantity ){
            this.name = Name;
            this.code = Code;
            this.unitPrice = UnitPrice;
            this.quantity = Integer.valueof(Quantity);
        } 
    }

    /*
 	* Method Name :RequestPayload
	* Wrapper Class to generate request payload
 	* 
 	*/
    Public Class RequestPayload{
        Public String accountNumber{get;set;}
        Public String orderNumber{get;set;}
        Public String status{get;set;}
        Public String type{get;set;}
        Public List<OrderProduct> orderProducts;

        Public RequestPayload (String AccountNumber, String OrderNumber, String Status, String Type, List<OrderProduct> OrderProducts ){
            this.accountNumber = AccountNumber;
            this.orderNumber = OrderNumber;
            this.status = Status;
            this.type = Type;
            this.orderProducts = new List<OrderProduct>(Orderproducts);
         
        } 
    }
    /*
 	* Method Name: createHttpRequest
	* param      : String endpoint, String method, String reqBody, Integer timeout, String headers
 	* return     : Returns HTTP Response
 	*/

    Public Static HttpResponse createHttpRequest(String endpoint, String method, String reqBody, Integer timeout, String header) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        if(endpoint != '')
            request.setEndpoint(endpoint);
        if(method != '')
            request.setMethod(method);
        if(timeout != null)
            request.setTimeout(timeout);
        if(reqBody != '')
            request.setBody(reqBody);   
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);     
        return response;
    }

    /*
 	* Method Name : generateRequestPayload
	* param       : List<ID> IDs of OrderItems and ID of Order record
 	* return      : Returns Json String for request payload
 	*/
  
    Public Static String generateRequestPayload(List<OrderItem> orderItems,Order order){//(List<ID> orderItemIds,ID orderId) {
        List<OrderProduct> orderProducts = new List<OrderProduct>();

        // Query Order Items ad pass it to orderProducts to generate JSON List
        for(OrderItem ordItem : orderItems ){//: [select Id, UnitPrice,TotalPrice,Quantity,Product2Id,Product2.Name,Product2.ProductCode FROM OrderItem WHERE OrderId =:orderId ] ){
            system.debug('ordItem--'+ordItem);
            orderProducts.add(new OrderProduct(ordItem.Product2.Name,ordItem.Product2.ProductCode, ordItem.UnitPrice, ordItem.Quantity ));
        }
        
        // Generate final request payload
        RequestPayload requestBody = new RequestPayload(order.Account.AccountNumber, order.OrderNumber, order.Status, order.Type,orderProducts) ;
        system.debug('requestBody--'+requestBody);

        // Return json string
        return JSON.Serialize(requestBody);
        
    }    


    /*
 	* Method Name :confirmOrderPostCallout
	* param      :List<ID> IDs of OrderItems and ID of Order record
 	* return : void 
 	*/
      
    //@future(callout=true)
    Public Static HTTPResponse confirmOrderPostCallout(List<OrderItem> orderItems,Order order){//(List<ID> orderItemIds, ID orderId) {
        // Call method to generate request payload
        String reqBody =  generateRequestPayload(orderItems,order);
        system.debug('reqBody--'+reqBody);

        // Call method to create http request and send it to external system 
        // In current code remote site setting is used to whitelist the endpoint. 
        // This is not needed if we use Named credentials. Haven't used named credentials as we 
        // dont have any credentials which needs to be provided to do the callout. 
        HTTPResponse res = createHttpRequest(
            'https://confirmorder.requestcatcher.com/',
            'POST',
            reqBody,
            60000,
            ''
        );  
        return res;
    }


}