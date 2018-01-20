package weather.util;
import connectors as conn;

public function getWeatherSummery (string start, string end, int waypoints) (json) {
    endpoint<conn:openweatherConnector> openWeatherEP {
        create conn:openweatherConnector();
    }

    json startCoordinates = openWeatherEP.getCoordinatesFromCity(start);
    json endCoordinates = openWeatherEP.getCoordinatesFromCity(end);
    var startLongitudeString = startCoordinates.lon.toString();
    var startLattitudeString = startCoordinates.lat.toString();
    var endLongitudeString = endCoordinates.lon.toString();
    var endLattitudeString = endCoordinates.lat.toString();

    var startLongitude, _ = <float>startLongitudeString;
    var startLattitude, _ = <float>startLattitudeString;
    var endLongitude, _ = <float>endLongitudeString;
    var endLattitude, _ = <float>endLattitudeString;

    float longitudeDiff = (endLongitude - startLongitude) / waypoints;
    float lattitudeDiff = (endLattitude - startLattitude) / waypoints;

    json finalResult = {};
    int i = 0;
    while (i < waypoints + 1) {
        float tmpLon = startLongitude + longitudeDiff * i;
        float tmpLat = startLattitude + lattitudeDiff * i;
        i = i + 1;
        json result = openWeatherEP.getWeatherFromCoordinates(<string>tmpLon, <string>tmpLat);
        finalResult[result.Name.toString()] = result;
    }
    return finalResult;
}