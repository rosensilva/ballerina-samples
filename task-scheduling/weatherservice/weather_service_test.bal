package weatherservice;

import ballerina.net.http;
import ballerina.test;

function testInventoryService () {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:9090/weather", {});
    }
    // Initialize the empty http request and response
    http:OutRequest req = {};
    http:InResponse resp = {};
    // Start the weather service
    _ = test:startService("weatherService");

    // Test the weather summary resource
    // Prepare the same data
    json requestJsonPayload = {"city":"London", "Time":"05-05-2018:0800"};
    req.setJsonPayload(requestJsonPayload);
    // Send the request to service and get the response
    resp, _ = httpEndpoint.post("/summary", req);
    // Test the responses from the service with the original test data
    test:assertIntEquals(resp.statusCode, 200, "Weather service didnot respond with 200 OK signal");
    test:assertStringEquals(resp.getJsonPayload().city.toString(), requestJsonPayload.city.toString(),
                            " respond mismatch");
}
