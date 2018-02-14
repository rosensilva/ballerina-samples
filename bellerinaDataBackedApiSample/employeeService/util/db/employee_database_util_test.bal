package employeeService.util.db;

import ballerina.data.sql;
import ballerina.test;

function beforeTest () {
    string dbHost = "localhost";
    string dbPort = "3306";
    string userName = "root";
    string password = "qwe123";
    string dbName = "TEST";

    _ = initializeDatabase(dbHost, dbPort, userName, password, dbName);
}

function executeSqlQuery (string sqlQueryString) (table) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    var sqlReturnValue = employeeDataBase.call(sqlQueryString, null, null);
    return sqlReturnValue;
}

function testCreateDatabase () {
    string dbHost = "localhost";
    string dbPort = "3306";
    string userName = "root";
    string password = "qwe123";
    string dbName = "EMPLOYEE";
    string dbURL = "jdbc:mysql://" + dbHost + ":" + dbPort + "/";
    _ = createDatabase(userName, password, dbName, dbURL);
    string sqlQueryString = "SHOW DATABASES LIKE '" + dbName + "'";
    var result = executeSqlQuery(sqlQueryString);
    test:assertTrue(result.hasNext(), "Error : Database not created");
}

public function testCreateTable () {
    _ = createTable();
    string sqlQueryString = "SHOW TABLES LIKE 'EMPLOYEES'";
    var result = executeSqlQuery(sqlQueryString);
    test:assertTrue(result.hasNext(), "Error : Table not created");
}

public function testInsertData () {
    string updateStatus = insertData("Test Case 1", "11", "111111111");
    test:assertStringEquals(updateStatus, UPDATED, "insertData function failed");
}

public function testRetrieveAllData () {
    json existingData = retrieveAllData();
    test:assertTrue(lengthof existingData > 0, "retrieveAllData function failed");
}

public function testRetrieveById () {
    json existingData = retrieveAllData();
    var employeeIDa = existingData[0].EmployeeID.toString();
    json employeeData = retrieveById(employeeIDa);
    test:assertTrue(lengthof employeeData > 0, "retrieveById function failed");
}

public function testUpdateData () {
    json existingData = retrieveAllData();
    var employeeID = existingData[0].EmployeeID.toString();
    string updateStatus = updateData("Updated Test", "22", "222222222", employeeID);
    test:assertStringEquals(updateStatus, UPDATED, "updateData function failed");
}

public function testDeleteData () {
    json existingData = retrieveAllData();
    var employeeID = existingData[0].EmployeeID.toString();
    string updateStatus = deleteData(employeeID);
    test:assertStringEquals(updateStatus, UPDATED, "deleteData function failed");
}

function afterTest () {
    string sqlQueryString = "DROP DATABASE TEST";
    _ = executeSqlQuery(sqlQueryString);
}
