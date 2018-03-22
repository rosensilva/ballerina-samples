import ballerina.file;
import ballerina.io;
import ballerina.log;
import ballerina.mime;
import ballerina.net.http;

const string filePath = "./files/";

service<http> upload {
    @http:resourceConfig {
        methods:["POST"],
        path:"/files"
    }
    resource uploadHandler (http:Connection conn, http:InRequest req) {
        mime:Entity[] bodyParts = req.getMultiparts();
        foreach part in bodyParts{
            println("-----------------------------");
            print("Content Type : ");
            println(part.contentType.toString());
            println(part.name);
            println("file name printed");
            println("-----------------------------");
            handleContent(part);
        }

        http:OutResponse res = {};
        res.setStringPayload("Multiparts Received!");
        _ = conn.respond(res);
    }
}
function handleContent (mime:Entity bodyPart) {
    string contentType = bodyPart.contentType.toString();
    if (mime:APPLICATION_XML == contentType || mime:TEXT_XML == contentType) {
        //writeToFile(mime:getBlob(bodyPart));
    } else if (mime:APPLICATION_JSON == contentType) {
        println(mime:getJson(bodyPart));
    } else if (mime:TEXT_PLAIN == contentType) {
        println(mime:getText(bodyPart));
    } else if ("application/vnd.ms-powerpoint" == contentType) {
        println("Content saved to file");
    }

    blob blobData = mime:getBlob(bodyPart);
    println(blobData.toString("UTF-8"));
    println("printed blob");
    // writeToFile(blobData, "ABC");
    listAvailableFiles();


}
function writeToFile (blob readContent, string fileName) {
    string dstFilePath = filePath + fileName;
    io:ByteChannel destinationChannel = getByteChannel(dstFilePath, "w");
    int numberOfBytesWritten = destinationChannel.writeBytes(readContent, 0);
    println(numberOfBytesWritten);
}
function getByteChannel (string fileName, string permission) (io:ByteChannel) {
    file:File src = {path:fileName};
    io:ByteChannel channel = src.openChannel(permission);
    return channel;
}

function listAvailableFiles () {
    file:File possibleDir = {path:filePath};

    if (possibleDir.isDirectory()) {
        var filesList, _, _ = possibleDir.list();
        int i = 0;
        while (i < lengthof filesList) {
            println(filesList[i]);
            i = i + 1;
        }
    }
    else {
        log:printError(filePath + " is not a correct directory");
    }
}