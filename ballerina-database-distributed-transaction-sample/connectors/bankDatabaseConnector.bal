package connectors;

import ballerina.data.sql;
import ballerina.log;

const string DATABASE1_HOST = "localhost";
const int DATABASE1_PORT = 3306;
const string DATABASE1_NAME = "bankDB1?useSSL=false";
const string DATABASE1_USERNAME = "root";
const string DATABASE1_PASSWORD = "qwe123";

const string DATABASE2_HOST = "localhost";
const int DATABASE2_PORT = 3306;
const string DATABASE2_NAME = "bankDB2?useSSL=false";
const string DATABASE2_USERNAME = "root";
const string DATABASE2_PASSWORD = "qwe123";

public connector bankDatabaseConnector () {
    endpoint<sql:ClientConnector> bankDB1 {
        create sql:ClientConnector(
        sql:DB.MYSQL, DATABASE1_HOST, DATABASE1_PORT, DATABASE1_NAME, DATABASE1_USERNAME, DATABASE1_PASSWORD,
        {maximumPoolSize:1, isXA:true});
    }
    endpoint<sql:ClientConnector> bankDB2 {
        create sql:ClientConnector(
        sql:DB.MYSQL, DATABASE2_HOST, DATABASE2_PORT, DATABASE2_NAME, DATABASE2_USERNAME, DATABASE2_PASSWORD,
        {maximumPoolSize:1, isXA:true});
    }

    action transferMoney (string from, string to, int transferAmount) (string) {
        boolean transactionSuccessful = false;
        string statusString = "Transaction failed";
        log:printInfo("[REQUEST] Transfer from " + from + " to " + to + " total amount of : " + transferAmount);

        transaction {
            try {
                //call the sql database and get the account balance of the first account
                string sqlQueryString = "SELECT BALANCE FROM CUSTOMER WHERE NAME= '" + from + "'";
                var dataTable = bankDB1.call(sqlQueryString, null, null);
                var jsonValue, _ = <json>dataTable;
                var valueString, _ = (string)jsonValue[0].BALANCE;
                var accountBalance1, _ = <int>valueString;
                //call the sql database and get the account balance of the second account
                sqlQueryString = "SELECT BALANCE FROM CUSTOMER WHERE NAME= '" + to + "'";
                dataTable = bankDB2.call(sqlQueryString, null, null);
                jsonValue, _ = <json>dataTable;
                valueString, _ = (string)jsonValue[0].BALANCE;
                var accountBalance2, _ = <int>valueString;

                log:printInfo("[AVAILABLE BALANCE] - ALICE " + accountBalance1 + "/= and BOB : " + accountBalance2 + "/=");
                //check whether the account balance is enough for the transfer the money
                if (accountBalance1 >= transferAmount) {
                    //deducting the account balance by the transfer amount
                    int newBalance = accountBalance1 - transferAmount;
                    string newBalanceString = <string>newBalance;
                    sqlQueryString = "UPDATE CUSTOMER SET BALANCE = '" + newBalanceString + "'WHERE NAME= '" + from + "'";
                    _ = bankDB1.update(sqlQueryString, null);
                    //adding the money to the account by the transfer amount
                    newBalance = accountBalance2 + transferAmount;
                    newBalanceString = <string>newBalance;
                    sqlQueryString = "UPDATE CUSTOMER SET BALANCE = '" + newBalanceString + "'WHERE NAME= '" + to + "'";
                    _ = bankDB2.update(sqlQueryString, null);
                }
                else {
                    log:printInfo("[TRANSACTION STATUS] - Account Balance not Sufficient for the transaction!");
                    abort;
                }
            }
            catch (error err) {
                log:printError("Tansaction failed due to : " + err.msg);
                abort;
            }
            finally {
                bankDB1.close();
                bankDB2.close();
            }

            transactionSuccessful = true;
        }
        failed {
            //if transaction fails at any point log that the transaction was not committed
            log:printInfo("Transaction Not committed");
        }

        if (transactionSuccessful) {
            statusString = "Transaction committed";
            log:printInfo("[TRANSACTION STATUS] - " + statusString);
        }

        return statusString;
    }

    action init () {
        //initialization action to create tables and populate data
        try {
            _ = bankDB1.update("DROP TABLE IF EXISTS CUSTOMER", null);
            _ = bankDB2.update("DROP TABLE IF EXISTS CUSTOMER", null);

            _ = bankDB1.update("CREATE TABLE CUSTOMER (NAME VARCHAR(30) PRIMARY KEY,
                                    BALANCE VARCHAR(30))", null);
            _ = bankDB2.update("CREATE TABLE CUSTOMER (NAME VARCHAR(30) PRIMARY KEY,
                                    BALANCE VARCHAR(30))", null);

            _ = bankDB1.update("INSERT INTO CUSTOMER (NAME, BALANCE)
                                    VALUES ('Alice', '5000')", null);
            _ = bankDB2.update("INSERT INTO CUSTOMER (NAME, BALANCE)
                                    VALUES ('Bob', '0')", null);
        }
        catch (error err) {
            log:printError("Error occurred while initializing databases : " + err.msg);
        }
        finally {
            bankDB1.close();
            bankDB2.close();
        }
    }

}
