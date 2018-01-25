package connectors;

import ballerina.net.http;
import ballerina.util;
import ballerina.config;
import ballerina.log;

string appid = config:getGlobalValue("openweather_appid");

public connector openweatherConnector () {

    action getWeatherFromCoordinates (string longitude, string latitude) (json) {
        endpoint<http:HttpClient> httpEndpoint {
            create http:HttpClient("http://api.openweathermap.org/data/2.5/weather", {});
        }
        string appID = appid;
        http:Request request = {};
        http:Response response = {};

        string getRequest = "/?lat=" + latitude + "&lon=" + longitude + "&appid=" + appID;
        response, _ = httpEndpoint.get(getRequest, request);

        json responseJsonWeather = response.getJsonPayload();
        json jsonResult = {Name:responseJsonWeather.name, Main:responseJsonWeather.weather[0].main,
                              temperature:responseJsonWeather.main.temp, humidity:responseJsonWeather.main.humidity};
        return jsonResult;
    }

    action getCoordinatesFromCity (string location) (json) {
        endpoint<http:HttpClient> httpEndpoint {
            create http:HttpClient("http://api.openweathermap.org/data/2.5/weather", {});
        }
        string appID = appid;
        http:Request request = {};
        http:Response response = {};
        string getRequest = "/?q=" + location + "&appid=" + appID;

        response, _ = httpEndpoint.get(getRequest, request);
        json responseJsonWeather = response.getJsonPayload();
        json longitude = responseJsonWeather.coord.lon;
        json latitude = responseJsonWeather.coord.lat;
        json coordinates = {lon:longitude, lat:latitude};
        return coordinates;
    }
}