# Database Backed RESTful Web Service
This guide walks you through building a database backed RESTful web service with Ballerina.

## <a name="what-you-build"></a>  What you'll build
You'll build an employee data management web service that performs CRUD Operations(Create, Read, Update, Delete) on MySQL database. The service is capable of,
* Adding new employees to the database through HTTP POST method
* Retrieve existing employee details from the database via HTTP GET method
* Update existing employee in the database via HTTP PUT mehtod
* Delete existing employee from the database via HTTP DELETE method
* Retrieve all the existing employee details from the database via HTTP GET method  

Basically, the service will deal with MySQL database and expose the data operations as a web service.
Please refer to the following scenario diagram to understand complete end-to-end scenario.


![alt text](https://github.com/rosensilva/ballerina-samples/blob/master/bellerinaDataBackedApiSample/images/employee_service_scenario.png)


## <a name="pre-req"></a> Prerequisites
 
* JDK 1.8 or later
* Ballerina Distribution (Install Instructions:  https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
* MySQL version 5.6 or better
* Official JDBC driver for MySQL ( Download https://dev.mysql.com/downloads/connector/j/)
  * Copy the downloaded JDBC driver to the <BALLERINA_HOME>/bre/lib folder 
* A Text Editor or an IDE


Optional Requirements
- Docker (Follow instructions in https://docs.docker.com/engine/installation/)
- Ballerina IDE plugins. ( Intellij IDEA, VSCode, Atom)
- Testerina (Refer: https://github.com/ballerinalang/testerina)
- Container-support (Refer: https://github.com/ballerinalang/container-support)
- Docerina (Refer: https://github.com/ballerinalang/docerina)

## <a name="develop-app"></a> Develop the application
### Before you begin
##### Understand the package structure
Ballerina is a complete programming language that can have any custom project structure as you wish. Although language allows you to have any package structure, we'll stick with the following package structure for this project.

```
├── employeeService
│   |── util
│   |    └── db
│   |        ├── employee_database_util.bal
│   |        └── employee_database_util_test.bal
│   ├── employee_database_service.bal
│   └── employee_database_service_test.bal
└── ballerina.conf

```
##### Add database configurations to the `ballerina.conf` file
The purpose of  `ballerina.conf` file is to provide any external configurations that are needed to ballerina programs. Since this guide have interact with MySQL database we need to provide the database connection properties to the ballerina program via `ballerina.cof` file.
This configuration file will have the following fields,
```
DATABASE_HOST = localhost
DATABASE_PORT = 3306
DATABASE_USERNAME = username
DATABASE_PASSWORD = password
DATABASE_NAME = RECORDS
```
First you need to replace `localhost`, `3306`, `username`, `password` the respective MySQL database connection properties in the `ballerina.conf` file. You can keep the DATABASE_NAME as it is if you don't want to change the name explicitly.


### Develop the Ballerina web service
Ballerina language have built-in support for writting web services. The `service` keyword in ballerina simply defines a web service. Inside the service block we can have all the required resources. You can define a resource using `resource` keyword in Ballerina. We can implement the business logic inside a resource block using Ballerina language syntaxes. The following ballerina code is the skelliton code of the service with resources to add new employee and retrieve emoloyee data.

```ballerina
package employeeService;

import ballerina.net.http;

service<http> records {
    // Initialize your global variables here
    
    @http:resourceConfig {
        // Set the HTTP URL for adding new employee
    }
    resource addEmployeeResource (http:Connection conn, http:InRequest req) {
        // Implement the logic for adding a new employee
        // Here you can execute SQL INSERT database and save the employee data
    }

    @http:resourceConfig {
        // Set the HTTP URL for retrieve employee data
    }
    resource retrieveEmployeeResource (http:Connection conn, http:InRequest req) {
        // Implement the logic for retrieve employee data
        // Here you can execute SQL RETRIEVE query and retrieve the employee data
    }
}
```

Please refer `org/<repo name>/employeeService/employee_database_service.bal` file for the complete implementaion of employee management web service.


### Develop the database handeling utility functions
You can implement custom functions in Ballerina which does specific tasks. For this scenario we need to have utility functions that deal with MySQL database. The following skeliton code is the implementation of the database utility package.
```ballerina 
package employeeService.util.db;

public sql:ClientConnector sqlConnection;

public function initializeDatabase (string dbHost, string dbPort, string userName, string password, string dbName)
(boolean) {
   // Implementation of data initilization funcion
}

public function createDatabase (string userName, string password, string dbName, string dbURL) (int) {
   // Implementation of database create funcion
}

public function createTable () (int) {
   // Implementation of table creation function
}

public function insertData (string name, string age, string ssn) (json) {
    // Implementation of inserting employee data to the database
}

public function updateData (string name, string age, string ssn, string employeeID) (string) {
    // Implementaion of updating existing employye in the database
}

public function deleteData (string employeeID) (string) {
    // Implementaion of deleting an existing employee data from the database
}

public function retrieveAllData () (json) {
    // Implementaion of recieving all the employee data from database 
}

public function retrieveById (string employeeID) (json) {
    // Implementaiton of retrieving employee data of specific employee with given EmployeeID
}
```
The following section will explain the implementation of `public function insertData`. Similarly other functions can be implemented. The complete implementation can be found at `org/<repo name>/employeeService/util/db/employee_database_util.bal`


The `endpoint` keyword in ballerina refers to an connection with remote service, in this case the remote service is MySQL database. `employeeDatabase` is the reference name for the sql endpoint. This endpoint is initialized with the  
```ballerina
public function insertData (string name, string age, string ssn) (json) {
    endpoint<sql:ClientConnector> employeeDataBase {
        sqlConnection;
    }
    json updateStatus;
    string sqlString = "INSERT INTO EMPLOYEES (Name, Age, SSN) VALUES ('" + name + "','" + age + "','" + ssn + "')";
    // Insert data to SQL database by invoking update action defined in ballerina sql connector
    int updateRowCount = employeeDataBase.update(sqlString, null);
    // log:printInfo("Data insertion to table status:" + updateRowCount);
    if (updateRowCount > 0) {
        // SQL query to retrieve the EmployeeID
        sqlString = "SELECT EmployeeID FROM EMPLOYEES WHERE SSN = '" + ssn + "'";
        var dataTableOfIDs = employeeDataBase.select(sqlString, null, null);
        var jsonArrayOfIDs, _ = <json>dataTableOfIDs;
        string employeeID = jsonArrayOfIDs[(lengthof jsonArrayOfIDs - 1)].EmployeeID.toString();
        updateStatus = {"Status":UPDATED, "EmployeeID":employeeID};
    }
    else {
        updateStatus = {"Status":NOT_UPDATED};
    }
    return updateStatus;
}
```


