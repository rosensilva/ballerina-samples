import ballerina.net.http;
import util as oauth2;

string baseUrl = "https://10.100.1.112:8243/phonebook/v1/";
string accessToken = "5172f226-2b4b-307a-92a7-d799ef35d976";
string clientId = "W81j82CxwhMRDHgakQKuGXmHHEoa";
string clientSecret = "NVPM0Pd2HernlBd3Ync2NfYnag0a";
string refreshToken = "ca91cf34-0633-38bd-9a03-e80ec44c2c70";
string refreshTokenEndPoint = "https://10.100.1.112:8243";
string refreshTokenPath = "/token";

function main (string[] args) {
    endpoint<oauth2:ClientConnector> clientConnector {
        create oauth2:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndPoint, refreshTokenPath);
    }

    http:Request request = {};
    http:Response userProfileResponse = {};
    json userProfileJSONResponse;
    string requestString ="";
    http:HttpConnectorError e;

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
    println("-----Calling DELTE method-----");
    requestString = "/number?name=Alice";
    userProfileResponse, e = clientConnector.delete(requestString, request);
    if (e == null) {
        userProfileJSONResponse = userProfileResponse.getJsonPayload();
        println(userProfileJSONResponse.toString());
    } else {
        println(e);
    }

}