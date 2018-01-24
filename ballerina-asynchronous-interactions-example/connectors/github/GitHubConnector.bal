package connectors.github;

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
        //sending the remote request and waiting for the response
        response, _ = httpEndpoint.get(requestString, request);
        //adding artificial delay to the response to demonstration purposes
        sleep(math:randomInRange(0, 2000));
        jsonResponse = response.getJsonPayload();
        return jsonResponse;
    }

    action getReposByUrl (string url) (json) {
        http:Request request = {};
        http:Response response = {};
        //create a new httpClient for the repos url
        http:HttpClient httpConn = create http:HttpClient(url, {});
        bind httpConn with httpEndpoint;
        response, _ = httpEndpoint.get("", request);
        sleep(math:randomInRange(0, 2000));
        return response.getJsonPayload();
    }
}