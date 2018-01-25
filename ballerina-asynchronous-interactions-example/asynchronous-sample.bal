import ballerina.log;
import connectors.github as gitConnector;

public function main (string[] args) {
    //list of github users to retrieve their git repositories
    string[] userList = ["wso2", "facebook", "google"];
    //using fork and join constructs executing tasks asynchronously for each git account
    fork {
        worker w1 {
            log:printInfo("Requesting github user details of " + userList[0] + "...");
            json reposDetails = getGitHubRepos(userList[0]);
            reposDetails -> fork;
        }
        worker w2 {
            log:printInfo("Requesting github user details of " + userList[1] + "...");
            json reposDetails = getGitHubRepos(userList[1]);
            reposDetails -> fork;
        }
        worker w3 {
            log:printInfo("Requesting github user details of " + userList[2] + "...");
            json reposDetails = getGitHubRepos(userList[2]);
            reposDetails -> fork;
        }
    }
    join (all) (map results) {
        int count;
        //processing received data from all the asynchronous calls
        foreach result in results {
            var response, _ = (any[])result;
            string repoDetails = "Repos of user name : " + userList[count] + "\n";
            var jsonResponse, _ = (json)response[0];
            foreach item in jsonResponse {
                repoDetails = repoDetails + item.full_name.toString() + " : " + item.html_url.toString() + "\n";
            }
            log:printInfo(repoDetails);
            count = count + 1;
        }
    }
}

public function getGitHubRepos (string userName) (json) {
    endpoint<gitConnector:GitHubConnector> githubEndPoint {
        create gitConnector:GitHubConnector();
    }
    //get the user details of userName argument by calling Github API
    json jsonResponse;
    string statusString;
    jsonResponse = githubEndPoint.getUserDetails(userName);
    statusString = "Recieved git user details of " + userName + " with repos url : " + jsonResponse.repos_url.toString();
    log:printInfo(statusString);

    //use the repos url to access the repos of the user
    log:printInfo("Requesting git repos of user : " + userName + " ...");
    jsonResponse = githubEndPoint.getReposByUrl(jsonResponse.repos_url.toString());
    return jsonResponse;
}