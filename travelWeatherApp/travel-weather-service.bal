import ballerina.log;
import ballerina.net.http;
import weather.util as weatherUtil;

service<http> travel {
    @http:resourceConfig {
        methods:["GET"]
    }
    resource weather (http:Request req, http:Response res) {

        try {
            map params = req.getQueryParams();
            var start, startLocationError = (string)params.start;
            var end, endLocationError = (string)params.end;
            var waypointString, waypointError = (string)params.waypoints;
            //convert waypoints string to integer
            var waypoints, intConversionError = <int>waypointString;
            //check for request errors
            if (startLocationError != null || endLocationError != null || waypointError != null ||
                intConversionError != null || waypoints <= 0) {
                res.setStringPayload("Error : something wrong with the data you entered");
                res.setStatusCode(400);
                _ = res.send();
                return;
            }

            log:printInfo("Request -> start : " + start + " end : " + end + "waypoints : " + waypoints);
            var responseJson, err = weatherUtil:getWeatherSummery(start, end, waypoints);
            if (err != null) {
                res.setStatusCode(500);
                res.setStringPayload("Error : " + err.msg);
                _ = res.send();
                return;
            }
            res.setJsonPayload(responseJson);
            _ = res.send();
            log:printInfo("Completed request for trip from : " + start + " to " + end);
        }

        catch (error err) {
            log:printError("error log with cause" + err.msg);
            res.setStatusCode(500);
            res.setJsonPayload({error:err.msg});
            _ = res.send();
        }
    }
}