import ballerina.net.http;
import util as phoneBook;

service<http> phonebook {
    @http:resourceConfig {
        methods:["GET"],
        path:"/number/{name}"
    }
    resource getNumberResource (http:Request req, http:Response res, string name) {
        string contactNumber = phoneBook:getContact(name);
        json responseJson = {"Name":name, "Number":contactNumber};
        res.setJsonPayload(responseJson);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/number/"
    }
    resource saveContactResource (http:Request req, http:Response res) {
        map params = req.getQueryParams();
        var name, nameError = (string)params.name;
        var num, numberError = (string)params.number;

        if (nameError != null || numberError != null) {
            res.setStringPayload("Error : something wrong with the data you entered");
            res.setStatusCode(400);
            _ = res.send();
            return;
        }

        string statusMsg = "Save Operation Failed";
        int status = phoneBook:saveContact(name, num);

        if (status == 0) {
            statusMsg = "Save Operation Success";
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
        var name, nameError = (string)params.name;
        var num, numberError = (string)params.number;

        if (nameError != null || numberError != null) {
            res.setStringPayload("Error : something wrong with the data you entered");
            res.setStatusCode(400);
            _ = res.send();
            return;
        }

        string statusMsg = "";
        int status = phoneBook:changeNumber(name, num);

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
        var name, nameError = (string)params.name;

        if (nameError != null) {
            res.setStringPayload("Error : something wrong with the data you entered");
            res.setStatusCode(400);
            _ = res.send();
            return;
        }

        string statusMsg = "";
        int status = phoneBook:deleteContact(name);

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