import ballerina.net.http;
import ballerina.math;
import ballerina.log;

public function main (string[] args) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:8500", {});
    }
    string infoString;
    log:printInfo("Available services after discovery ... ");
    http:Request req = {};
    http:Response resp = {};
    resp, _ = httpEndpoint.get("/v1/catalog/services", req);
    json jsonResponse = resp.getJsonPayload();
    infoString = "All Services Discovery Response message " + resp.getJsonPayload().toString();
    log:printInfo(infoString);

    string[] keys = jsonResponse.getKeys();
    int length = lengthof keys;
    int count = 0;


    while (count < length) {
        infoString = " " + count + " -> " + keys[count] + " : " + jsonResponse[keys[count]].toString();
        log:printInfo(infoString);
        count = count + 1;
    }

    int randomNumber = math:randomInRange(1, 4);
    log:printInfo("Consuming resource name : " + keys[randomNumber] + "/");

    req = {};
    string urlString = "/v1/catalog/service/" + keys[randomNumber];
    resp, _ = httpEndpoint.get(urlString, req);
    string discoveryString = "Service Discovery Response message : " + resp.getJsonPayload().toString();
    log:printInfo(discoveryString);

    jsonResponse = resp.getJsonPayload();
    var addressString, _ = (string)jsonResponse[0]["Address"];
    var portString, _ = (int)jsonResponse[0]["ServicePort"];
    urlString = "http://" + addressString + ":" + portString;

    http:HttpClient httpConn = create http:HttpClient(urlString, {});
    bind httpConn with httpEndpoint;

    req = {};
    urlString = "/" + keys[randomNumber];
    resp, _ = httpEndpoint.get(urlString, req);
    infoString = "Responce from the service consumed : " + resp.getBinaryPayload().toString("UTF-8");
    log:printInfo(infoString);
}
