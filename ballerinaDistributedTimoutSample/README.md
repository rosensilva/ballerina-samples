# Distributed Timeout Web-Service
This application calls three remote endpoints in a sequential order with distributed timeout for each call.
The total deadline for all three remote calls is 10 seconds(i.e. all three responses should be received before 10 
seconds). If any one of three remote call response is delayed more than the local timeout it will not call the remaining remote calls.
The complete application is written using ballerina language including the timeout handling. The local timeouts for 
each remote call will randomly generated. The remote calls are mocked through http calls to `www.postman-echo.com/delay` 
with specific response delays. The application will repeatedly run the with different set of random local timeouts until 
user terminates the programme.

![alt text](https://github.com/rosensilva/ballerina-samples/blob/master/ballerinaDistributedTimoutSample/images/Distributed-timeout-image.png)

# How to run
1) Go to http://www.ballerinalang.org and click Download.
2) Download the Ballerina Tools distribution and unzip it on your computer. Ballerina Tools includes the Ballerina runtime plus
the visual editor (Composer) and other tools.
3) Add the <ballerina_home>/bin directory to your $PATH environment variable so that you can run the Ballerina commands from anywhere.
4) After setting up <ballerina_home>, run: `$ ballerina run distributed-timeout-service.bal`
5) Output for the distributed-timeout-service application will look similar structure like,
    * Local timeout for each remote call is displayed as  - `INFO  [] - Local timeout for 1st remote procedure call 
    :3013ms` 
    * Each remote call delay is displayed as `INFO  [] - Responce delay for remote procedure call :1000ms`
    * Response for each RPC call is displayed as `INFO  [] - HTTP responce status code : 200 `
 

```
2018-02-01 16:07:43,691 INFO  [] - Running Service Discovery ... 
2018-02-01 16:07:44,084 INFO  [] - List of Available Services 
2018-02-01 16:07:44,085 INFO  [] - --------------------------------------------------------- 
2018-02-01 16:07:44,087 INFO  [] - [] 
2018-02-01 16:07:44,088 INFO  [] - ["get the current date"] 
2018-02-01 16:07:44,088 INFO  [] - ["say hello"] 
2018-02-01 16:07:44,089 INFO  [] - ["get the current time"] 
2018-02-01 16:07:44,089 INFO  [] - --------------------------------------------------------- 
2018-02-01 16:07:44,091 INFO  [] - Consuming resource name : helloService 
2018-02-01 16:07:44,243 INFO  [] - Response from the service consumed : Hello, World! 
```
