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
4) Download the Consul using https://www.consul.io/downloads.html
5) Extract the downloaded consul zip file and copy executable consul file to the sample directory
5) Navigate to service discovery directory and run following commands in following 
order, 

 * `$ chmod +x setup-consul.sh`
 * `$ ./setup-consul.sh`
 * `$ ballerina run service-discovery-sample.bal`
#### Output for service-discovery-sample,
```
2018-02-01 16:07:43,691 INFO  [] - Running Service Discovery ... 
2018-02-01 16:07:44,084 INFO  [] - List of Available Services 
2018-02-01 16:07:44,085 INFO  [] - -------------------------------------------------------- 
2018-02-01 16:07:44,087 INFO  [] - [] 
2018-02-01 16:07:44,088 INFO  [] - ["get the current date"] 
2018-02-01 16:07:44,088 INFO  [] - ["say hello"] 
2018-02-01 16:07:44,089 INFO  [] - ["get the current time"] 
2018-02-01 16:07:44,089 INFO  [] - -------------------------------------------------------- 
2018-02-01 16:07:44,091 INFO  [] - Consuming resource name : helloService 
2018-02-01 16:07:44,243 INFO  [] - Response from the service consumed : Hello, World!     
Process finished with exit code 0
```