# Employee Database Web-Service
Data backed RESTful API web service written using Ballerina language (https://ballerinalang.org)

# About this appication/service 
This web service is a sample web service that is capable of saving and retrieving employee data from a MYSQL database.
The full service/application is written using ballerina language. This service will demonstrate the usage of 
ballerina language to work with MYSQL databases and exposing that data through a web service.

# How to deploy
1) Go to http://www.ballerinalang.org and click Download.
2) Download the Ballerina Tools distribution and unzip it on your computer. Ballerina Tools includes the Ballerina runtime plus
the visual editor (Composer) and other tools.
3) Add the <ballerina_home>/bin directory to your $PATH environment variable so that you can run the Ballerina commands from anywhere.
4) After setting up <ballerina_home>, run: `$ ballerina run service.bal` 

5) How to interact with the employee database web service, 
* To add new employee to the Database     - POST `localhost:9090/employee/add_employee?name=Alice&age=20&ssn=111223333`
* To retrieve an existing employee detail - POST `localhost:9090/employee/retrieve_employee?id=1`
* To delete an existing employee          - POST `localhost:9090/employee/delete_employee?id=1`
* To retrieve details about all employees - POST `localhost:9090/employee/retrieve_all`

6) Responses for above requst will look simliar to, 
```json

* adding new employee
{
    "Name": "Alice",
    "Age": "20",
    "ssn": "111223333"
} 

* retrieving an existing employee detail
 
[
    {
        "employee_Id": 1,
        "name": "Alice",
        "age": 20,
        "ssn": 111223333
    }
]
* deleting an existing employee 

{
    "Employee ID": "1",
    "Status": "Deleted"
}
* retrieving details about all employees

[
    {
        "employee_Id": 3,
        "name": "Bob",
        "age": 30,
        "ssn": 999887777
    },
    {
        "employee_Id": 4,
        "name": "Alice",
        "age": 20,
        "ssn": 111223333
    }
]

