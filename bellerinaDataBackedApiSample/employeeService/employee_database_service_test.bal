package employeeService;

import ballerina.data.sql;
import ballerina.net.http;
import ballerina.test;
import employeeService.util.db;


function beforeTest () {

}

function afterTest () {
    // This block runs after finishing all the test cases in current package
    string dbHost = "localhost";
    string dbPort = "3306";
    string userName = "root";
    string password = "qwe123";
    string dbName = "RECORDS";
    _ = db:initializeDatabase(dbHost, dbPort, userName, password, dbName);
    // reset the AUTO_INCREMENT EmployeeID to max row value or to '1' if table is empty
    string sqlQueryString = "ALTER TABLE " + "EMPLOYEES" + " AUTO_INCREMENT = 1";
    _ = executeSqlQuery(sqlQueryString);
}

function testEmployeeDataService () {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:9090/records", {});
    }
    http:OutRequest req = {};
    http:InResponse resp = {};
    string employeeID;
    // Start employee database service
    _ = test:startService("records");

    // Testing add new employee resource
    // Prepare sample employee and set the json payload
    json requestJson = {"name":"Alice", "age":"30", "ssn":"123456789"};
    req.setJsonPayload(requestJson);
    // Send the request to service and get the response
    resp, _ = httpEndpoint.post("/employee", req);
    // Test the responses from the service with the original test data
    test:assertIntEquals(resp.statusCode, 200, "Add new employee resource did not reespond with 200 OK signal");
    test:assertStringEquals(resp.getJsonPayload().Name.toString(), "Alice", "Name did not store in the database");
    // Extract the employeeID of test entry
    json responseJson = resp.getJsonPayload();
    employeeID = responseJson.Details.EmployeeID.toString();


    // Testing retrieve by employee id resource
    // Prepare request with query parameter
    string url = "/employee?id=" + employeeID;
    // Send the request to service and get the response
    resp, _ = httpEndpoint.get(url, req);
    // Test the responses from the service with the original test data
    test:assertIntEquals(resp.statusCode, 200, "Add new employee resource did not reespond with 200 OK signal");
    test:assertStringEquals(resp.getJsonPayload()[0].Name.toString(), "Alice", "recieved employee name not matched");

    // Testing update employee resource
    // Prepare sample employee and set the json payload
    requestJson = {"name":"Alice Updated", "age":"35", "ssn":"123456789", "id":employeeID};
    req.setJsonPayload(requestJson);
    // Send the request to service and get the response
    resp, _ = httpEndpoint.put("/employee", req);
    // Test the responses from the service with the updated test data
    test:assertIntEquals(resp.statusCode, 200, "Add new employee resource did not reespond with 200 OK signal");
    test:assertStringEquals(resp.getJsonPayload().Name.toString(), "Alice Updated", "Name did not store in the database");

    // Testing delete employee resource
    // Prepare delete employee JSON
    requestJson = {"id":employeeID};
    //set the json payload to the request
    req.setJsonPayload(requestJson);
    // Send the request to service and get the response
    resp, _ = httpEndpoint.delete("/employee", req);
    // Test whether the delete operation succeed
    test:assertIntEquals(resp.statusCode, 200, "Add new employee resource did not reespond with 200 OK signal");
    test:assertStringEquals(resp.getJsonPayload()["Update Status"].toString(), "Updated", "delete resource failed");
}

function executeSqlQuery (string sqlQueryString) (table) {
    endpoint<sql:ClientConnector> employeeDataBase {
        db:sqlConnection;
    }
    var sqlReturnValue = employeeDataBase.call(sqlQueryString, null, null);
    return sqlReturnValue;
}