@isTest
global class kpn_HTTPCalloutMockClass implements HttpCalloutMock {
 
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"message": "Order Confirmed Successfully"}');
        response.setStatus('Success');
        response.setStatusCode(200);
        return response; 
    }
    
}