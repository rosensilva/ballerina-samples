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
4) After setting up <ballerina_home>, navigate to service discovery directory and run following commands in following 
order, 

 * `$ chmod +x setup-consul.sh`
 * `$ ./setup-consul.sh`
 * `$ ballerina run service-discovery-sample.bal`
#### Output for service-discovery-sample,
    ```
    2018-01-25 16:29:20,509 INFO  [] - Available services after discovery ...  
    2018-01-25 16:29:20,670 INFO  [] - All Services Discovery Response message {"consul":[],"dateService":["get the current date"],"helloService":["say hello"],"timeService":["get the current time"]} 
    2018-01-25 16:29:20,845 INFO  [] -  0 -> consul : [] 
    2018-01-25 16:29:20,846 INFO  [] -  1 -> dateService : ["get the current date"] 
    2018-01-25 16:29:20,846 INFO  [] -  2 -> helloService : ["say hello"] 
    2018-01-25 16:29:20,847 INFO  [] -  3 -> timeService : ["get the current time"] 
    2018-01-25 16:29:20,848 INFO  [] - Consuming resource name : dateService/ 
    2018-01-25 16:29:20,854 INFO  [] - Service Discovery Response message : [{"ID":"1329d9cc-6190-dcf1-4e7c-acc0d7c833a7","Node":"rosen-ThinkPad-X1-Carbon-3rd","Address":"127.0.0.1","Datacenter":"dc1","TaggedAddresses":{"lan":"127.0.0.1","wan":"127.0.0.1"},"NodeMeta":{"consul-network-segment":""},"ServiceID":"dateService","ServiceName":"dateService","ServiceTags":["get the current date"],"ServiceAddress":"","ServicePort":9092,"ServiceEnableTagOverride":false,"CreateIndex":8,"ModifyIndex":8}] 
    2018-01-25 16:29:20,978 INFO  [] - Response from the service consumed : Date:2018:1:25 
    
    Process finished with exit code 0
    ``` 