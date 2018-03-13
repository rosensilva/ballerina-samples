package weatherservice;

import ballerina.math;
import ballerina.net.http;

@http:configuration {basePath:"/weather"}
service<http> weatherService {

    @http:resourceConfig {
        methods:["POST"],
        path:"/summary"
    }
    resource weatherSummaryResource (http:Connection httpConnection, http:InRequest request) {
        // Initialize the response message that needs to send back to client
        http:OutResponse response = {};
        // Extract the data as the request JSON payload
        json requestData = request.getJsonPayload();
        // Prepare dummy weather data
        json responseJson = {
                                "city":requestData.city,
                                "time":requestData.time,
                                "temperature(*C)":math:randomInRange(20, 40),
                                "humidity(%)":math:randomInRange(60, 100),
                                "windSpeed(mph)":math:randomInRange(15, 25)
                            };
        response.setJsonPayload(responseJson);
        // Send the response to the client
        _ = httpConnection.respond(response);
    }
}
