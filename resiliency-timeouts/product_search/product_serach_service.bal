package product_search;

import ballerina.net.http;

@http:configuration {basePath:"/products"}
service<http> productSearchService {
    endpoint<http:HttpClient> ecommerceEndpoint {
        create http:HttpClient("http://localhost:9092/browse/",
                               {endpointTimeout:500,
                                   retryConfig:{
                                                   count:1000,
                                                   interval:100
                                               }});
    }

    @http:resourceConfig {
        methods:["GET"],
        path:"/search"
    }
    resource searchProducts (http:Connection httpConnection, http:InRequest request) {
        map queryParams = request.getQueryParams();
        var requestedItem, _ = (string)queryParams.item;
        http:OutResponse response = {};
        http:OutRequest outRequest = {};
        http:InResponse inResponse = {};
        inResponse, _ = ecommerceEndpoint.get("/items/" + requestedItem, outRequest);
        response.setJsonPayload(inResponse.getJsonPayload());
        _ = httpConnection.respond(response);
    }
}
