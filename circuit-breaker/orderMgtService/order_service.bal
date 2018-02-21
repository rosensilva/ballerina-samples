package orderMgtService;

import ballerina.net.http.resiliency;
import ballerina.net.http;

@http:configuration {basePath:"/order"}
service<http> orderService {
    endpoint<resiliency:CircuitBreaker> circuitBreakerEP {
        create resiliency:CircuitBreaker(create http:HttpClient("http://localhost:9092", {endpointTimeout:3000}), 0.2,
                                         20000);
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/"
    }
    resource orderResource (http:Connection httpConnection, http:InRequest request) {
        // Initialize the request and response message to send to the inventory service
        http:OutResponse outResponse = {};
        http:OutRequest outRequest = {};
        // Initialize the response message to send back to client
        http:InResponse inResponse = {};
        http:HttpConnectorError err;
        // Extract the items from the json payload
        json items = request.getJsonPayload().items;
        // Send bad request message to the client if request don't contain items JSON
        if (items == null) {
            outResponse.setStringPayload("Error : Please check the input json payload");
            outResponse.statusCode = 400;
            _ = httpConnection.respond(outResponse);
            return;
        }
        log:printInfo("Recieved Order : " + items.toString());
        // Set the outgoing request JSON payload with items
        outRequest.setJsonPayload(items);
        // Call the inventory backend with the item list
        inResponse, err = circuitBreakerEP.post("/inventory", outRequest);
        // If inventory backend contain errors forward the error message to client
        if (err != null) {
            log:printInfo("Inventory service returns an error :" + err.msg);
            outResponse.setJsonPayload({"Error":"Inventory Service did not respond", "Error_message":err.msg});
            _ = httpConnection.respond(outResponse);
            return;
        }
        // Send response to the client if the order placement was successful
        outResponse.setStringPayload("Order Placed for items :" + inResponse.getJsonPayload().toString());
        _ = httpConnection.respond(outResponse);
    }
}
