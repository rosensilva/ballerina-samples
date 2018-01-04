import ballerina.math;
import ballerina.net.http;
import ballerina.log;

int count =0;

public function main (string[] args) {

    log:printInfo("Distributed timeout demo program started...");
    int deadline = 10000;
    while(true) {
        count = count + 1;
        log:printInfo("----------------------------------------------------------------------------");
        log:printInfo("                          TEST NO :" + <string >count);
        try {
            int localTimeout1 = math:randomInRange(2000, 4000);
            log:printInfo("Local timeout for 1st remote procedure call :" + localTimeout1 + "ms");
            httpCall(localTimeout1);

            int localTimeout2 = math:randomInRange(1000, deadline - localTimeout1 - 1000);
            log:printInfo("Local timeout for 2nd remote procedure call :" + localTimeout2 + "ms");
            httpCall(localTimeout2);

            int localTimeout3 = deadline - localTimeout1 - localTimeout2;
            log:printInfo("Local timeout for 3rd remote procedure call :" + localTimeout3 + "ms");
            httpCall(localTimeout3);
        }
        catch (error err) {
            log:printError("Failed to get responce within local timeout");
        }
        sleep(4000);
    }
}


function httpCall(int localTimeout){
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("https://postman-echo.com", {endpointTimeout: localTimeout});
    }

    http:Request req = {};
    http:Response resp = {};
    int delayTime = math:randomInRange(1,3);
    string endpointUrl = "/delay/"+<string>delayTime;
    log:printInfo("Responce delay for remote procedure call :"+<string>(delayTime*1000)+"ms");
    try{
        resp, _ = httpEndpoint.get(endpointUrl, req);
        int responseCode = resp.statusCode;
        log:printInfo("HTTP responce status code : "+responseCode);
    }
    catch (error e) {
        throw e;
    }
}