package taskscheduler;

import ballerina.log;
import ballerina.net.http;
import ballerina.task;
import ballerina.time;

public function main (string[] args) {

    // Initialize the functions needed for task scheduler
    function () returns (error) onTriggerFunction;
    function (error e) onErrorFunction;
    // Assign the functions for on trigger and on error
    onTriggerFunction = getWeatherSummary;
    onErrorFunction = taskSchedulerError;
    // Schedule the tasks using scheduleAppointment function
    // Provide onTrigger function and onError functions as first two arguments
    // Finally pass the task execution intervals as Cron syntax
    // The syntax "0/20 * * * * ?' means that the task should run every 20 seconds
    _, _ = task:scheduleAppointment(onTriggerFunction, onErrorFunction,
                                    "0/20 * * * * ?");
}

function getWeatherSummary () returns (error) {
    endpoint<http:HttpClient> weatherEndpoint {
        create http:HttpClient("http://localhost:9090/weather", {});
    }

    log:printInfo("Calling weather service endpoint...");
    // Initialize the requests and responses
    http:OutRequest outRequest = {};
    http:InResponse inResponse = {};
    http:HttpConnectorError weatherServiceError;
    // Get the current system time
    time:Time time = time:currentTime();
    // Build a time string
    string timeString = string `{{time.hour()}}:{{time.minute()}}:{{time.second()}}`;
    // Set the request payload to send to the remote weather service
    json requestJsonPayload = {"city":"London", "time":timeString};
    outRequest.setJsonPayload(requestJsonPayload);
    // Call the remote weather service
    inResponse, weatherServiceError = weatherEndpoint.post("/summary", outRequest);
    if (weatherServiceError == null) {
        // Print the weather update
        log:printInfo(inResponse.getJsonPayload().toString());
    }
    return (error)weatherServiceError;
}

function taskSchedulerError (error e) {
    // Log the error if getWeatherSummary returns an error
    log:printErrorCause("[ERROR]", e);
}
