import ballerina.net.http;
import util as phonebook;
import ballerina.log;

service<http> phonebook {
    @http:resourceConfig {
        methods:["GET"],
        path:"/number/{name}"
    }
    resource getNumberResource (http:Request req, http:Response res, string name) {
        string result = phonebook:getContact(name);
        json responseJson = {"Name":name, "Number":result};
        res.setJsonPayload(responseJson);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/number/"
    }
    resource saveContactResource (http:Request req, http:Response res) {
        map params = req.getQueryParams();
        var name, err1 = (string)params.name;
        var num, err2 = (string)params.number;
        string statusMsg = "";
        int status = phonebook:saveContact(name, num);
        if (status == 0) {
            statusMsg = "Save Operation Success";
        }
        else {
            statusMsg = "Save Operation Failed";
        }
        json responseJson = {"Status":statusMsg, "Name":name, "Number":num};
        res.setJsonPayload(responseJson);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["PATCH"],
        path:"/number/"
    }
    resource changeNumberResource (http:Request req, http:Response res) {
        map params = req.getQueryParams();
        var name, _ = (string)params.name;
        var num, _ = (string)params.number;
        string statusMsg = "";
        int status = phonebook:changeNumber(name, num);
        if (status == 0) {
            statusMsg = "Change Operation Success";
        }
        else {
            statusMsg = "Change Operation Failed";
        }
        json responseJson = {"Status":statusMsg, "Name":name, "Number":num};
        res.setJsonPayload(responseJson);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["DELETE"],
        path:"/number/"
    }
    resource deleteNumberResource (http:Request req, http:Response res) {
        map params = req.getQueryParams();
        var name, _ = (string)params.name;
        string statusMsg = "";
        int status = phonebook:deleteContact(name);
        if (status == 0) {
            statusMsg = "Delete Operation success";
        }
        else {
            statusMsg = "Delete Operation failed";
        }
        json responseJson = {"Status":statusMsg, "Name":name};
        res.setJsonPayload(responseJson);
        _ = res.send();
    }
}
