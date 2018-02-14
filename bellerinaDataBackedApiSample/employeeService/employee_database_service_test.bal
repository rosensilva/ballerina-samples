package employeeService;

import ballerina.net.http;
import ballerina.test;

function beforeTest () {

}

function afterTest () {

}

function testHelloService () {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:9090/records", {});
    }
    http:OutRequest req = {};
    http:InResponse resp = {};
    // Start employee database service
    _ = test:startService("records");
    //prepare the request
    json requestJson = {"name":"Test Case", "age":"32", "ssn":"1233334566"};
    req.setJsonPayload(requestJson);
    resp, _ = httpEndpoint.post("/employee", req);
    println(resp.statusCode);
    test:assertIntEquals(resp.statusCode, 200, "Service did not reespond with 200 OK signal");
}