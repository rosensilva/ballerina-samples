import ballerina.net.http;
import ballerina.math;
import ballerina.log;

int count = 0;
const int deadline = 10000;
public function main (string[] args) {
    log:printInfo("Distributed timeout demo program started...");

    while (true) {
        count = count + 1;
        log:printInfo("----------------------------------------------------------------------------");
        log:printInfo("                          TRIAL NO :" + <string>count);

        try {
            //First remote call with random local timeout between 2000ms and 4000ms
            int localTimeout1 = math:randomInRange(2000, 4000);
            log:printInfo("Local timeout for 1st remote procedure call :" + localTimeout1 + "ms");
            httpRemoteMockCall(localTimeout1);
            //Second remote call with random local timeout between 2000ms and 4000ms
            int localTimeout2 = math:randomInRange(2000, 4000);
            log:printInfo("Local timeout for 2nd remote procedure call :" + localTimeout2 + "ms");
            httpRemoteMockCall(localTimeout2);
            //Third remote call with the remaining timeout
            int localTimeout3 = deadline - localTimeout1 - localTimeout2;
            log:printInfo("Local timeout for 3rd remote procedure call :" + localTimeout3 + "ms");
            httpRemoteMockCall(localTimeout3);
            //Print success message if all three remote calls receives a responses
            log:printInfo("Succesfully recieved responses from all the RPC calls within deadline of : " + <string>deadline + "ms");
        }
        catch (error err) {
            //Print error if any remote call return an error
            log:printError("Failed to get response within local timeout " + err.msg);
        }
        sleep(4000);
    }
}

function httpRemoteMockCall (int localTimeout) {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("https://postman-echo.com", {endpointTimeout:localTimeout});
    }
    //Creating http request for postman-echo with random delay response time
    http:Request request = {};
    http:Response response = {};
    int delayTime = math:randomInRange(0, 4);
    string endpointUrl = "/delay/" + <string>delayTime;
    log:printInfo("Response delay for remote procedure call :" + <string>(delayTime * 1000) + "ms");
    //sending the remote request and waiting for the response
    response, _ = httpEndpoint.get(endpointUrl, request);
    int responseCode = response.statusCode;
    log:printInfo("HTTP response status code : " + responseCode);
}