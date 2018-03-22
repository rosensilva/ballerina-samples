import ballerina.net.http;
import ballerina.mime;
import ballerina.file;@http:configuration {basePath:"/foo", port:9092}
service<http> echo {
    @http:resourceConfig {
        methods:["POST"],
        path:"/multiparts"
    }
    resource echo (http:Connection conn, http:InRequest req) {
        endpoint<http:HttpClient> httpEndpoint {
            create http:HttpClient("http://localhost:9090", {});
        }
        mime:Entity topLevelEntity = {};
        mime:MediaType mediaType = mime:getMediaType(mime:MULTIPART_FORM_DATA);
        topLevelEntity.contentType = mediaType;
        mime:Entity xmlBodyPart = {};
        xmlBodyPart.xmlData = xml `<name>Ballerina</name>`;
        mime:MediaType contentType = mime:getMediaType(mime:APPLICATION_XML);
        xmlBodyPart.contentType = contentType;
        xmlBodyPart.name="xml part";
        mime:Entity xmlFilePart = {};
        mime:MediaType contentTypeOfFilePart = mime:getMediaType(mime:APPLICATION_XML);
        xmlFilePart.contentType = contentTypeOfFilePart;
        file:File content = {path:"/home/rosen/Downloads/mailFilters.xml"};
        xmlFilePart.overflowData = content;
        xmlFilePart.name="file part";
        mime:Entity jsonBodyPart = {};
        jsonBodyPart.jsonData = "{'name':'wso2'}";
        mime:MediaType contentTypeOfJsonPart = mime:getMediaType(mime:APPLICATION_JSON);
        jsonBodyPart.contentType = contentTypeOfJsonPart;
        jsonBodyPart.name="json part";
        mime:Entity[] bodyParts = [xmlBodyPart, xmlFilePart, jsonBodyPart];
        topLevelEntity.multipartData =bodyParts;
        http:OutRequest request = {};
        request.setEntity(topLevelEntity);
        http:InResponse resp1 = {};
        resp1, _ = httpEndpoint.post("/foo/receivableParts", request);
        _ = conn.forward(resp1);
    }
}