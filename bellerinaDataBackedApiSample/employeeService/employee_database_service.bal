package employeeService;

import ballerina.net.http;
import employeeService.util.db as dataBaseUtil;

service<http> records {

    //string dbHost = config:getGlobalValue("DATABASE_HOST");
    //string dbPort = config:getGlobalValue("DATABASE_PORT");
    //string userName = config:getGlobalValue("DATABASE_USERNAME");
    //string password = config:getGlobalValue("DATABASE_PASSWORD");
    //string dbName = config:getGlobalValue("DATABASE_NAME");

    string dbHost = "localhost";
    string dbPort = "3306";
    string userName = "root";
    string password = "qwe123";
    string dbName = "RECORDS";

    boolean isInitialized = dataBaseUtil:initializeDatabase(dbHost, dbPort, userName, password, dbName);

    @http:resourceConfig {
        methods:["POST"],
        path:"/employee/"
    }
    resource addEmployeeResource (http:Connection conn, http:InRequest req) {
        http:OutResponse res = {};
        // Processing request payload
        json payload = req.getJsonPayload();
        var name, nameError = (string)payload.name;
        var age, ageError = (string)payload.age;
        var ssn, ssnError = (string)payload.ssn;
        // Check query parameter errors and send bad request response if errors present
        if (nameError != null || ageError != null || ssnError != null) {
            res.setStringPayload("Error : Please check the input parameters ");
            res.statusCode = 400;
            _ = conn.respond(res);
            return;
        }
        // Invoke insertData function in dataBaseUtil package to store data in MySQL database
        json updateStatus = dataBaseUtil:insertData(name, age, ssn);
        json responseJson = {"Name":name, "Age":age, "SSN":ssn, "Details":updateStatus};
        //log:printInfo("New employee added to database : " + responseJson.toString());
        res.setJsonPayload(responseJson);
        // Send the response back to the client
        _ = conn.respond(res);
    }

    @http:resourceConfig {
        methods:["PUT"],
        path:"/employee/"
    }
    resource updateEmployeeResource (http:Connection conn, http:InRequest req) {
        http:OutResponse res = {};
        // Processing request payload
        json payload = req.getJsonPayload();
        var name, nameError = (string)payload.name;
        var age, ageError = (string)payload.age;
        var ssn, ssnError = (string)payload.ssn;
        var id, idError = (string)payload.id;
        // Check query parameter errors and sending bad request response if errors present
        if (nameError != null || ageError != null || ssnError != null || idError != null) {
            res.setStringPayload("Error : Please check the input parameters ");
            res.statusCode = 400;
            _ = conn.respond(res);
            return;
        }
        // Invoke updateData function in dataBaseUtil package to update data in mysql database
        string updateStatus = dataBaseUtil:updateData(name, age, ssn, id);
        json responseJson = {"Name":name, "Age":age, "ssn":ssn, "id":id, "Update Status":updateStatus};
        //        log:printInfo("Employee details updated in database : " + responseJson.toString());
        res.setJsonPayload(responseJson);
        // Send the response back to the client
        _ = conn.respond(res);
    }

    @http:resourceConfig {
        methods:["DELETE"],
        path:"/employee/"
    }
    resource deleteEmployeeResource (http:Connection conn, http:InRequest req) {
        http:OutResponse res = {};
        // Processing request payload
        json payload = req.getJsonPayload();
        var id, idError = (string)payload.id;
        // Check query parameter errors and sending bad request response if errors present
        if (idError != null) {
            res.setStringPayload("Error : Please check the input parameters ");
            res.statusCode = 400;
            _ = conn.respond(res);
            return;
        }
        // Invoke deleteData function in dataBaseUtil package to delete data from mysql database
        string updateStatus = dataBaseUtil:deleteData(id);
        json responseJson = {"Employee ID":id, "Update Status":updateStatus};
        //        log:printInfo("Employee deleted from database : " + responseJson.toString());
        res.setJsonPayload(responseJson);
        // Send the response back to the client
        _ = conn.respond(res);
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/employee/"
    }
    resource retrieveEmployeeResource (http:Connection conn, http:InRequest req) {
        http:OutResponse res = {};
        // Processing request payload
        map params = req.getQueryParams();
        var id, idError = (string)params.id;
        // Check query parameter errors and sending bad request response if errors present
        if (idError != null) {
            res.setStringPayload("Error : Please check the input parameters ");
            res.statusCode = 400;
            _ = conn.respond(res);
            return;
        }
        // Invoke retrieveById function in dataBaseUtil package to retrieve employee data from mysql database
        json result = dataBaseUtil:retrieveById(id);
        res.setJsonPayload(result);
        // Send the response back to the client
        _ = conn.respond(res);
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/retrieve-all/"
    }
    resource retrieveAllResource (http:Connection conn, http:InRequest req) {
        http:OutResponse res = {};
        // Invoke retrieveAllData function in dataBaseUtil package to retrieve all employees from mysql database
        json result = dataBaseUtil:retrieveAllData();
        res.setJsonPayload(result);
        // Send the response back to the client
        _ = conn.respond(res);
    }
}