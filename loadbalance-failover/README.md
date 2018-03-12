# Failover and Load Balancing
Load Balancing is efficiently distributing incoming network traffic across a group of backend servers and failover refers to a procedure by which a system automatically transfers control to a duplicate system when it detects a fault or failure. The combination of load balancing and failover techniques will create a highly available systems with eficiently distributing the workload amoung avaibale resources. Ballerina laguage supports load balancing and failover out-of-the-box.

> This guide walks you through the process of adding load balancing and failover for Ballerina programms.

The following are the sections available in this guide.

- [What you'll build](#what-you-build)
- [Prerequisites](#pre-req)
- [Developing the RESTFul service with load balancing and failover](#developing-service)
- [Testing](#testing)
- [Deployment](#deploying-the-scenario)
- [Observability](#observability)

## <a name="what-you-build"></a>  What you'll build

You’ll build a web service with loadbalancing and failover mechanisms. To understand this better, you'll be mapping this with a real world scenario of a book finding service. The book finding service will use three remote backends running three identical book store services to retrieve the book details.The failover and load balancing mechaisms help to balance the load amoung all the available remote servers.

&nbsp;
&nbsp;
&nbsp;
&nbsp;

![Load Balancer](images/load_balancer_image1.png)

&nbsp;
&nbsp;
&nbsp;

**Request book details from book search service**: To searcg a new book you can use the HTTP GET request that contains the book name as a path parameter.

## <a name="pre-req"></a> Prerequisites
 
- JDK 1.8 or later
- [Ballerina Distribution](https://github.com/ballerina-lang/ballerina/blob/master/docs/quick-tour.md)
- A Text Editor or an IDE 

### Optional requirements
- Ballerina IDE plugins ([IntelliJ IDEA](https://plugins.jetbrains.com/plugin/9520-ballerina), [VSCode](https://marketplace.visualstudio.com/items?itemName=WSO2.Ballerina), [Atom](https://atom.io/packages/language-ballerina))
- [Docker](https://docs.docker.com/engine/installation/)

## <a name="developing-service"></a> Developing the RESTFul service with circuit breaker

### Before you begin

#### Understand the package structure
The project structure for this guide should be as the following.

```
├── booksearchservice
│   └── book_search_service.bal
└── bookstorebacked
    └── book_store_service.bal
```

The `booksearchservice` is the service that handles the client orders to find books from book stores. Book search service call book store backeds to retrieve book details. You can find the loadbalancing and failover mechanisms are applied when the book search service calls three identical backend servers.

The `bookstorebacked` is an independent web service that accepts orders via HTTP POST method from `booksearchservice` and sends the details of the book back to the `booksearchservice`.

### Implementation of the Ballerina services

#### book_search_service.bal
The `ballerina.net.http.resiliency` package contains the load balancer implementation. After importing that package you can create an endpoint with a load balancer. The `endpoint` keyword in Ballerina refers to a connection with a remote service. Here you'll have three identical remote services to load balance across. First, you need to import ` ballerina.net.http.resiliency` package to use the loadbalancer. Next, create a LoadBalancer end point by ` create resiliency:LoadBalancer` statement. Then you need to create an array of HTTP Clients that you needs to be Loadbalanced across. Finally, pass the `resiliency:roundRobin` argument to the `create loadbalancer` constructor. Now whenever you call the `bookStoreEndPoints` remote HTTP endpoint, it goes through the failover and load balancer. 

```ballerina
package booksearchservice;

import ballerina.net.http.resiliency;
import ballerina.net.http;


@http:configuration {basePath:"book"}
service<http> bookSearchService {
    @http:resourceConfig {
    // Set the bookName as a path parameter
        path:"/{bookName}"
    }
    resource bookSearchService (http:Connection conn, http:InRequest req, string bookName) {
        // Define the end point to the book store backend
        endpoint<http:HttpClient> bookStoreEndPoints {
        // Crate a LoadBalancer end point
        // The LoadBalancer is defined in ballerina.net.http.resiliency package
            create resiliency:LoadBalancer(
            // Create an array of HTTP Clients that needs to be Loadbalanced across
            [create http:HttpClient("http://localhost:9011/book-store", {endpointTimeout:1000}),
             create http:HttpClient("http://localhost:9012/book-store", {endpointTimeout:1000}),
             create http:HttpClient("http://localhost:9013/book-store", {endpointTimeout:1000})],
            // Use the round robbin load balancing algorithm
            resiliency:roundRobin);
        }

        // Initialize the request and response messages for the remote call
        http:InResponse inResponse = {};
        http:HttpConnectorError httpConnectorError;
        http:OutRequest outRequest = {};

        // Set the json payload with the book name
        json requestPayload = {"bookName":bookName};
        outRequest.setJsonPayload(requestPayload);
        // Call the book store backend with loadbalancer enabled
        inResponse, httpConnectorError = bookStoreEndPoints.post("/", outRequest);
        // Send the response back to the client
        http:OutResponse outResponse = {};
        if (httpConnectorError != null) {
            outResponse.statusCode = httpConnectorError.statusCode;
            outResponse.setStringPayload(httpConnectorError.message);
            _ = conn.respond(outResponse);
        } else {
            _ = conn.forward(inResponse);
        }
    }
}

```

Refer to the complete implementaion of the orderService in the [loadbalancing-failover/booksearchservice/book_search_service.bal](/booksearchservice/book_search_service.bal) file.


#### book_store_service.bal
The book store service is a mock service that gives the details about the requested book. This service is a simple service that accepts,
HTTP POST requests with following json payload
```json
 {"bookName":"Name of the book"}
```
and resopond with the following JSON,

```json

{
 "Served by Data Ceter" : "1",
 "Book Details" : {
     "Title":"Book titile",
     "Author":"Stephen King",
     "ISBN":"978-3-16-148410-0",
     "Availability":"Available"
 }
}
```

Refer to the complete implementation of the book store service in the [loadbalance-failover/bookstorebacked/book_store_service.bal](bookstorebacked/book_store_service.bal) file.

## <a name="testing"></a> Testing 


### Try it out

1. Run book search service in the [loadbalancing-failover/booksearchservice/book_search_service.bal](/booksearchservice/book_search_service.bal) file.
    ```bash
    $ ballerina run booksearchservice/
   ```

2. Run the three instances of the book store service. Here, you have to enter the service port number in each service instance. You can pass the port number as parameter `Bport=<Port Number>`
   ``` bash
   curl -v -X POST -d '{ "items":{"1":"Basket","2": "Table","3": "Chair"}}' \
   "http://localhost:9090/order" -H "Content-Type:application/json"
   ```
   The order service sends a response similar to the following:
   ```
   Order Placed : {"Status":"Order Available in Inventory", \ 
   "items":{"1":"Basket","2":"Table","3":"Chair"}}
   ```
3. Shutdown the inventory service. Your order service now has a broken remote endpoint for the inventory service.

4. Invoke the orderService by sending an order via HTTP method.
   ``` bash
   curl -v -X POST -d '{ "items":{"1":"Basket","2": "Table","3": "Chair"}}' \ 
   "http://localhost:9090/order" -H "Content-Type
   ```
   The order service sends a response similar to the following:
   ```json
   {"Error":"Inventory Service did not respond","Error_message":"Connection refused, localhost-9092"}
   ```
   This shows that the order service attempted to call the inventory service and found that the inventory service is not available.

5. Invoke the orderService again soon after sending the previous request.
   ``` bash
   curl -v -X POST -d '{ "items":{"1":"Basket","2": "Table","3": "Chair"}}' \ 
   "http://localhost:9090/order" -H "Content-Type
   ```
   Now the Circuit Breaker is activated since the order service knows that the inventory service is unavailable. This time the order service responds with the following error message.
   ```json
   {"Error":"Inventory Service did not respond","Error_message":"Upstream service
   unavailable. Requests to upstream service will be suspended for 14451 milliseconds."}
   ```


### <a name="unit-testing"></a> Writing unit tests 

In Ballerina, the unit test cases should be in the same package and the naming convention should be as follows,
* Test files should contain the _test.bal suffix.
* Test functions should contain the test prefix.
  * e.g., testOrderService()

This guide contains unit test cases in the respective folders. The two test cases are written to test the `orderServices` and the `inventoryStores` service.
To run the unit tests, go to the sample root directory and run the following command
```bash
$ ballerina test orderServices/
```

```bash
$ ballerina test inventoryServices/
```

## <a name="deploying-the-scenario"></a> Deployment

Once you are done with the development, you can deploy the service using any of the methods listed below. 

### <a name="deploying-on-locally"></a> Deploying locally
You can deploy the RESTful service that you developed above in your local environment. You can use the Ballerina executable archive (.balx) that you created above and run it in your local environment as follows. 

```
$ ballerina run orderServices.balx 
```


```
$ ballerina run inventoryServices.balx 
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
