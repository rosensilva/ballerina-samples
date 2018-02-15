# Database Backed RESTful Web Service
This guide walks you through building a database backed RESTful web service with Ballerina.

## What you'll build
You'll build an employee data management web service which will perform CRUD(Create, Read, Update, Delete) on MySQL database. The service is capable of,
* Adding new employees to the database through HTTP POST method
* Retrieve existing employee details from the database via HTTP GET method
* Update existing employee in the database via HTTP PUT mehtod
* Delete existing employee from the database via HTTP DELETE method
* Retrieve all the existing employee details from the database via HTTP GET method
Basically, the service will deal with MYSQL database and expose the data manupulations as a web service.
Please refer to the following scenario diagram for understanding the scenario end-to-end.
![alt text](https://github.com/rosensilva/ballerina-samples/blob/master/bellerinaDataBackedApiSample/images/employee_service_scenario.png)

