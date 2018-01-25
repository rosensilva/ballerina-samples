import ballerina.net.http;
import ballerina.math;
import ballerina.log;

public function main (string[] args) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:8500", {});
    }
    string infoString;
    log:printInfo("Available services after discovery ... ");
    http:Request request = {};
    http:Response response = {};
    response, _ = httpEndpoint.get("/v1/catalog/services", request);
    json jsonResponse = response.getJsonPayload();
    infoString = "All Services Discovery Response message " + response.getJsonPayload().toString();
    log:printInfo(infoString);

    string[] availableServicesList = jsonResponse.getKeys();
    int numberOfServices = lengthof availableServicesList;
    int count = 0;
    while (count < numberOfServices) {
        infoString = " " + count + " -> " + availableServicesList[count] + " : " + jsonResponse[availableServicesList[count]].toString();
        log:printInfo(infoString);
        count = count + 1;
    }

    int randomNumber = math:randomInRange(1, numberOfServices);
    log:printInfo("Consuming resource name : " + availableServicesList[randomNumber] + "/");

    request = {};
    string urlString = "/v1/catalog/service/" + availableServicesList[randomNumber];
    response, _ = httpEndpoint.get(urlString, request);
    string discoveryString = "Service Discovery Response message : " + response.getJsonPayload().toString();
    log:printInfo(discoveryString);
    jsonResponse = response.getJsonPayload();

    var addressString, _ = (string)jsonResponse[0]["Address"];
    var portString, _ = (int)jsonResponse[0]["ServicePort"];
    urlString = "http://" + addressString + ":" + portString;
    http:HttpClient httpConn = create http:HttpClient(urlString, {});
    bind httpConn with httpEndpoint;
    request = {};
    urlString = "/" + availableServicesList[randomNumber];
    response, _ = httpEndpoint.get(urlString, request);
    infoString = "Response from the service consumed : " + response.getBinaryPayload().toString("UTF-8");
    log:printInfo(infoString);
}