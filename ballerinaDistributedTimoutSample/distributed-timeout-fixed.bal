import ballerina.log;
import ballerina.net.http;
// Define a total deadline of 10000ms to complete three serial remote calls
const int deadline = 10000;

public function main (string[] args) {
    // Set 2000ms as local timeout for first remote call
    int localTimeout1 = 2000;
    // Set 3000ms as local timeout for second remote call
    int localTimeout2 = 3000;
    // Set remaining time of 5000ms as local timeout for final remote call
    int localTimeout3 = deadline - localTimeout1 - localTimeout2;
    int statusCode;

    // Successful trial
    log:printInfo("--------------------------------------------------------------------------");
    log:printInfo("                             Successful Trial");
    log:printInfo("--------------------------------------------------------------------------");
    try {
        log:printInfo("Local timeout for 1st remote procedure call :" + localTimeout1 + "ms");
        //calling http mock endpoint with localTimeout1 of 2 seconds and artificial network delay of 0 seconds
        statusCode = httpRemoteMockCall(localTimeout1, 0);
        log:printInfo("Local timeout for 2nd remote procedure call :" + localTimeout2 + "ms");
        //calling http mock endpoint with localTimeout2 of 3 seconds and artificial network delay of 1 second
        statusCode = httpRemoteMockCall(localTimeout2, 1);
        log:printInfo("Local timeout for 3rd remote procedure call :" + localTimeout3 + "ms");
        //calling http mock endpoint with localTimeout3 of 5 seconds and artificial network delay of 3 seconds
        statusCode = httpRemoteMockCall(localTimeout3, 3);
        log:printInfo("Successfuly recieved all three responses from remote calls within deadline");
    }
    catch (http:HttpConnectorError err) {
        log:printError("Unexpected error : " + err.msg);
    }

    // Unsuccessful trial
    log:printInfo("--------------------------------------------------------------------------");
    log:printInfo("                             Unsuccessful Trial");
    log:printInfo("--------------------------------------------------------------------------");
    try {
        //calling http mock endpoint with localTimeout1 of 2 seconds and artificial network delay of 5 seconds
        log:printInfo("Local timeout for 1st remote procedure call :" + localTimeout1 + "ms");
        statusCode = httpRemoteMockCall(localTimeout1, 5);
        log:printInfo("Local timeout for 2nd remote procedure call :" + localTimeout2 + "ms");
        //calling http mock endpoint with localTimeout2 of 3 seconds and artificial network delay of 4 seconds
        statusCode = httpRemoteMockCall(localTimeout2, 4);
        log:printInfo("Local timeout for 3rd remote procedure call :" + localTimeout3 + "ms");
        //calling http mock endpoint with localTimeout3 of 5 seconds and artificial network delay of 5 seconds
        statusCode = httpRemoteMockCall(localTimeout3, 5);
        log:printInfo("Successfully received all three responses from remote calls within deadline");
    }
    catch (http:HttpConnectorError err) {
        log:printError("Expected error : " + err.msg);
    }
}

public function httpRemoteMockCall (int localTimeout, int artificialNetworkDelay) (int) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("https://postman-echo.com", {endpointTimeout:localTimeout});
    }
    http:HttpConnectorError httpError;
    //Creating http request for postman-echo with an artificial delay response time
    http:Request request = {};
    http:Response response = {};
    string endpointUrl = "/delay/" + <string>artificialNetworkDelay;
    log:printInfo("Response delay for remote procedure call    :" + <string>(artificialNetworkDelay * 1000) + "ms");
    //sending the remote request and waiting for the response
    response, httpError = httpEndpoint.get(endpointUrl, request);
    if (httpError != null) {
        throw httpError;
    }
    return response.statusCode;
}