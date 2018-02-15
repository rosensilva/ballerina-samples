package employeeService.util.db;

import ballerina.data.sql;
import ballerina.test;

function beforeTest () {
    string dbHost = "localhost";
    string dbPort = "3306";
    string userName = "root";
    string password = "qwe123";
    string dbName = "TEST_EMPLOYEE_SERVICE";
    _ = initializeDatabase(dbHost, dbPort, userName, password, dbName);
}

function afterTest () {
    string sqlQueryString = "DROP DATABASE TEST_EMPLOYEE_SERVICE";
    _ = executeSqlQuery(sqlQueryString);
}

function testCreateDatabase () {
    string dbHost = "localhost";
    string dbPort = "3306";
    string userName = "root";
    string password = "qwe123";
    string dbName = "EMPLOYEE";
    string dbURL = "jdbc:mysql://" + dbHost + ":" + dbPort + "/?useSSL=false";
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
    json jsonResponse = insertData("Test Case 1", "11", "111111111");
    test:assertStringEquals(jsonResponse.Status.toString(), UPDATED, "insertData function failed");
    string sqlQueryString = "SELECT * FROM EMPLOYEES WHERE Name = 'Test Case 1' AND Age = '11' AND SSN = '111111111'
                            LIMIT 1";
    var result = executeSqlQuery(sqlQueryString);
    test:assertTrue(result.hasNext(), "Cannot find test data in database");
}

public function testRetrieveAllData () {
    string sqlQueryString = "INSERT INTO EMPLOYEES (Name, Age, SSN) VALUES ('Test Case 2','22','222222222')";
    _ = executeSqlQuery(sqlQueryString);
    json existingData = retrieveAllData();
    test:assertTrue(lengthof existingData > 0, "retrieveAllData function failed");
}

public function testRetrieveById () {
    string sqlQueryString = "INSERT INTO EMPLOYEES (Name, Age, SSN) VALUES ('Test Case 3','33','333333333')";
    _ = executeSqlQuery(sqlQueryString);
    sqlQueryString = "SELECT EmployeeID FROM EMPLOYEES WHERE SSN = '333333333'";
    var result = executeSqlQuery(sqlQueryString);
    var jsonResult, _ = <json>result;
    json employeeData = retrieveById(jsonResult[0].EmployeeID.toString());

    test:assertTrue(lengthof employeeData > 0, "retrieveById function failed");
    test:assertStringEquals(employeeData[0].Name.toString(), "Test Case 3", "retrieveById Name not matched");
    test:assertStringEquals(employeeData[0].Age.toString(), "33", "retrieveById Age not matched");
    test:assertStringEquals(employeeData[0].SSN.toString(), "333333333", "retrieveById SSN not matched");
}

public function testUpdateData () {
    string sqlQueryString = "INSERT INTO EMPLOYEES (Name, Age, SSN) VALUES ('Test Case 4','44','444444444')";
    _ = executeSqlQuery(sqlQueryString);
    sqlQueryString = "SELECT EmployeeID FROM EMPLOYEES WHERE SSN = '444444444'";
    var result = executeSqlQuery(sqlQueryString);
    var jsonResult, _ = <json>result;
    string employeeID = jsonResult[0].EmployeeID.toString();
    string updateStatus = updateData("Updated Test", "55", "444444444", employeeID);
    test:assertStringEquals(updateStatus, UPDATED, "updateData function failed");
    sqlQueryString = "SELECT * FROM EMPLOYEES WHERE SSN = '444444444'";
    result = executeSqlQuery(sqlQueryString);
    jsonResult, _ = <json>result;
    test:assertStringEquals(jsonResult[0].Name.toString(), "Updated Test", "Updated Name not matched");
    test:assertStringEquals(jsonResult[0].Age.toString(), "55", "Updated  Age not matched");
}

public function testDeleteData () {
    string sqlQueryString = "INSERT INTO EMPLOYEES (Name, Age, SSN) VALUES ('Test Case 6','66','666666666')";
    _ = executeSqlQuery(sqlQueryString);
    sqlQueryString = "SELECT EmployeeID FROM EMPLOYEES WHERE SSN = '666666666'";
    var result = executeSqlQuery(sqlQueryString);
    var jsonResult, _ = <json>result;
    string employeeID = jsonResult[0].EmployeeID.toString();
    string updateStatus = deleteData(employeeID);
    test:assertStringEquals(updateStatus, UPDATED, "deleteData function failed");
}

function executeSqlQuery (string sqlQueryString) (table) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    var sqlReturnValue = employeeDataBase.call(sqlQueryString, null, null);
    return sqlReturnValue;
}