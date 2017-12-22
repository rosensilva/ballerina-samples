# Ballerina Asynchronous Interaction Example

## Introduction

Following guide walk you through the step by step process of building an Asynchronous Interaction Web Service with Ballerina.
Guide also explains the development and deployment workflow of a standard Ballerina Service in-detail.

## What You Will Develop
You’ll build a Sleep and Wakeup service that will accept HTTP GET requests at:
```
http://localhost:9090/sleep_and_wakeup?sleeptime=10
```
and respond with a JSON representation after the `sleeptime` timeout.
```
{
    "Start Time": "Time: 14:22:43",
    "End Time": "Time: 14:22:58",
    "Sleep Time(seconds)": "10",
    "Wake Up": "Yes",
    "Service Number": 1
}
```
The response is sent back to the client after waiting for number of seconds given by the `sleeptime` query parameter. The same resource can be used to serve different clients at the same time. The interaction is demonstrated by waiting for the client defined `sleeptime` and the giving back the response. To see how ballerina is good at doing that task asynchronously and simultaneously we can send several requsets at the same time by varying the `sleeptime` query parameter.

## Before You Begin:  What You Will Need
- About 15 minutes
- A favorite text editor or IDE
- JDK 1.8 or later
- Ballerina Distribution (Install Instructions:  https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
- You can import or write the code straight on your text editor/Ballerina Composer


## How to Complete This Guide
You can either start writing the service in Ballerina from scratch or by cloning the service to continue with the next steps.

To skip the basics:
Download and unzip the source repository for this guide in https://github.com/rosensilva/ballerina-samples/tree/master/ballerina-asynchronous-interactions-example
Skip "Writing the Service" section

## Writing the Service
Create a new directory(Ex: ballerina-asynchronous-interactions-example). Inside the directory,create a new file in your text editor and copy the following content. Save the file with .bal extension (ex:sleepAndReply.bal) 
```
ballerina-asynchronous-interactions-example
   └── sleepAndReply.bal
```

##### sleepAndReply.bal
```ballerina 
import ballerina.net.http;
import ballerina.log;
int globalRequestCounter;

service<http> sleep_and_wakeup{
        @http:resourceConfig {
            methods:["GET"],	
            path:"/"
        }
        resource getNumberResource (http:Request req, http:Response res) {
            int hour;
            int minute;
            int second;
            int milliSecond;
            string startTime;
            string endTime;
            globalRequestCounter = globalRequestCounter +1 ;
            Time time = currentTime();						
            hour, minute, second, milliSecond = time.getTime();
            startTime = "Time: " + <string>hour + ":" + <string>minute + ":" + <string>second; 
            log:printInfo("Serving Reqest No: " + globalRequestCounter + " Start Time :" +startTime);
            map params = req.getQueryParams();
            var sleeptime, _ = (string)params.sleeptime;
            var slpTime, _ = <int>sleeptime;
            sleep(slpTime*1000);//sleep the current request for sleeptime query parameter seconds
            time = currentTime();
            hour, minute, second, milliSecond = time.getTime();
            endTime = "Time: " + <string>hour + ":" + <string>minute + ":" + <string>second; 
            log:printInfo("Serving Reqest No: " + globalRequestCounter + " End Time :" +endTime);
            json responseJson = {"Start Time":startTime, "End Time":endTime,"Sleep Time(seconds)":sleeptime,"Wake Up":"Yes","Service Number":globalRequestCounter};
            res.setJsonPayload(responseJson);//send back the response with time information of the service execution 
            _ = res.send();
        }
}
```

The service is defined as `service<http> sleep_and_wakeup` in this example. First, the query parameter `sleeptime` is extracted from the Request `req.getQueryParams()`. Then the program will sleep for `sleeptime` seconds in the `sleep(slpTime*1000)` line. Finally, the response is sent back to the client with the start time and the end time of processing the request.

### Running Service in Command-line
You can run the ballerina service/application from the command line. Execute the following command to compile and execute the ballerina program.

```
$ballerina run sleepAndReply.bal
```

Following commands will compile the ballerina program and run. Note that compiler will create a .balx file, which is the executable binary of the service/application upon execution of **build** command.

```
$ballerina build sleepAndReply.bal
$balleina run sleepAndReply.balx
```

### Running Service in Composer
Start Composer https://ballerinalang.org/docs/quick-tour/quick-tour/#run-the-composer

Navigate to File -> Open Program Directory, and pick the project folder (ballerina-asynchronous-interactions-example).

Click on **Run**(Ctrl+Shift+R) button in the tool bar.

![alt text](https://github.com/rosensilva/ballerina-samples/blob/master/ballerina-asynchronous-interactions-example/images/Screenshot%20from%202017-12-21%2014-08-00.png)


### Running in Intellij IDEA
Refer https://github.com/ballerinalang/plugin-intellij/tree/master/getting-started to setup your IntelliJ IDEA environment with Ballerina.
Open hello-ballerina project in IntelliJ IDEA and run sleepAndReply.bal

![alt text](https://github.com/rosensilva/ballerina-samples/blob/master/ballerina-asynchronous-interactions-example/images/intelij-sleepandwake.png)


### Running in VSCode
<TODO>


## Test the Service
Now that the service is up, http://localhost:9090/sleep_and_wakeup URL can be used to test the service by sending requests, 
```
http://localhost:9090/sleep_and_wakeup?sleeptime=10
http://localhost:9090/sleep_and_wakeup?sleeptime=5
http://localhost:9090/sleep_and_wakeup?sleeptime=2
```
The native support for asynchronous interactions in Ballerina can be experienced by sending a large number of requests to the same resource concurrently. The ballerina service resource will send the response according to each requests `sleeptime`timeout. The responses will look similar,
```
{
    "Start Time": "Time: 14:22:43",
    "End Time": "Time: 14:22:48",
    "Sleep Time(seconds)": "5",
    "Wake Up": "Yes",
    "Service Number": 1
}
```
The terminal of service will display the request details as Log at Info level,

```
ballerina: deploying service(s) in 'sleepAndReply.bal'
ballerina: started HTTP/WS server connector 0.0.0.0:9090
2017-12-21 14:22:43,201 INFO  [] - Serving Reqest No: 1 Start Time :Time: 14:22:43 
2017-12-21 14:22:48,204 INFO  [] - Serving Reqest No: 1 End Time :Time: 14:22:48 
2017-12-21 15:04:14,829 INFO  [] - Serving Reqest No: 2 Start Time :Time: 15:4:14 
2017-12-21 15:04:15,835 INFO  [] - Serving Reqest No: 2 End Time :Time: 15:4:15 
2017-12-21 15:04:17,527 INFO  [] - Serving Reqest No: 3 Start Time :Time: 15:4:17 
2017-12-21 15:04:20,275 INFO  [] - Serving Reqest No: 4 Start Time :Time: 15:4:20 
2017-12-21 15:04:30,276 INFO  [] - Serving Reqest No: 4 End Time :Time: 15:4:30 
2017-12-21 15:04:37,529 INFO  [] - Serving Reqest No: 4 End Time :Time: 15:4:37 


```

## Writing Test cases

## Creating Documentation

## Run Service on Docker

## Run Service on Cloud Foundry


