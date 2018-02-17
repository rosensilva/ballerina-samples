package employeeService.connectors;

import ballerina.config;
import ballerina.data.sql;
import ballerina.log;

sql:ClientConnector sqlConnection;

public function initializeDatabase () {
    string dbHost = config:getGlobalValue("DATABASE_HOST");
    string dbPort = config:getGlobalValue("DATABASE_PORT");
    string userName = config:getGlobalValue("DATABASE_USERNAME");
    string password = config:getGlobalValue("DATABASE_PASSWORD");
    string dbName = config:getGlobalValue("DATABASE_NAME");
    var dbPortNumber, _ = <int>dbPort;

    string dbUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/";
    createDatabase(userName, password, dbName, dbUrl);
    sqlConnection = create sql:ClientConnector(sql:DB.MYSQL, dbHost, dbPortNumber, dbName, userName, password,
                                               {maximumPoolSize:5});
    createTable ();
}

public function createDatabase (string userName, string password, string dbName, string dbUrl) {
    endpoint<sql:ClientConnector> employeeDB {
        create sql:ClientConnector(sql:DB.GENERIC, "", 0, "", userName, password, {url:dbUrl});
    }
    string sqlQueryString = "CREATE DATABASE " + dbName;
    int ret = testDB.update(sqlQueryString, null);
    println(ret);
}

public function createTable () {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    int returnValue = employeeDataBase.update("CREATE TABLE IF NOT EXISTS EMPLOYEES (employee_Id INT AUTO_INCREMENT,
                            name VARCHAR(50) , age INT, ssn INT,
                            PRIMARY KEY (employee_Id))", null);
    log:printInfo("Table creation status:" + returnValue);
}

public function insertData (string name, string age, string ssn) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    string sqlString = "INSERT INTO EMPLOYEES (name, age, ssn) VALUES ('" + name + "','" + age + "','" + ssn + "')";
    int returnValue = employeeDataBase.update(sqlString, null);
    log:printInfo("Data insertion to table status:" + returnValue);
}

public function updateData (string name, string age, string ssn) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    string sqlString = "INSERT INTO EMPLOYEES (name, age, ssn) VALUES ('" + name + "','" + age + "','" + ssn + "')";
    int returnValue = employeeDataBase.update(sqlString, null);
    log:printInfo("Data insertion to table status:" + returnValue);
}

public function deleteData (string employeeID) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    string sqlString = "DELETE FROM EMPLOYEES WHERE employee_Id = '" + employeeID + "'";
    int returnValue = employeeDataBase.update(sqlString, null);
    log:printInfo("Data delete status:" + returnValue);
}

public function retrieveAllData () (json) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    var dt = employeeDataBase.call("SELECT * FROM EMPLOYEES;", null, null);
    var jsonReturnValue, _ = <json>dt;
    return jsonReturnValue;
}

public function retrieveById (string employeeID) (json) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    string sqlString = "SELECT * FROM EMPLOYEES WHERE employee_Id = '" + employeeID + "'";
    var dt = employeeDataBase.call(sqlString, null, null);
    var jsonReturnValue, _ = <json>dt;
    return jsonReturnValue;
}
