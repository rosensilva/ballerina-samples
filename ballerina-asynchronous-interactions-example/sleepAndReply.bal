import ballerina.net.http;
import ballerina.log;

int globalRequestCounter;


service<http> sleep_and_wakeup {
    @http:resourceConfig {
        methods:["GET"],
        path:"/"
    }

    resource getNumberResource (http:Request req, http:Response res) {
        int hour;
        int minute;
        int second;
        int milliSecond;
        string startTime;
        string endTime;
        globalRequestCounter = globalRequestCounter + 1;

        Time time = currentTime();
        hour, minute, second, milliSecond = time.getTime();
        startTime = "Time: " + <string>hour + ":" + <string>minute + ":" + <string>second;
        log:printInfo("Serving Reqest No: " + globalRequestCounter + " Start Time :" + startTime);

        map params = req.getQueryParams();
        var sleeptime, _ = (string)params.sleeptime;
        var slpTime, _ = <int>sleeptime;
        sleep(slpTime * 1000);//sleep the current request for sleeptime query parameter seconds

        time = currentTime();
        hour, minute, second, milliSecond = time.getTime();
        endTime = "Time: " + <string>hour + ":" + <string>minute + ":" + <string>second;
        log:printInfo("Serving Reqest No: " + globalRequestCounter + " End Time :" + endTime);


        json responseJson = {"Start Time":startTime, "End Time":endTime, "Sleep Time(seconds)":sleeptime, "Wake Up":"Yes", "Service Number":globalRequestCounter};
        res.setJsonPayload(responseJson);//send back the response with time information of the service execution
        _ = res.send();
    }
}
