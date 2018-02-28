package guide.pet_store;

import ballerina.net.http;
import ballerina.test;

function beforeTest () {
    // Start petStore service
    _ = test:startService("BallerinaPetstore");
}

function testPetStore () {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:9090/v1", null);
    }

    json samplePet = {"id":"1", "catogery":"dog", "name":"doggie"};
    json updatedPet = {"id":"1", "catogery":"dog-updated", "name":"Updated-doggie"};
    http:HttpConnectorError err;

    // Initialize the empty http request and response
    http:OutRequest req = {};
    http:InResponse resp = {};

    // Test the addPet resource
    req.setJsonPayload(samplePet);
    // Send a request to service
    resp, err = httpEndpoint.post("/pet", req);
    test:assertIntEquals(resp.statusCode, 200, "pet store service didnot respond with 200 OK signal");

    string expectedOutputString = "Pet added successfully : Pet ID = 1";
    // Assert the response message payload string
    test:assertStringEquals(resp.getStringPayload(), expectedOutputString, "Reponse message not matched");


    // Test the updatePet resource
    req = {};
    req.setJsonPayload(updatedPet);
    // Send a request to service
    resp, err = httpEndpoint.put("/pet", req);
    test:assertIntEquals(resp.statusCode, 200, "pet store service didnot respond with 200 OK signal");

    expectedOutputString = "Pet details updated successfully : id = 1";
    // Assert the response message payload string
    test:assertStringEquals(resp.getStringPayload(), expectedOutputString, "Reponse message not matched");

    // Test the getPetById resource
    req = {};
    // Send a request to service
    resp, err = httpEndpoint.get("/pet/1", req);
    test:assertIntEquals(resp.statusCode, 200, "pet store service didnot respond with 200 OK signal");
    // Assert the response message payload string
    test:assertStringEquals(resp.getJsonPayload().toString(), updatedPet.toString(), "Reponse message not matched");

    // Test the deletePet resource
    req = {};
    // Send a request to service
    resp, err = httpEndpoint.delete("/pet/1", req);
    test:assertIntEquals(resp.statusCode, 200, "pet store service didnot respond with 200 OK signal");

    expectedOutputString = "Deleted pet data successfully : Pet ID = 1";
    // Assert the response message payload string
    test:assertStringEquals(resp.getStringPayload(), expectedOutputString, "Reponse message not matched");
}