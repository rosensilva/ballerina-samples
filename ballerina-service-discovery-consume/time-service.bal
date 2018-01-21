import ballerina.net.http;

@http:configuration {port:9093}
service<http> timeService {
    @http:resourceConfig {
        path:"/"
    }
    resource timeServiceResource (http:Request req, http:Response res) {
        Time time = currentTime();
        var hour, minute, second, _ = time.getTime();
        string timeString = "Time:" + <string>hour + ":" + <string>minute + ":" + <string>second;

        res.setStringPayload(timeString);
        _ = res.send();
    }
}