package employeeService;

import ballerina.net.http;
import employeeService.db.util as dataBaseUtil;

boolean isFirstTime = true;

service<http> company {
    @http:resourceConfig {
        methods:["POST"],
        path:"/employee/"
    }

    resource addEmployeeDataResource (http:Request req, http:Response res) {
        if (isFirstTime) {
            dataBaseUtil:initializeDatabase();
        }
        isFirstTime = false;
        map params = req.getQueryParams();
        var name, _ = (string)params.name;
        var age, _ = (string)params.age;
        var ssn, _ = (string)params.ssn;
        dataBaseUtil:insertData(name, age, ssn);
        //employeeDB.createTable();
        //employeeDB.insertData(name, age, ssn);

        json responseJson = {"Name":name, "Age":age, "ssn":ssn};
        res.setJsonPayload(responseJson);
        _ = res.send();
    }
    @http:resourceConfig {
        methods:["PATCH"],
        path:"/employee/"
    }

    resource updateEmployeeDataResource (http:Request req, http:Response res) {
        map params = req.getQueryParams();
        var name, _ = (string)params.name;
        var age, _ = (string)params.age;
        var ssn, _ = (string)params.ssn;
        var id, _ = (string)params.id;
        dataBaseUtil:updateData(name, age, ssn, id);
        //employeeDB.createTable();
        //employeeDB.insertData(name, age, ssn);

        json responseJson = {"Name":name, "Age":age, "ssn":ssn};
        res.setJsonPayload(responseJson);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["DELETE"],
        path:"/employee/"
    }
    resource deleteEmployeeDataResource (http:Request req, http:Response res) {

        map params = req.getQueryParams();
        var employeeID, _ = (string)params.id;
        dataBaseUtil:deleteData(employeeID);
        //employeeDB.deleteData(employeeID);

        json responseJson = {"Employee ID":employeeID, "Status":"Deleted"};
        res.setJsonPayload(responseJson);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/employee/"
    }
    resource retrieveEmployeeDataResource (http:Request req, http:Response res) {

        map params = req.getQueryParams();
        var employeeID, _ = (string)params.id;

        json result = dataBaseUtil:retrieveById(employeeID);

        res.setJsonPayload(result);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/retrieve-all/"
    }
    resource retrieveAllDataResource (http:Request req, http:Response res) {

        json result = dataBaseUtil:retrieveAllData();

        res.setJsonPayload(result);
        _ = res.send();
    }
}
