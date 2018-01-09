import connectors as conn;
import ballerina.net.http;


service<http> employee {
    endpoint<conn:employeeDatabaseConnector> employeeDB {
        create conn:employeeDatabaseConnector();
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/add_employee/"
    }
    resource addEmployeeDataResource (http:Request req, http:Response res) {

        map params = req.getQueryParams();
        var name, _ = (string)params.name;
        var age, _ = (string)params.age;
        var ssn, _ = (string)params.ssn;

        employeeDB.createTable();
        employeeDB.insertData(name, age, ssn);

        json responseJson = {"Name":name, "Age":age, "ssn":ssn};
        res.setJsonPayload(responseJson);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/delete_employee/"
    }
    resource deleteEmployeeDataResource (http:Request req, http:Response res) {

        map params = req.getQueryParams();
        var employeeID, _ = (string)params.id;

        employeeDB.deleteData(employeeID);

        json responseJson = {"Employee ID":employeeID, "Status":"Deleted"};
        res.setJsonPayload(responseJson);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/retrieve_employee/"
    }
    resource retrieveEmployeeDataResource (http:Request req, http:Response res) {

        map params = req.getQueryParams();
        var employeeID, _ = (string)params.id;

        json result = employeeDB.retrieveById(employeeID);

        res.setJsonPayload(result);
        _ = res.send();
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/retrieve_all/"
    }
    resource retrieveAllDataResource (http:Request req, http:Response res) {

        json result = employeeDB.retrieveAllData();

        res.setJsonPayload(result);
        _ = res.send();
    }
}
