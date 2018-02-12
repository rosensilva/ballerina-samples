package employeeService.util.db;

import ballerina.config;
import ballerina.test;

function testcreateDatabase(){
    string dbHost = config:getGlobalValue("DATABASE_HOST");
    string dbPort = config:getGlobalValue("DATABASE_PORT");
    string userName = config:getGlobalValue("DATABASE_USERNAME");
    string password = config:getGlobalValue("DATABASE_PASSWORD");
    string dbName = config:getGlobalValue("DATABASE_NAME");
    string dbURL = "jdbc:mysql://" + dbHost + ":" + dbPort + "/";
    createDatabase(userName,password,dbName,dbURL);

}