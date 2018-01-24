import ballerina.net.http;
import util as oauth2;

string baseUrl = "https://10.100.1.112:8243/phonebook/v1/";
string accessToken = "dsd";
string clientId = "W81j82CxwhMRDHgakQKuGXmHHEoa";
string clientSecret = "NVPM0Pd2HernlBd3Ync2NfYnag0a";
string refreshToken = "d096e0e2-20ad-3f86-af1e-edb13701f739";
string refreshTokenEndPoint = "https://10.100.1.112:8243";
string refreshTokenPath = "/token";

function main (string[] args) {
    endpoint<oauth2:ClientConnector> clientConnector {
        create oauth2:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndPoint,
                                      refreshTokenPath);
    }
    while (true) {
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
}