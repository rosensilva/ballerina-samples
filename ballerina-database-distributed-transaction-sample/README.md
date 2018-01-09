# Ballerina Distributed Transaction across two Database endpoints sample
`ballerina Distributed Transaction application/webservice` written using Ballerina language (https://ballerinalang.org)

# About this application/webservice
This application/webservice will demonstrate how to use ballerina language to create a service that uses distributed databases 
to perform a distributed transaction. This web service/application is a banking application which is capable of transfering money from one account to another account.
the transaction can be done via calling HTTP POST request. If the whole transaction is completed then the application will commit the changes in the databases.
Otherwise everything will be roll-back to the previous state. The response will indicate whether the transaction is completed or not. 

# How to deploy
1) Go to http://www.ballerinalang.org and click Download.
2) Download the Ballerina Tools distribution and unzip it on your computer. Ballerina Tools includes the Ballerina runtime plus
the visual editor (Composer) and other tools.
3) Add the <ballerina_home>/bin directory to your $PATH environment variable so that you can run the Ballerina commands from anywhere.
4) After setting up <ballerina_home>, run: `$ ballerina run main.bal`
5) How to interact with the employee database web service, 
* To transfer 1000/= from Alice's account to Bob's account - POST `localhost:9090/bank/transfer?from=Alice&to=Bob&amount=1000`

6) Responses for sucessful requests will look simliar to, 
```json
"Transaction committed"
```
7)Responses for unsucessful requests will look similar to,
```json
"Transaction failed"
```

7) Server terminal output for the application will look similar to , 

```
ballerina: deploying service(s) in 'main.bal'
ballerina: started HTTP/WS server connector 0.0.0.0:9090
2018-01-09 11:11:03,321 INFO  [connectors] - [REQUEST] Transfer from Alice to Bob total amount of : 1000 
2018-01-09 11:11:03,606 INFO  [connectors] - [AVAILABLE BALANCE] - ALICE 4800/= and BOB : 200/= 
2018-01-09 11:11:03,668 INFO  [connectors] - Transaction committed 
2018-01-09 11:13:32,588 INFO  [connectors] - [REQUEST] Transfer from Alice to Bob total amount of : 100000 
2018-01-09 11:13:32,610 INFO  [connectors] - [AVAILABLE BALANCE] - ALICE 3800/= and BOB : 1200/= 
2018-01-09 11:13:32,610 INFO  [connectors] - Account Balance not Sufficient for the transaction! 

```
