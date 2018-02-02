import ballerina.log;
import ballerina.math;
import ballerina.net.http;

int count = 0;
const int deadline = 10000;
public function main (string[] args) {
    log:printInfo("Distributed timeout demo program started...");

    while (true) {
        count = count + 1;
        int responseCode = 0;
        log:printInfo("----------------------------------------------------------------------------");
        log:printInfo("                          TRIAL NO :" + <string>count);

        try {
            //First remote call with random local timeout between 2000ms and 4000ms
            int localTimeout1 = math:randomInRange(2000, 4000);
            log:printInfo("Local timeout for 1st remote procedure call :" + localTimeout1 + "ms");
            responseCode = httpRemoteMockCall(localTimeout1);
            log:printInfo("HTTP response status code : " + responseCode);
            //Second remote call with random local timeout between 2000ms and 4000ms
            int localTimeout2 = math:randomInRange(2000, 4000);
            log:printInfo("Local timeout for 2nd remote procedure call :" + localTimeout2 + "ms");
            responseCode = httpRemoteMockCall(localTimeout2);
            log:printInfo("HTTP response status code : " + responseCode);
            //Third remote call with the remaining timeout
            int localTimeout3 = deadline - localTimeout1 - localTimeout2;
            log:printInfo("Local timeout for 3rd remote procedure call :" + localTimeout3 + "ms");
            responseCode = httpRemoteMockCall(localTimeout3);
            log:printInfo("HTTP response status code : " + responseCode);
            //Print success message if all three remote calls receives a responses
            log:printInfo("Succesfully recieved responses from all the RPC calls within deadline of : "
                          + <string>deadline + "ms");
        }
        catch (error err) {
            //Print error if any remote call return an error
            log:printError("Failed to get response within local timeout " + err.msg);
        }
        sleep(4000);
    }
}

public function httpRemoteMockCall (int localTimeout) (int) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("https://postman-echo.com", {endpointTimeout:localTimeout});
    }
    //Creating http request for postman-echo with random delay response time
    http:Request request = {};
    http:Response response = {};
    //generating a artificial delay for remote call
    int delayTime = math:randomInRange(0, 4);
    string endpointUrl = "/delay/" + <string>delayTime;
    log:printInfo("Response delay for remote procedure call :" + <string>(delayTime * 1000) + "ms");
    //sending the remote request and waiting for the response
    response, _ = httpEndpoint.get(endpointUrl, request);
    int responseCode = response.statusCode;
    return responseCode;
}