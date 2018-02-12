package employeeService.util.db;

import ballerina.config;
import ballerina.data.sql;
import ballerina.log;

sql:ClientConnector sqlConnection;

public function initializeDatabase () (boolean) {
    string dbHost = config:getGlobalValue("DATABASE_HOST");
    string dbPort = config:getGlobalValue("DATABASE_PORT");
    string userName = config:getGlobalValue("DATABASE_USERNAME");
    string password = config:getGlobalValue("DATABASE_PASSWORD");
    string dbName = config:getGlobalValue("DATABASE_NAME");
    var dbPortNumber, portError = <int>dbPort;
    error initializationError;
    // Check for port number error and return initialization false if error present
    if (portError != null) {
        initializationError = {msg:"Invalid port number given in ballerina config file"};
        throw initializationError;
    }
    try {
        // Create custom URL to create Database
        string dbURL = "jdbc:mysql://" + dbHost + ":" + dbPort + "/";
        // Create database by invoking createDatabase function
        createDatabase(userName, password, dbName, dbURL);
        dbName = dbName + "?useSSL=false";
        // Initialize the globally defined 'sqlConnection' SQL Client Connector
        sqlConnection = create sql:ClientConnector(sql:DB.MYSQL, dbHost, dbPortNumber, dbName, userName, password,
                                                   {maximumPoolSize:5});
        // Create the employee database table by invoking createTable function
        createTable();
    }
    catch (error err) {
        initializationError = {msg:"Database Initialization Error : " + err.msg};
        throw initializationError;
    }
    return true;
}

public function createDatabase (string userName, string password, string dbName, string dbURL) {
    endpoint<sql:ClientConnector> employeeDB {
        create sql:ClientConnector(sql:DB.GENERIC, "", 0, "", userName, password, {url:dbURL});
    }
    string sqlQueryString = "CREATE DATABASE IF NOT EXISTS " + dbName;
    // Create Database by invoking update action defined in ballerina sql connector
    int updateStatus = employeeDB.update(sqlQueryString, null);
    log:printInfo("Database creation status:" + updateStatus);
}

public function createTable () {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    // Create table by invoking update action defined in ballerina sql connector
    int updateStatus = employeeDataBase.update("CREATE TABLE IF NOT EXISTS EMPLOYEES (EmployeeID INT AUTO_INCREMENT,
                            Name VARCHAR(50) , Age INT, SSN INT,
                            PRIMARY KEY (EmployeeID))", null);
    log:printInfo("Table creation status:" + updateStatus);
}

public function insertData (string name, string age, string ssn) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    string sqlString = "INSERT INTO EMPLOYEES (Name, Age, SSN) VALUES ('" + name + "','" + age + "','" + ssn + "')";
    // Insert data to SQL database by invoking update action defined in ballerina sql connector
    int updateStatus = employeeDataBase.update(sqlString, null);
    log:printInfo("Data insertion to table status:" + updateStatus);
}

public function updateData (string name, string age, string ssn, string employeeID) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    string sqlString = "UPDATE EMPLOYEES SET Name = '" + name + "', Age = '" + age + "', SSN = '" + ssn + "'WHERE
                        EmployeeID  = '" + employeeID + "'";
    // Update existing data by invoking update action defined in ballerina sql connector
    int updateStatus = employeeDataBase.update(sqlString, null);
    log:printInfo("Data update to table status:" + updateStatus);
}

public function deleteData (string employeeID) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    string sqlString = "DELETE FROM EMPLOYEES WHERE EmployeeID = '" + employeeID + "'";
    // Delete existing data by invoking update action defined in ballerina sql connector
    int updateStatus = employeeDataBase.update(sqlString, null);
    log:printInfo("Data delete status:" + updateStatus);
}

public function retrieveAllData () (json) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    // Retrieve data by invoking call action defined in ballerina sql connector
    var dataTable = employeeDataBase.call("SELECT * FROM EMPLOYEES;", null, null);
    var jsonReturnValue, dataTableCastError = <json>dataTable;
    // Check for errors while casting retrieved data from Data Table to JSON format
    if (dataTableCastError != null) {
        log:printError("SQL data casting failed due to : " + dataTableCastError.msg);
        json jsonError = {"Error ":dataTableCastError.msg};
        return jsonError;
    }
    return jsonReturnValue;
}

public function retrieveById (string employeeID) (json) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    string sqlString = "SELECT * FROM EMPLOYEES WHERE EmployeeID = '" + employeeID + "'";
    // Retrieve all data by invoking call action defined in ballerina sql connector
    var dataTable = employeeDataBase.call(sqlString, null, null);
    var jsonReturnValue, dataTableCastError = <json>dataTable;
    // Check for errors while casting retrieved data from Data Table to JSON format
    if (dataTableCastError != null) {
        log:printError("SQL data casting failed due to : " + dataTableCastError.msg);
        json jsonError = {"Error ":dataTableCastError.msg};
        return jsonError;
    }
    return jsonReturnValue;
}