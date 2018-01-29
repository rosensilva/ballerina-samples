import ballerina.net.http;
import util.connectors as oauth2;

string baseUrl = "https://10.100.1.112:8243/phonebook/v1/";
string accessToken = "a3a9f667-7dbf-3cd7-80b3-060a312b6152";
string clientId = "W81j82CxwhMRDHgakQKuGXmHHEoa";
string clientSecret = "NVPM0Pd2HernlBd3Ync2NfYnag0a";
string refreshToken = "7d157cb4-69ba-3375-9c68-b4c0433ed788";
string refreshTokenEndPoint = "https://10.100.1.112:8243";
string refreshTokenPath = "/token";

function main (string[] args) {
    endpoint<oauth2:ClientConnector> clientConnector {
        create oauth2:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndPoint,
                                      refreshTokenPath);
    }
    http:Request request = {};
    http:Response userProfileResponse = {};
    json userProfileJSONResponse;
    string requestString = "";
    http:HttpConnectorError e;

    println("-----Calling POST method-----");
    requestString = "/number?name=Alice&number=123456789";
    userProfileResponse, e = clientConnector.post(requestString, request);
    if (e == null) {
        userProfileJSONResponse = userProfileResponse.getJsonPayload();
        println(userProfileJSONResponse.toString());
    } else {
        println(e);
    }

    request = {};
    println("-----Calling GET method-----");
    requestString = "/number/Alice";
    userProfileResponse, e = clientConnector.get(requestString, request);
    if (e == null) {
        userProfileJSONResponse = userProfileResponse.getJsonPayload();
        println(userProfileJSONResponse.toString());
    } else {
        println(e);
    }

    request = {};
    println("-----Calling DELETE method-----");
    requestString = "/number?name=Alice";
    userProfileResponse, e = clientConnector.delete(requestString, request);
    if (e == null) {
        userProfileJSONResponse = userProfileResponse.getJsonPayload();
        println(userProfileJSONResponse.toString());
    } else {
        println(e);
    }
    sleep(5000);
}