package inventoryStore;

import ballerina.net.http;
import ballerina.test;

function testInventoryService () {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:9092/inventory", {});
    }
    // Initialize the empty http request and response
    http:OutRequest req = {};
    http:InResponse resp = {};
    // Start inventory service
    _ = test:startService("inventoryService");

    // Test the inventory resource
    // Prepare order with sample items
    json requestJson = {"items":{"1":"Basket","2": "Table","3": "Chair"}};
    req.setJsonPayload(requestJson);
    // Send the request to service and get the response
    resp, _ = httpEndpoint.post("/", req);
    println(resp.getJsonPayload());
    println("test123");
    // Test the responses from the service with the original test data
    test:assertIntEquals(resp.statusCode, 200, "Inventory service didnot respond with 200 OK signal");
    //test:assertStringEquals(resp.getJsonPayload().Name.toString(), "Alice", "Name did not store in the database");

}


