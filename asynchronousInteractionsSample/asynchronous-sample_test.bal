package asynchronousInteractionsSample;

import ballerina.test;

function testgetGitHubRepos () {
    json jsonResponse = getGitHubRepos("wso2");
    test:assertTrue(jsonResponse != null, "Github connection not working");
}