package weather.util;
import connectors as conn;

public function getWeatherSummery (string start, string end, int waypoints) (json) {
    endpoint<conn:openwatherConnector> openWeatherEP {
        create conn:openwatherConnector();
    }

    json startCoord = openWeatherEP.getCoordinatesFromCity(start);
    json endCoord = openWeatherEP.getCoordinatesFromCity(end);

    var startLo = startCoord.lon.toString();
    var startLa = startCoord.lat.toString();

    var endLo = endCoord.lon.toString();
    var endLa = endCoord.lat.toString();

    var startLon, _ = <float>startLo;
    var startLat, _ = <float>startLa;
    var endLon, _ = <float>endLo;
    var endLat, _ = <float>endLa;

    float lonDiff = (endLon - startLon) / waypoints;
    float latDiff = (endLat - startLat) / waypoints;

    int i = 0;
    json finalResult = {};
    while (i < waypoints + 1) {
        float tmpLon = startLon + lonDiff * i;
        float tmpLat = startLat + latDiff * i;
        i = i + 1;
        json result = openWeatherEP.getWeatherFromCoordinates(<string>tmpLon, <string>tmpLat);
        finalResult[result.Name.toString()] = result;
    }

    return finalResult;
}