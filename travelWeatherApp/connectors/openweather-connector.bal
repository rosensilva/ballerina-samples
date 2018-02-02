package connectors;

import ballerina.config;
import ballerina.net.http;

string appId = config:getGlobalValue("openweather_appid");

public connector openweatherConnector () {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://api.openweathermap.org/data/2.5/weather", {});
    }

    action getWeatherFromCoordinates (string longitude, string latitude) (json, error) {
        string appID = appId;
        json jsonResult;
        error err;
        http:Request request = {};
        http:Response response = {};
        http:HttpConnectorError openWeatherConnectionError;
        //retrieve weather data from calling openweather api
        string getRequestString = "/?lat=" + latitude + "&lon=" + longitude + "&appid=" + appID;
        response, openWeatherConnectionError = httpEndpoint.get(getRequestString, request);
        if (openWeatherConnectionError != null) {
            err = {msg:"error while getting weather by coordinates from openweather"};
            return jsonResult, err;
        }
        //populate result json file with respective weather data received from openweather api
        json responseJsonWeather = response.getJsonPayload();
        jsonResult = {Name:responseJsonWeather.name, Main:responseJsonWeather.weather[0].main,
                         temperature:responseJsonWeather.main.temp, humidity:responseJsonWeather.main.humidity};
        return jsonResult, err;
    }

    action getCoordinatesFromCity (string location) (json, error) {
        string appID = appId;
        error err;
        json coordinates;
        http:Request request = {};
        http:Response response = {};
        http:HttpConnectorError openWeatherConnectionError;
        string getRequest = "/?q=" + location + "&appid=" + appID;
        //get coordinates using city names through openweather api
        response, openWeatherConnectionError = httpEndpoint.get(getRequest, request);
        if (openWeatherConnectionError != null) {
            err = {msg:"error while getting coordinates from city name using openweather"};
            return coordinates, err;
        }
        //return longitude and latitude as a json file
        json responseJsonWeather = response.getJsonPayload();
        json longitude = responseJsonWeather.coord.lon;
        json latitude = responseJsonWeather.coord.lat;
        coordinates = {lon:longitude, lat:latitude};
        return coordinates, err;
    }
}