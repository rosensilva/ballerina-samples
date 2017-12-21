package connectors;

import ballerina.net.http;
import ballerina.util;
import ballerina.config;
import ballerina.log;


string appid = config:getGlobalValue("openweather_appid");


public connector openwatherConnector(){

	action getWeatherFromCoordinates(string longitude, string latitude) ( json ) {
	    endpoint<http:HttpClient> httpEndpoint {
	        create http:HttpClient("http://api.openweathermap.org/data/2.5/weather", {});
	    }   
	    
	    string appID = appid;
	    http:Request req = {};
	    http:Response resp = {};

	    string getRequest = "/?lat="+latitude+"&lon="+longitude+"&appid="+ appID;
	    resp, _ = httpEndpoint.get(getRequest, req);
	    
	    json responseJsonWeather = resp.getJsonPayload();
	   	json jsonResult = {Name:responseJsonWeather.name, Main:responseJsonWeather.weather[0].main, temperature:responseJsonWeather.main.temp, humidity:responseJsonWeather.main.humidity};
		
		return jsonResult;

	}

	action getCoordinatesFromCity(string location) ( json ){
		endpoint<http:HttpClient> httpEndpoint {
	        create http:HttpClient("http://api.openweathermap.org/data/2.5/weather", {});
	    }

	    string appID = appid;
	    http:Request req = {};
	    http:Response resp = {};

	    string getRequest = "/?q="+location+"&appid="+ appID;
	    resp, _ = httpEndpoint.get(getRequest, req);
	    
	    json responseJsonWeather = resp.getJsonPayload();
	    
	    json longitude = responseJsonWeather.coord.lon;
	    json latitude = responseJsonWeather.coord.lat;

	  	json coordiantes = {lon:longitude, lat:latitude};
	  	return coordiantes;

	}
}

