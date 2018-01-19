# Distributed Transaction Across Two Database Endpoints
This Ballerina service use distributed databases to perform distributed transactions. This is a banking web application 
which is capable of transferring money from one account to another account where databases are in a distributed manner.
The transactions can be done by calling HTTP endpoint. If the entire transaction is completed then the changes will be 
committed in the databases. Otherwise, changes will be rolled back. The HTTP response will indicate the client whether 
the transaction was completed or not.

# Before running
1) Copy MySQL JDBC driver to the BALLERINA_HOME/bre/lib folder
2) Create two empty MySQL databases
3) Replace the database connection properties variables in `bankDatabaseConnector.bal` file accordingly. 
# How to run
1) Go to http://www.ballerinalang.org and click Download.
2) Download the Ballerina Tools distribution and unzip it on your computer. Ballerina Tools includes the 
Ballerina runtime plus
the visual editor (Composer) and other tools.
3) Add the <ballerina_home>/bin directory to your $PATH environment variable so that you can run the Ballerina
 commands from anywhere.
4) After setting up <ballerina_home>, run: `$ ballerina run main.bal`
   #### How to interact with the employee database web service, 
   This sample banking application will have two databases.
    * The first database will have account name `Alice` with `$5000` initial balance
    * The second database will have account name `Bob` with `$0` initial balance.
   
   To transfer $1000 from Alice's account to Bob's account
    * POST `localhost:9090/bank/transfer?from=Alice&to=Bob&amount=1000`

   Responses to successful requests will look similar to, 
    ```
    "Transaction committed"
    ``` 
    
   Responses to unsuccessful requests will look similar to,
    ```
    "Transaction failed"
    ```

   Server terminal output for the application will look similar to , 

    ```
    ballerina: deploying service(s) in '/home/rosen/ballerina-samples/ballerina-database-distributed-transaction-sample/main.bal'
    ballerina: started HTTP/WS server connector 0.0.0.0:9090
    2018-01-19 15:26:22,917 INFO  [connectors] - [REQUEST] Transfer from Alice to Bob total amount of : $1000 
    2018-01-19 15:26:23,173 INFO  [connectors] - [AVAILABLE BALANCE] - ALICE : $5000 and BOB : $0 
    2018-01-19 15:26:23,219 INFO  [connectors] - [TRANSACTION STATUS] - Transaction committed 
    2018-01-19 15:26:35,248 INFO  [connectors] - [REQUEST] Transfer from Alice to Bob total amount of : $5000 
    2018-01-19 15:26:35,279 INFO  [connectors] - [AVAILABLE BALANCE] - ALICE : $4000 and BOB : $1000 
    2018-01-19 15:26:35,280 INFO  [connectors] - [TRANSACTION STATUS] - Account Balance not Sufficient for the transaction! 
    ```
