# Using WebSockets to develop interactive web application
[WebSockets](https://tools.ietf.org/html/rfc6455) is a computer communications protocol that allows you to open an interactive communication session between the user's browser and a server. With WebSockets, you can send messages to a server and receive responses based on events without having to query the server for a response.

## <a name="what-you-build"></a>  What you'll build
You'll build Chat Application using WebSockets. We will develop the chat application server completely using Ballerina. For the browser client, we will use JavaScript and HTML.

&nbsp;
![alt text](https://github.com/rosensilva/ballerina-samples/blob/master/web-socket-sample/images/chat_application_ui.png)
&nbsp; 

## <a name="pre-req"></a> Prerequisites
 
* JDK 1.8 or later
* [Ballerina Distribution](https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
* A Text Editor or an IDE

Optional Requirements
- Ballerina IDE plugins. ( [IntelliJ IDEA](https://plugins.jetbrains.com/plugin/9520-ballerina), [VSCode](https://marketplace.visualstudio.com/items?itemName=WSO2.Ballerina), [Atom](https://atom.io/packages/language-ballerina))
- [Docker](https://docs.docker.com/engine/installation/)

## <a name="develop-app"></a> Develop the application
### Before you begin

#### Understand the project structure
The package structure would look similar to the following,

```
├── chatserver
│   └── chat_app.bal
└── chat_web_client
    ├── bootstrap-3
    │   ├── css
    │   │   └── bootstrap.min.css
    │   └── js
    │       └── bootstrap.min.js
    └── index.html

```
The `chatserver` is the package for the chat application server side implementation. The `chat_web_client` is the web client for the chat application. This guide will more elobarate on the serverside implementation of chat application using WebSocket support in Ballerina. 

### Implementation of the Chat Application using WebSockets

Now we have the Ballerina web service skeleton file. We only need to add the business logic inside each resource. For simplicity, we will use an in-memory map to store the pet data. The following code is the completed pet store web service implementation. 

#### chat_app.bal
```ballerina
package chatserver;

import ballerina.io;
import ballerina.net.ws;


@ws:configuration {
    basePath:"/chat/{name}",
    port:9090
}
service<ws> ChatApp {
    // In-memory map to store web socket connections
    map consMap = {};

    // This resource will trigger when a new web socket connection is open
    resource onOpen (ws:Connection conn, string name) {
        // Add the new connection to the connection map
        consMap[conn.getID()] = conn;
        // Get the query parameters and path parameters to send greeting message
        map params = conn.getQueryParams();
        var age, err = (string)params.age;
        string msg;
        if (err == null) {
            msg = string `{{name}} with age {{age}} connected to chat`;
        } else {
            msg = string `{{name}} connected to chat`;
        }
        // Broadcast the "new user connected" message to existing connections
        broadcast(consMap, msg);
    }

    // This resource wil trigger when a new text message arrives to the server
    resource onTextMessage (ws:Connection con, ws:TextFrame frame, string name) {
        // Create the message
        string msg = string `{{name}}: {{frame.text}}`;
        io:println(msg);
        // Broadcast the message to existing connections
        broadcast(consMap, msg);
    }

    // This resource will trigger when a existing connection closed
    resource onClose (ws:Connection con, ws:CloseFrame frame, string name) {
        // Create the client left message
        string msg = string `{{name}} left the chat`;
        // Remove the connection from the connection map
        consMap.remove(con.getID());
        // Broadcast the client left message to existing connections
        broadcast(consMap, msg);
    }
}

// Custom function to send the test to all connections in the connection map
function broadcast (map consMap, string text) {
    // Iterate through all available connections in the connections map
    foreach wsConnection in consMap {
        var con, _ = (ws:Connection)wsConnection;
        // Send the text message to the connection
        con.pushText(text);
    }
}
```

With that, we have completed the implementation of the Chat Application.

## <a name="testing"></a> Testing 

### <a name="invoking"></a> Invoking the RESTful service 

You can run the RESTful service that you developed above, in your local environment. You need to have the Ballerina installation on your local machine and simply point to the <ballerina>/bin/ballerina binary to execute all the following steps.  

1. As the first step, you can build a Ballerina executable archive (.balx) of the service that we developed above, using the following command. It points to the directory structure of the service that we developed above and it will create an executable binary out of that. 

```
$ ballerina build guide/petstore/

```

2. Once the petstore.balx is created, you can run that with the following command. 

```
$ ballerina run petstore.balx  
```

3. The successful execution of the service should show us the following output. 
```
ballerina: deploying service(s) in 'petstore.balx'
ballerina: started HTTP/WS server connector 0.0.0.0:9090

```

4. You can test the functionality of the pet store RESTFul service by sending HTTP request for each operation. For example, we have used the curl commands to test each operation of pet store as follows. 

**Add a new pet** 
```
curl -X POST -d '{"id":"1", "catogery":"dog", "name":"doggie"}' 
"http://localhost:9090/v1/pet/" -H "Content-Type:application/json"

Output :  
Pet added successfully : Pet ID = 1
```

**Retrieve pet data** 
```
curl "http://localhost:9090/v1/pet/1"

Output:
{"id":"1","catogery":"dog","name":"Updated"}
```

**Update pet data** 
```
curl -X PUT -d '{"id":"1", "catogery":"dog-updated", "name":"Updated-doggie"}' 
"http://localhost:9090/v1/pet/" -H "Content-Type:application/json"

Output: 
Pet details updated successfully : id = 1
```

**Delete pet data** 
```
curl -X DELETE  "http://localhost:9090/v1/pet/1"

Output:
Deleted pet data successfully: Pet ID = 1
```

### <a name="unit-testing"></a> Writing Unit Tests 

In ballerina, the unit test cases should be in the same package and the naming convention should be as follows,
* Test files should contain _test.bal suffix.
* Test functions should contain test prefix.
  * e.g.: testPetStore()

This guide contains unit test cases in the respective folders. The test cases are written to test the pet store web service.
To run the unit tests, go to the sample root directory and run the following command
```bash
$ ballerina test guide/petstore/
```

## <a name="deploying-the-scenario"></a> Deployment

Once you are done with the development, you can deploy the service using any of the methods that we listed below. 

### <a name="deploying-on-locally"></a> Deploying Locally
You can deploy the RESTful service that you developed above, in your local environment. You can use the Ballerina executable archive (.balx) archive that we created above and run it in your local environment as follows. 

```
ballerina run petstore.balx 
```


### <a name="deploying-on-docker"></a> Deploying on Docker

You can use the Ballerina executable (.balx) archive that we created above and create a docker image by using the following command. 
```
ballerina docker pet_store.balx  
```

Once you have created the docker image, you can run it using docker run. 

```
docker run -p <host_port>:9090 --name ballerina_pet_store -d pet_store:latest
```

### <a name="deploying-on-k8s"></a> Deploying on Kubernetes
(Work in progress) 


## <a name="observability"></a> Observability 


### <a name="logging"></a> Logging
(Work in progress) 

### <a name="metrics"></a> Metrics
(Work in progress) 


### <a name="tracing"></a> Tracing 
(Work in progress) 
