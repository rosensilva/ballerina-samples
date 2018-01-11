import ballerina.net.http;

@http:configuration {port:9092}
service<http> dateService {
    @http:resourceConfig {
        path:"/"
    }
    resource dateServiceResource (http:Request req, http:Response res) {
        Time time = currentTime();
        var year, month, date = time.getDate();
        string timeString = "Date:" + <string>year + ":" + <string>month + ":" + <string>date;
        res.setStringPayload(timeString);
        _ = res.send();
    }
}
