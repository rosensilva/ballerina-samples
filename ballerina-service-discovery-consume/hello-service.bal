import ballerina.net.http;

@http:configuration {port:9091}
service<http> helloService {
    @http:resourceConfig {
        path:"/"
    }
    resource sayHello (http:Request req, http:Response res) {
        res.setStringPayload("Hello, World!");
        _ = res.send();
    }
}
