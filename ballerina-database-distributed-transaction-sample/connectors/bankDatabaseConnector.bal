package connectors;

import ballerina.data.sql;
import ballerina.log;


public connector bankDatabaseConnector () {
    endpoint<sql:ClientConnector> testDB1 {
        create sql:ClientConnector(
        sql:DB.MYSQL, "localhost", 3306, "bankDB1?useSSL=false", "root", "qwe123",
        {maximumPoolSize:1, isXA:true});
    }
    endpoint<sql:ClientConnector> testDB2 {
        create sql:ClientConnector(
        sql:DB.MYSQL, "localhost", 3306, "bankDB2?useSSL=false", "root", "qwe123",
        {maximumPoolSize:1, isXA:true});
    }

    action transferMoney (string from, string to, int amount) (string) {
        boolean transactionSuccess = false;
        string statusString = "Transaction failed";
        log:printInfo("[REQUEST] Transfer from " + from + " to " + to + " total amount of : " + amount);

        transaction {

            try {
                string sqlString = "SELECT BALANCE FROM CUSTOMER WHERE NAME= '" + from + "'";
                var dataTable = testDB1.call(sqlString, null, null);
                var jsonValue, _ = <json>dataTable;
                var val_string, _ = (string)jsonValue[0].BALANCE;
                var acc_balance_account1, _ = <int>val_string;

                sqlString = "SELECT BALANCE FROM CUSTOMER WHERE NAME= '" + to + "'";
                dataTable = testDB2.call(sqlString, null, null);
                jsonValue, _ = <json>dataTable;
                val_string, _ = (string)jsonValue[0].BALANCE;
                var acc_balance_account2, _ = <int>val_string;

                log:printInfo("[AVAILABLE BALANCE] - ALICE " + acc_balance_account1 + "/= and BOB : " + acc_balance_account2 + "/=");


                if (acc_balance_account1 >= amount) {
                    int new_balance = acc_balance_account2 + amount;
                    string new_balance_string = <string>new_balance;
                    sqlString = "UPDATE CUSTOMER SET BALANCE = '" + new_balance_string + "'WHERE NAME= '" + to + "'";
                    int statusCode1 = testDB2.update(sqlString, null);


                    new_balance = acc_balance_account1 - amount;
                    new_balance_string = <string>new_balance;
                    sqlString = "UPDATE CUSTOMER SET BALANCE = '" + new_balance_string + "'WHERE NAME= '" + from + "'";
                    int statusCode2 = testDB1.update(sqlString, null);
                }
                else {
                    log:printInfo("Account Balance not Sufficient for the transaction!");
                    abort;
                }
            }
            catch (error err) {
                log:printError("Tansaction failed due to :" + err.msg);
                abort;
            }

            transactionSuccess = true;
        }
        failed {
            transactionSuccess = false;
            log:printInfo("Transaction Not committed");
        }


        if (transactionSuccess) {
            log:printInfo("Transaction committed");
            statusString = "Transaction committed";
        }

        testDB1.close();
        testDB2.close();
        return statusString;
    }

    action init () {
        endpoint<sql:ClientConnector> testDB1 {
            create sql:ClientConnector(
            sql:DB.MYSQL, "localhost", 3306, "bankDB1?useSSL=false", "root", "qwe123",
            {maximumPoolSize:1, isXA:true});
        }
        endpoint<sql:ClientConnector> testDB2 {
            create sql:ClientConnector(
            sql:DB.MYSQL, "localhost", 3306, "bankDB2?useSSL=false", "root", "qwe123",
            {maximumPoolSize:1, isXA:true});
        }

        int returnCode1 = testDB1.update("CREATE TABLE IF NOT EXISTS CUSTOMER (NAME VARCHAR(30) PRIMARY KEY,
                                    BALANCE VARCHAR(30))", null);
        int returnCode2 = testDB2.update("CREATE TABLE IF NOT EXISTS CUSTOMER (NAME VARCHAR(30) PRIMARY KEY,
                                    BALANCE VARCHAR(30))", null);

        int ret3 = testDB1.update("INSERT INTO CUSTOMER (NAME, BALANCE)
                              SELECT * FROM (SELECT 'Alice', '5000') AS tmp
                              WHERE NOT EXISTS (
                                    SELECT name FROM CUSTOMER WHERE NAME = 'Alice'
                              ) LIMIT 1", null);
        int ret4 = testDB2.update("INSERT INTO CUSTOMER (NAME, BALANCE)
                              SELECT * FROM (SELECT 'Bob', '0') AS tmp
                              WHERE NOT EXISTS (
                                    SELECT name FROM CUSTOMER WHERE NAME = 'Bob'
                              ) LIMIT 1", null);
        testDB1.close();
        testDB2.close();
    }
}
