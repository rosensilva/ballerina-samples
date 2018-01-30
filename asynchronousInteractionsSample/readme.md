# Distributed Asynchronous Interaction Sample
This application is a lookup service that queries GitHub user information and retrieves data through GitHub’s API. 
Then this application retrieves the details about the public repositories using the previously received GitHub user information.
Finally the application will print the details of all the public repositories in the console log. This sample will 
lookup 3 open-source github projects and retrieves all the details asynchronously.
 
# How to run
1) Go to http://www.ballerinalang.org and click Download.
2) Download the Ballerina Tools distribution and unzip it on your computer. Ballerina Tools includes the Ballerina runtime plus
the visual editor (Composer) and other tools.
3) Add the <ballerina_home>/bin directory to your $PATH environment variable so that you can run the Ballerina commands from anywhere.
4) After setting up <ballerina_home>, run: `$ ballerina run asynchronous-sample.bal`
5) Output for the Asynchronous Interaction Sample application will look similar structure like,
    
```
2018-01-30 09:50:49,423 INFO  [asynchronousInteractionsSample] - Requesting github user details of google... 
2018-01-30 09:50:49,423 INFO  [asynchronousInteractionsSample] - Requesting github user details of wso2... 
2018-01-30 09:50:49,423 INFO  [asynchronousInteractionsSample] - Requesting github user details of facebook... 
2018-01-30 09:50:51,934 INFO  [asynchronousInteractionsSample] - Recieved git user details of wso2 with repos url : https://api.github.com/users/wso2/repos 
2018-01-30 09:50:51,936 INFO  [asynchronousInteractionsSample] - Requesting git repos of user : wso2 ... 
2018-01-30 09:50:52,026 INFO  [asynchronousInteractionsSample] - Recieved git user details of google with repos url : https://api.github.com/users/google/repos 
2018-01-30 09:50:52,026 INFO  [asynchronousInteractionsSample] - Requesting git repos of user : google ... 
2018-01-30 09:50:53,038 INFO  [asynchronousInteractionsSample] - Recieved git user details of facebook with repos url : https://api.github.com/users/facebook/repos 
2018-01-30 09:50:53,040 INFO  [asynchronousInteractionsSample] - Requesting git repos of user : facebook ... 
2018-01-30 09:51:00,113 INFO  [asynchronousInteractionsSample] - Repos of user name : wso2
wso2/amazon-ecs-plugin : https://github.com/wso2/amazon-ecs-plugin
wso2/analytics-apim : https://github.com/wso2/analytics-apim
wso2/analytics-data-agents : https://github.com/wso2/analytics-data-agents
wso2/analytics-emm : https://github.com/wso2/analytics-emm
wso2/analytics-http : https://github.com/wso2/analytics-http
wso2/analytics-iots : https://github.com/wso2/analytics-iots
wso2/analytics-is : https://github.com/wso2/analytics-is
wso2/analytics-solutions : https://github.com/wso2/analytics-solutions
wso2/andes : https://github.com/wso2/andes
wso2/balana : https://github.com/wso2/balana
wso2/bam-data-publishers : https://github.com/wso2/bam-data-publishers
wso2/build-automation-artifacts : https://github.com/wso2/build-automation-artifacts
wso2/caramel : https://github.com/wso2/caramel
wso2/carbon-analytics : https://github.com/wso2/carbon-analytics
wso2/carbon-analytics-common : https://github.com/wso2/carbon-analytics-common
wso2/carbon-apimgt : https://github.com/wso2/carbon-apimgt
wso2/carbon-apimgt-everywhere : https://github.com/wso2/carbon-apimgt-everywhere
wso2/carbon-appmgt : https://github.com/wso2/carbon-appmgt
wso2/carbon-auth : https://github.com/wso2/carbon-auth
.
.
. 
2018-01-30 09:51:00,115 INFO  [asynchronousInteractionsSample] - Repos of user name : facebook
google/abpackage : https://github.com/google/abpackage
google/acai : https://github.com/google/acai
google/access-bridge-explorer : https://github.com/google/access-bridge-explorer
google/Accessibility-Test-Framework-for-Android : https://github.com/google/Accessibility-Test-Framework-for-Android
google/account-provisioning-for-google-apps : https://github.com/google/account-provisioning-for-google-apps
google/acme : https://github.com/google/acme
google/active-learning : https://github.com/google/active-learning
google/adapt-googleanalytics : https://github.com/google/adapt-googleanalytics
google/adb-sync : https://github.com/google/adb-sync
google/addlicense : https://github.com/google/addlicense
google/address-geocoder-js : https://github.com/google/address-geocoder-js
.
.
.
2018-01-30 09:51:00,118 INFO  [asynchronousInteractionsSample] - Repos of user name : google
facebook/360-Capture-SDK : https://github.com/facebook/360-Capture-SDK
facebook/android-jsc : https://github.com/facebook/android-jsc
facebook/augmented-traffic-control : https://github.com/facebook/augmented-traffic-control
facebook/bAbI-tasks : https://github.com/facebook/bAbI-tasks
facebook/between-meals : https://github.com/facebook/between-meals
facebook/bistro : https://github.com/facebook/bistro
facebook/BridgeIC : https://github.com/facebook/BridgeIC
facebook/buck : https://github.com/facebook/buck
facebook/C3D : https://github.com/facebook/C3D
facebook/caf8teen : https://github.com/facebook/caf8teen
facebook/Carmel-Starter-Kit : https://github.com/facebook/Carmel-Starter-Kit
.
.
.

```
