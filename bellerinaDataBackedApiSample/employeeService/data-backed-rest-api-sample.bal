package employeeService;

import ballerina.log;
import ballerina.net.http;
import employeeService.util.db as dataBaseUtil;


service<http> company {

    boolean isInitialized = dataBaseUtil:initializeDatabase();

    @http:resourceConfig {
        methods:["POST"],
        path:"/employee/"
    }
    resource addEmployeeResource (http:Request req, http:Response res) {
        // Processing request payload
        json payload = req.getJsonPayload();
        var name, nameError = (string)payload.name;
        var age, ageError = (string)payload.age;
        var ssn, ssnError = (string)payload.ssn;
        // Check query parameter errors and send bad request response if errors present
        if (nameError != null || ageError != null || ssnError != null) {
            res.setStringPayload("Error : Please check the input parameters ");
            res.setStatusCode(400);
            _ = res.send();
            return;
        }
        // Invoke insertData function in dataBaseUtil package to store data in MySQL database
        dataBaseUtil:insertData(name, age, ssn);
        json responseJson = {"Name":name, "Age":age, "ssn":ssn};
        log:printInfo("New employee added to database : " + responseJson.toString());
        res.setJsonPayload(responseJson);
        // Send the response back to the client
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["PUT"],
        path:"/employee/"
    }
    resource updateEmployeeResource (http:Request req, http:Response res) {
        // Processing request payload
        json payload = req.getJsonPayload();
        var name, nameError = (string)payload.name;
        var age, ageError = (string)payload.age;
        var ssn, ssnError = (string)payload.ssn;
        var id, idError = (string)payload.id;
        // Check query parameter errors and sending bad request response if errors present
        if (nameError != null || ageError != null || ssnError != null || idError != null) {
            res.setStringPayload("Error : Please check the input parameters ");
            res.setStatusCode(400);
            _ = res.send();
            return;
        }
        // Invoke updateData function in dataBaseUtil package to update data in mysql database
        dataBaseUtil:updateData(name, age, ssn, id);
        json responseJson = {"Name":name, "Age":age, "ssn":ssn, "id":id};
        log:printInfo("Employee details updated in database : " + responseJson.toString());
        res.setJsonPayload(responseJson);
        // Send the response back to the client
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["DELETE"],
        path:"/employee/"
    }
    resource deleteEmployeeResource (http:Request req, http:Response res) {
        // Processing request payload
        json payload = req.getJsonPayload();
        var id, idError = (string)payload.id;
        // Check query parameter errors and sending bad request response if errors present
        if (idError != null) {
            res.setStringPayload("Error : Please check the input parameters ");
            res.setStatusCode(400);
            _ = res.send();
            return;
        }
        // Invoke deleteData function in dataBaseUtil package to delete data from mysql database
        dataBaseUtil:deleteData(id);
        json responseJson = {"Employee ID":id, "Status":"Deleted"};
        log:printInfo("Employee deleted from database : " + responseJson.toString());
        res.setJsonPayload(responseJson);
        // Send the response back to the client
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/employee/"
    }
    resource retrieveEmployeeResource (http:Request req, http:Response res) {
        // Processing request payload
        map params = req.getQueryParams();
        var id, idError = (string)params.id;
        // Check query parameter errors and sending bad request response if errors present
        if (idError != null) {
            res.setStringPayload("Error : Please check the input parameters ");
            res.setStatusCode(400);
            _ = res.send();
            return;
        }
        // Invoke retrieveById function in dataBaseUtil package to retrieve employee data from mysql database
        json result = dataBaseUtil:retrieveById(id);
        res.setJsonPayload(result);
        // Send the response back to the client
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/retrieve-all/"
    }
    resource retrieveAllResource (http:Request req, http:Response res) {
        // Invoke retrieveAllData function in dataBaseUtil package to retrieve all employees from mysql database
        json result = dataBaseUtil:retrieveAllData();
        res.setJsonPayload(result);
        // Send the response back to the client
        _ = res.send();
    }
}