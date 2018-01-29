package connectors;

import ballerina.data.sql;
import ballerina.log;

const string DATABASE1_HOST = "localhost";
const int DATABASE1_PORT = 3306;
const string DATABASE1_NAME = "employeedb?useSSL=false";
const string DATABASE1_USERNAME = "root";
const string DATABASE1_PASSWORD = "qwe123";

public connector employeeDatabaseConnector () {
    endpoint<sql:ClientConnector> employeeDataBase {
        create sql:ClientConnector(
        sql:DB.MYSQL, DATABASE1_HOST, DATABASE1_PORT, DATABASE1_NAME, DATABASE1_USERNAME, DATABASE1_PASSWORD,
        {maximumPoolSize:5});
    }

    action createTable () {
        int returnValue = employeeDataBase.update("CREATE TABLE IF NOT EXISTS EMPLOYEES (employee_Id INT AUTO_INCREMENT,
                            name VARCHAR(50) , age INT, ssn INT,
                            PRIMARY KEY (employee_Id))", null);
        log:printInfo("Table creation status:" + returnValue);
    }

    action insertData (string name, string age, string ssn) {
        string sqlString = "INSERT INTO EMPLOYEES (name, age, ssn) VALUES ('" + name + "','" + age + "','" + ssn + "')";
        int returnValue = employeeDataBase.update(sqlString, null);
        log:printInfo("Data insertion to table status:" + returnValue);
    }

    action deleteData (string employeeID) {
        string sqlString = "DELETE FROM EMPLOYEES WHERE employee_Id = '" + employeeID + "'";
        int returnValue = employeeDataBase.update(sqlString, null);
        log:printInfo("Data delete status:" + returnValue);
    }

    action retrieveAllData () (json) {
        var dt = employeeDataBase.call("SELECT * FROM EMPLOYEES;", null, null);
        var jsonReturnValue, _ = <json>dt;
        return jsonReturnValue;
    }

    action retrieveById (string employeeID) (json) {
        string sqlString = "SELECT * FROM EMPLOYEES WHERE employee_Id = '" + employeeID + "'";
        var dt = employeeDataBase.call(sqlString, null, null);
        var jsonReturnValue, _ = <json>dt;
        return jsonReturnValue;
    }
}