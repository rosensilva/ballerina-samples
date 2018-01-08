package connectors;

import ballerina.data.sql;
import ballerina.log;

public connector employeeDatabaseConnector () {

    endpoint<sql:ClientConnector> employeeDB {
        create sql:ClientConnector(sql:DB.MYSQL, "localhost", 3306,
                                   "employeedb?useSSL=false", "root", "qwe123", {maximumPoolSize:5});
    }


    action createTable () {
        int returnValue = employeeDB.update("CREATE TABLE IF NOT EXISTS EMPLOYEES (employee_Id INT AUTO_INCREMENT,
                            name VARCHAR(50) , age INT, ssn INT,
                            PRIMARY KEY (employee_Id))", null);
        log:printInfo("Table creation status:" + returnValue);
    }

    action insertData (string name, string age, string ssn) {
        string sqlString = "INSERT INTO EMPLOYEES (name, age, ssn) VALUES ('" + name + "','" + age + "','" + ssn + "')";
        int returnValue = employeeDB.update(sqlString, null);
        log:printInfo("Data insertion to table status:" + returnValue);
    }

    action deleteData (string employeeID) {
        string sqlString = "DELETE FROM EMPLOYEES WHERE employee_Id = '" + employeeID + "'";
        int returnValue = employeeDB.update(sqlString, null);
        log:printInfo("Data delete status:" + returnValue);
    }

    action retrieveAllData () (json) {
        var dt = employeeDB.call("SELECT * FROM EMPLOYEES;",null, null);
        var jsonReturnValue, _ = <json>dt;
        return jsonReturnValue;
    }

    action retrieveById (string employeeID) (json) {
        string sqlString = "SELECT * FROM EMPLOYEES WHERE employee_Id = '" + employeeID + "'";
        var dt = employeeDB.call(sqlString,null, null);
        var jsonReturnValue, _ = <json>dt;
        return jsonReturnValue;
    }
}
