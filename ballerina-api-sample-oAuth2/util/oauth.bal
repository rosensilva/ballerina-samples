package util;

import ballerina.net.http;
import ballerina.util;

string accessTokenValue = null;
string refreshTokenValue = null;
http:HttpConnectorError e;
http:Response response = {};

@Description {value:"OAuth2 client connector"}
@Param {value:"baseUrl: The endpoint base url"}
@Param {value:"accessToken: The access token of the account"}
@Param {value:"clientId: The client Id of the account"}
@Param {value:"clientSecret: The client secret of the account"}
@Param {value:"refreshToken: The refresh token of the account"}
@Param {value:"refreshTokenEP: The refresh token endpoint url"}
public connector ClientConnector (string baseUrl, string accessToken, string clientId, string clientSecret,
                                  string refreshToken, string refreshTokenEP, string refreshTokenPath) {

    endpoint<http:HttpClient> httpConnectorEP {
        create http:HttpClient(baseUrl, {});
    }

    @Description {value:"Get with OAuth2 authentication"}
    @Param {value:"path: The endpoint path"}
    @Param {value:"request: The request of the method"}
    @Return {value:"response object"}
    @Return {value:"Error occured during HTTP client invocation."}
    action get (string path, http:Request request) (http:Response, http:HttpConnectorError) {
        populateAuthHeader(request, accessToken);
        response, e = httpConnectorEP.get(path, request);
        request = {};

        if (checkAndRefreshToken(request, accessToken, clientId, clientSecret, refreshToken, refreshTokenEP,
                                 refreshTokenPath)) {
            response, e = httpConnectorEP.get(path, request);
        }

        return response, e;
    }

    @Description {value:"Post with OAuth2 authentication"}
    @Param {value:"path: The endpoint path"}
    @Param {value:"request: The request of the method"}
    @Return {value:"response object"}
    @Return {value:"Error occured during HTTP client invocation."}
    action post (string path, http:Request originalRequest) (http:Response, http:HttpConnectorError) {
        var originalPayload = originalRequest.getBinaryPayload();

        populateAuthHeader(originalRequest, accessToken);
        println(originalRequest);
        response, e = httpConnectorEP.post(path, originalRequest);

        http:Request request = {};
        request.setBinaryPayload(originalPayload);

        if (checkAndRefreshToken(request, accessToken, clientId, clientSecret, refreshToken, refreshTokenEP,
                                 refreshTokenPath)) {
            response, e = httpConnectorEP.post(path, request);
        }

        return response, e;
    }

    @Description {value:"Put with OAuth2 authentication"}
    @Param {value:"path: The endpoint path"}
    @Param {value:"request: The request of the method"}
    @Return {value:"response object"}
    @Return {value:"Error occured during HTTP client invocation."}
    action put (string path, http:Request originalRequest) (http:Response, http:HttpConnectorError) {
        var originalPayload = originalRequest.getBinaryPayload();

        populateAuthHeader(originalRequest, accessToken);
        response, e = httpConnectorEP.put(path, originalRequest);

        http:Request request = {};
        request.setBinaryPayload(originalPayload);

        if (checkAndRefreshToken(request, accessToken, clientId, clientSecret, refreshToken, refreshTokenEP,
                                 refreshTokenPath)) {
            response, e = httpConnectorEP.put(path, request);
        }

        return response, e;
    }

    @Description {value:"Delete with OAuth2 authentication"}
    @Param {value:"path: The endpoint path"}
    @Param {value:"request: The request of the method"}
    @Return {value:"response object"}
    @Return {value:"Error occured during HTTP client invocation."}
    action delete (string path, http:Request originalRequest) (http:Response, http:HttpConnectorError) {
        var originalPayload = originalRequest.getBinaryPayload();

        populateAuthHeader(originalRequest, accessToken);
        response, e = httpConnectorEP.delete(path, originalRequest);

        http:Request request = {};
        request.setBinaryPayload(originalPayload);

        if (checkAndRefreshToken(request, accessToken, clientId, clientSecret, refreshToken, refreshTokenEP,
                                 refreshTokenPath)) {
            response, e = httpConnectorEP.delete(path, request);
        }

        return response, e;
    }

    @Description {value:"Patch with OAuth2 authentication"}
    @Param {value:"path: The endpoint path"}
    @Param {value:"request: The request of the method"}
    @Return {value:"response object"}
    @Return {value:"Error occured during HTTP client invocation."}
    action patch (string path, http:Request originalRequest) (http:Response, http:HttpConnectorError) {
        var originalPayload = originalRequest.getBinaryPayload();

        populateAuthHeader(originalRequest, accessToken);
        response, e = httpConnectorEP.patch(path, originalRequest);

        http:Request request = {};
        request.setBinaryPayload(originalPayload);

        if (checkAndRefreshToken(request, accessToken, clientId, clientSecret, refreshToken, refreshTokenEP,
                                 refreshTokenPath)) {
            response, e = httpConnectorEP.patch(path, request);
        }

        return response, e;
    }
}

function populateAuthHeader (http:Request request, string accessToken) {
    if (accessTokenValue == null) {
        accessTokenValue = accessToken;
    }

    request.setHeader("Authorization", "Bearer " + accessTokenValue);
}

function checkAndRefreshToken (http:Request request, string accessToken, string clientId,
                               string clientSecret, string refreshToken, string refreshTokenEP, string refreshTokenPath)
(boolean) {
    boolean isRefreshed;
    if ((response.getStatusCode() == 401) && refreshToken != null) {
        accessTokenValue = getAccessTokenFromRefreshToken(request, accessToken, clientId, clientSecret, refreshToken,
                                                          refreshTokenEP, refreshTokenPath);
        isRefreshed = true;
    }

    return isRefreshed;
}

function getAccessTokenFromRefreshToken (http:Request request, string accessToken, string clientId, string clientSecret,
                                         string refreshToken, string refreshTokenEP, string refreshTokenPath) (string) {

    endpoint<http:HttpClient> refreshTokenHTTPEP {
        create http:HttpClient(refreshTokenEP, {});
    }

    if (refreshTokenValue != null) {
        refreshToken = refreshTokenValue;
    }
    http:Request refreshTokenRequest = {};
    http:Response refreshTokenResponse = {};
    string accessTokenFromRefreshTokenReq;
    json accessTokenFromRefreshTokenJSONResponse;
    string base64encodedString = clientId + ":" + clientSecret;
    base64encodedString = util:base64Encode(base64encodedString);
    base64encodedString = "Basic " + base64encodedString;
    refreshTokenRequest.setHeader("Authorization", base64encodedString);
    accessTokenFromRefreshTokenReq = refreshTokenPath + "?grant_type=refresh_token&" + "refresh_token=" + refreshToken;
    println(accessTokenFromRefreshTokenReq);
    refreshTokenResponse, e = refreshTokenHTTPEP.post(accessTokenFromRefreshTokenReq, refreshTokenRequest);
    accessTokenFromRefreshTokenJSONResponse = refreshTokenResponse.getJsonPayload();
    accessToken = accessTokenFromRefreshTokenJSONResponse.access_token.toString();
    refreshTokenValue = accessTokenFromRefreshTokenJSONResponse.refresh_token.toString();
    request.setHeader("Authorization", "Bearer " + accessToken);

    return accessToken;
}