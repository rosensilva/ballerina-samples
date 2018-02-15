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
Please refer to the following scenario diagram for understanding the scenario end-to-end.
![alt text](https://github.com/rosensilva/ballerina-samples/blob/master/bellerinaDataBackedApiSample/images/employee_service_scenario.png)


## <a name="pre-req"></a> Prerequisites
 
* JDK 1.8 or later
* Ballerina Distribution (Install Instructions:  https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
* Official JDBC driver for MySQL ( Download https://dev.mysql.com/downloads/connector/j/)
  * Copy the downloaded JDBC driver to the <BALLERINA_HOME>/bre/lib folder 
* A Text Editor or an IDE


Optional Requirements
- Docker (Follow instructions in https://docs.docker.com/engine/installation/)
- Ballerina IDE plugins. ( Intellij IDEA, VSCode, Atom)
- Testerina (Refer: https://github.com/ballerinalang/testerina)
- Container-support (Refer: https://github.com/ballerinalang/container-support)
- Docerina (Refer: https://github.com/ballerinalang/docerina)





