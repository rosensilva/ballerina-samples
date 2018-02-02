import ballerina.config;
import ballerina.log;
import ballerina.net.http;
import util.connectors as oauth2;

string baseUrl = config:getGlobalValue("baseUrl");
string accessToken = config:getGlobalValue("accessToken");
string clientId = config:getGlobalValue("clientId");
string clientSecret = config:getGlobalValue("clientSecret");
string refreshToken = config:getGlobalValue("refreshToken");
string refreshTokenEndPoint = config:getGlobalValue("refreshTokenEndPoint");
string refreshTokenPath = config:getGlobalValue("refreshTokenPath");

function main (string[] args) {
    endpoint<oauth2:ClientConnector> oauthClientConnector {
        create oauth2:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndPoint,
                                      refreshTokenPath);
    }
    http:Request request = {};
    http:Response response = {};
    json jsonResponse;
    string requestString;
    http:HttpConnectorError connectionError;

    //calling oauth2 authorise HTTP GET endpoint using ballerina oauth2 connector
    log:printInfo("-----Calling POST method-----");
    requestString = "/number?name=Alice&number=123456789";
    response, connectionError = oauthClientConnector.post(requestString, request);
    if (connectionError == null) {
        jsonResponse = response.getJsonPayload();
        log:printInfo(jsonResponse.toString());
    } else {
        log:printError(connectionError.msg);
    }


    //calling oauth2 authorise HTTP GET endpoint using ballerina oauth2 connector
    request = {};
    log:printInfo("-----Calling GET method-----");
    requestString = "/number/Alice";
    response, connectionError = oauthClientConnector.get(requestString, request);
    if (connectionError == null) {
        jsonResponse = response.getJsonPayload();
        log:printInfo(jsonResponse.toString());
    } else {
        log:printError(connectionError.msg);
    }

    //calling oauth2 authorise HTTP DELETE endpoint using ballerina oauth2 connector
    request = {};
    log:printInfo("-----Calling DELETE method-----");
    requestString = "/number?name=Alice";
    response, connectionError = oauthClientConnector.delete(requestString, request);
    if (connectionError == null) {
        jsonResponse = response.getJsonPayload();
        log:printInfo(jsonResponse.toString());
    } else {
        log:printError(connectionError.msg);
    }
    sleep(5000);
}