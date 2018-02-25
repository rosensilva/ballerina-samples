package ecommerce_backend;

import ballerina.net.http;

int count = 0;

@http:configuration {basePath:"/browse", port:9092}
service<http> ecommerceService {

    @http:resourceConfig {
        methods:["GET"],
        path:"/items/{item_id}"
    }
    resource findItems (http:Connection httpConnection, http:InRequest request, string item_id) {
        count = count + 1;
        println(count);
        if (count % 5 != 4) {
            //while (true) {
            //    println(    "Waiting");
            //    sleep(500);
            //}
            sleep(10000);
        }
        json itemDetails = {
                               "itemId":item_id,
                               "brand":"ABC",
                               "condition":"New",
                               "itemLocation":"USA",
                               "marketingPrice":"$100",
                               "seller":"XYZ"
                           };

        http:OutResponse response = {};
        response.setJsonPayload(itemDetails);
        _ = httpConnection.respond(response);
    }
}
