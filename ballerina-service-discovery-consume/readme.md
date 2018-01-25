# Service Discovery and Consume using Ballerina 

This sample application discovers and consume the available services using Consul. Consul is a tool for discovering and 
configuring services in your infrastructure. This sample consist of three services: Time Service, Date Service, Hello
 Service. The application calls the Consul server endpoint and receives the list of available services. Then one 
 service is selected from the list of available services. The application will then calls the consul and get the actual 
 service resource with the uniform resource locators and port numbers etc. Finally the resource is consumed by the 
 application and the response is logged in the console.
 
 
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
 