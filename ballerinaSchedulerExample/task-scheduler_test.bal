package ballerinaSchedulerExample;

import ballerina.test;

function testmain () {
    error testError;
    testError = scheduledDemoTask();
    println("ERROR PRINT");
    println(testError);
    println("ERROR PRINT DONE");
    test:assertTrue(testError == null, "error on scheduledDemoTas");
}
