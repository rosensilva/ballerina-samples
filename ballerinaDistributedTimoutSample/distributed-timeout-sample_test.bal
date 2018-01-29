package ballerinaDistributedTimoutSample;

import ballerina.test;

function testhttpRemoteMockCall () {
    int responseCode = httpRemoteMockCall(10000);
    println(responseCode);
    test:assertIntEquals(responseCode, 200, "Unable to get response form postman-echo mock server");
}

