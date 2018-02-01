import ballerina.log;
import ballerina.math;
import ballerina.net.http;

public function main (string[] args) {
    endpoint<http:HttpClient> consulEndpoint {
        create http:HttpClient("http://localhost:8500", {});
    }
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:9001", {});
    }

    http:Request request = {};
    http:Response response = {};
    http:HttpConnectorError err;
    log:printInfo("Running Service Discovery ...");
    //calling consul API to get a complete list of available services
    response, err = consulEndpoint.get("/v1/catalog/services", request);
    //checking for errors with consul endpoint response
    if(err != null) {
        log:printError("Error occured while connecting to Consul, make sure consul is running \n Erorr: " + err.msg);
        return;
    }
    json jsonResponse = response.getJsonPayload();
    string[] availableServicesList = jsonResponse.getKeys();
    log:printInfo("List of Available Services");
    log:printInfo("--------------------------------------------------------");
    //print all the available service
    foreach availableService in availableServicesList {
        log:printInfo(jsonResponse[availableService].toString());
    }
    log:printInfo("--------------------------------------------------------");
    //select an random services from available services
    int randomNumber = math:randomInRange(1, lengthof availableServicesList);
    log:printInfo("Consuming resource name : " + availableServicesList[randomNumber]);
    request = {};
    string urlString = "/v1/catalog/service/" + availableServicesList[randomNumber];
    //get required details about the selected service endpoint from consul
    response, err = consulEndpoint.get(urlString, request);
    if(err != null) {
        log:printError("Error occured while requseting details about services from Consul, make sure consul is
        running properly \n Erorr: " + err.msg);
        return;
    }
    jsonResponse = response.getJsonPayload();
    //Construct the URL from the information retrieved by consul server
    var addressString, _ = (string)jsonResponse[0]["Address"];
    var portString, _ = (int)jsonResponse[0]["ServicePort"];
    urlString = "http://" + addressString + ":" + portString;

    //Creating a new http connection to service consume
    http:HttpClient httpConn = create http:HttpClient(urlString, {});
    bind httpConn with httpEndpoint;
    request = {};
    urlString = "/" + availableServicesList[randomNumber];

    //Consume the actual service
    response, err = httpEndpoint.get(urlString, request);
    //check the errors at service endpoint
    if(err != null) {
        log:printError("Error occured while consuming service , make sure all the services are running \n Erorr: " + err
                                                                                                                .msg);
        return;
    }
    log:printInfo("Response from the service consumed : " + response.getBinaryPayload().toString("UTF-8"));
}