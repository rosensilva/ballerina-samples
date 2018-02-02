package weather.util;

import connectors as conn;

public function getWeatherSummery (string start, string end, int waypoints) (json, error) {
    endpoint<conn:openweatherConnector> openWeatherEP {
        create conn:openweatherConnector();
    }
    error err;
    json finalResult = {};
    var startCoordinates, err1 = openWeatherEP.getCoordinatesFromCity(start);
    var endCoordinates, err2 = openWeatherEP.getCoordinatesFromCity(end);
    if (err1 != null || err2 != null) {
        err = {msg:"Error occured while getting coordinates from city name"};
        return finalResult, err;
    }
    var startLongitudeString = startCoordinates.lon.toString();
    var startLatitudeString = startCoordinates.lat.toString();
    var endLongitudeString = endCoordinates.lon.toString();
    var endLatitudeString = endCoordinates.lat.toString();

    var startLongitude, _ = <float>startLongitudeString;
    var startLatitude, _ = <float>startLatitudeString;
    var endLongitude, _ = <float>endLongitudeString;
    var endLatitude, _ = <float>endLatitudeString;

    float longitudeDiff = (endLongitude - startLongitude) / waypoints;
    float latitudeDiff = (endLatitude - startLatitude) / waypoints;

    int i = 0;
    //retrieve weather details about all the locations between start and end
    while (i < waypoints + 1) {
        float tmpLon = startLongitude + longitudeDiff * i;
        float tmpLat = startLatitude + latitudeDiff * i;
        i = i + 1;
        var result, err3 = openWeatherEP.getWeatherFromCoordinates(<string>tmpLon, <string>tmpLat);
        if (err3 != null) {
            err = {msg:"Error occured while getting weather details from coordinates"};
            return finalResult, err;
        }
        finalResult[result.Name.toString()] = result;
    }
    return finalResult, err;
}