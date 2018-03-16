package taskscheduler;

import ballerina.test;

function beforeTest () {

}

function afterTest () {

}

function testGetWeatherSummaryWithoutService () {
    var err = getWeatherSummary();
    test:assertTrue(err != null, "getWeatherSummary did not return the expected error");
}