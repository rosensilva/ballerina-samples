# Database Backed RESTful Web Service
This guide walks you through the process of adding circuit breaker pattern to potentially-failing remote backend web services.

## <a name="what-you-build"></a>  What you'll build
You'll build an order processing service for a retail store. The retail store have a potentially-failing remote backend for inventory management. When a specific order comes to the order processing service, the service will call the inventory management service to check the avaibalility of items. The circuit breaker is configured to handle the faliures of inventory management service.  

&nbsp;
&nbsp;
&nbsp;
&nbsp;

![alt text](https://github.com/rosensilva/ballerina-samples/blob/master/circuit-breaker/images/circuit_breaker_image.png)

&nbsp;
&nbsp;
&nbsp;

- **Place orders through retail store** : To place a new order you can use the HTTP POST message that contains the order details

## <a name="pre-req"></a> Prerequisites
 
- JDK 1.8 or later
- Ballerina Distribution (Install Instructions:  https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
- A Text Editor or an IDE 

Optional Requirements
- Docker (Follow instructions in https://docs.docker.com/engine/installation/)
- Ballerina IDE plugins. ( Intellij IDEA, VSCode, Atom)
- Testerina (Refer: https://github.com/ballerinalang/testerina)
- Container-support (Refer: https://github.com/ballerinalang/container-support)
- Docerina (Refer: https://github.com/ballerinalang/docerina)

## <a name="developing-service"></a> Develop the RESTFul service with circuit breaker
### Before you begin

##### Understand the package structure
Ballerina is a complete programming language that can have any custom project structure as you wish. Although language allows you to have any package structure, we'll stick with the following package structure for this project.

```
├── orderService
│   ├── order_service.bal
│   └── order_service_test.bal
└── inventoryStore
    ├── inventory_service.bal
    └── inventory_service_test.bal
```

The `orderService` is the service that gets the client orders. Order service is configured with circuit breaker to deal with the potentially-failing remote inventory management service.
The `inventoryStore` is an independent web service that accepts orders via HTTP POST method from `orderService` and send the availablity of order items.

### Develop the Ballerina orderService
Ballerina language has built-in support for writing web services. The `service` keyword in ballerina simply defines a web service. Inside the service block, we can have all the required resources. You can define a resource using `resource` keyword in Ballerina. We can implement the business logic inside a resource block using Ballerina language syntaxes.

```ballerina
package orderService;

import ballerina.log;
import ballerina.net.http.resiliency;
import ballerina.net.http;

@http:configuration {basePath:"/order"}
service<http> orderService {
    endpoint<resiliency:CircuitBreaker> circuitBreakerEP {
        create resiliency:CircuitBreaker(create http:HttpClient("http://localhost:9092"), 0.2, 20000);
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/"
    }
    resource orderResource (http:Connection httpConnection, http:InRequest request) {
        // Initialize the request and response message to send to the inventory service
        http:OutResponse outResponse = {};
        http:OutRequest outRequest = {};
        // Initialize the response message to send back to client
        http:InResponse inResponse = {};
        http:HttpConnectorError err;
        // Extract the items from the json payload
        json items = request.getJsonPayload().items;
        // Send bad request message to the client if request don't contain items JSON
        if (items == null) {
            outResponse.setStringPayload("Error : Please check the input json payload");
            outResponse.statusCode = 400;
            _ = httpConnection.respond(outResponse);
            return;
        }
        log:printInfo("Recieved Order : " + items.toString());
        // Set the outgoing request JSON payload with items
        outRequest.setJsonPayload(items);
        // Call the inventory backend with the item list
        inResponse, err = circuitBreakerEP.post("/inventory", outRequest);
        // If inventory backend contain errors forward the error message to client
        if (err != null) {
            log:printInfo("Inventory service returns an error :" + err.msg);
            outResponse.setJsonPayload({"Error":"Inventory Service did not respond", "Error_message":err.msg});
            _ = httpConnection.respond(outResponse);
            return;
        }
        // Send response to the client if the order placement was successful
        outResponse.setStringPayload("Order Placed : " + inResponse.getJsonPayload().toString());
        _ = httpConnection.respond(outResponse);
    }
}

```

Please refer `ballerina-guides/resiliency-circuit-breaker/orderService/order_service.bal` file for the complete implementaion of orderService.


### Develop the Ballerina inventoryStore service
```ballerina 
package inventoryStore;

import ballerina.log;
import ballerina.net.http;

@http:configuration {basePath:"/inventory", port:9092}
service<http> inventoryService {
    @http:resourceConfig {
        methods:["POST"],
        path:"/"
    }
    resource inventoryResource (http:Connection httpConnection, http:InRequest request) {
        // Initialize the response message that needs to send back to callee
        http:OutResponse response = {};
        // Extract the items list from the request JSON payload
        json items = request.getJsonPayload();
        log:printInfo("Checking the order items : " + items.toString());
        // Prepare the response message
        json responseJson = {"Status":"Order Available in Inventory", "items":items};
        response.setJsonPayload(responseJson);
        // Send the response to the callee
        _ = httpConnection.respond(response);
    }
}

```

## <a name="testing"></a> Testing 

### <a name="invoking"></a> Invoking the RESTful service 
### <a name="unit-testing"></a> Writing Unit Tests 

In ballerina, the unit test cases should be in the same package and the naming convention should be as follows,
* Test files should contain _test.bal suffix.
* Test functions should contain test prefix.
  * e.g.: testOrderService()

This guide contains unit test cases in the respective folders. The two test cases are written to test the `orderService` and the `inventoryStore` service.
To run the unit tests, go to the sample root directory and run the following command
```bash
$ ballerina test orderService/
```

```bash
$ ballerina test inventoryStore/
```

## <a name="deploying-the-scenario"></a> Deployment

Once you are done with the development, you can deploy the service using any of the methods that we listed below. 

### <a name="deploying-on-locally"></a> Deploying Locally
You can deploy the RESTful service that you developed above, in your local environment. You can use the Ballerina executable archive (.balx) archive that we created above and run it in your local environment as follows. 

```
ballerina run orderService.balx 
```


```
ballerina run inventoryStore.balx 
```

### <a name="deploying-on-docker"></a> Deploying on Docker
(Work in progress) 

### <a name="deploying-on-k8s"></a> Deploying on Kubernetes
(Work in progress) 


## <a name="observability"></a> Observability 

### <a name="logging"></a> Logging
(Work in progress) 

### <a name="metrics"></a> Metrics
(Work in progress) 


### <a name="tracing"></a> Tracing 
(Work in progress) 
