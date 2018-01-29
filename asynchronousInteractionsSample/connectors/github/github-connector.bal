package asynchronousInteractionsSample.connectors.github;

import ballerina.log;
import ballerina.math;
import ballerina.net.http;

public connector GitHubConnector () {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("https://api.github.com", {});
    }

    action getUserDetails (string userName) (json) {
        http:Request request = {};
        http:Response response = {};
        json jsonResponse;
        string requestString = "/users/" + userName;
        try {
            //sending the remote request and waiting for the response
            response, _ = httpEndpoint.get(requestString, request);
            //adding artificial delay to the response for demonstration purposes
            sleep(math:randomInRange(0, 2000));
            jsonResponse = response.getJsonPayload();
        }
        catch (error err) {
            log:printError("Error while getting user details " + err.msg);
        }
        return jsonResponse;
    }

    action getReposByUrl (string url) (json) {
        http:Request request = {};
        http:Response response = {};
        json jsonResponse;
        //create a new httpClient for the repos url
        http:HttpClient httpConn = create http:HttpClient(url, {});
        try {
            //bind the new http client with the github endpoint
            bind httpConn with httpEndpoint;
            response, _ = httpEndpoint.get("", request);
            //adding artificial delay to the response for demonstration purposes
            sleep(math:randomInRange(0, 2000));
            jsonResponse = response.getJsonPayload();
        }
        catch (error err) {
            log:printError("Error while getting retrieving git repos " + err.msg);
        }
        return jsonResponse;
    }
}