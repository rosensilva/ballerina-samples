# Distributed Asynchronous Interaction Sample
This application is a lookup service that queries GitHub user information and retrieves data through GitHub’s API. 
Then this application retrieves the details about the public repositories using the previously received GitHub user information.
Finally the application will print the details of all the public repositories in the console log. This sample will 
lookup 3 outsource github projects and retrieves all the details asynchronously.
 
# How to run
1) Go to http://www.ballerinalang.org and click Download.
2) Download the Ballerina Tools distribution and unzip it on your computer. Ballerina Tools includes the Ballerina runtime plus
the visual editor (Composer) and other tools.
3) Add the <ballerina_home>/bin directory to your $PATH environment variable so that you can run the Ballerina commands from anywhere.
4) After setting up <ballerina_home>, run: `$ ballerina run asynchronous-sample.bal`
5) Output for the distributed-timeout-service application will look similar structure like,
    * Local timeout for each remote call is displayed as  - `INFO  [] - Local timeout for 1st remote procedure call 
    :3013ms` 
    * Each remote call delay is displayed as `INFO  [] - Responce delay for remote procedure call :1000ms`
    * Response for each RPC call is displayed as `INFO  [] - HTTP responce status code : 200 `
 

```
2018-01-09 09:37:04,951 INFO  [] - Distributed timeout demo program started... 
2018-01-09 09:37:04,955 INFO  [] - ---------------------------------------------------------------------------- 
2018-01-09 09:37:04,956 INFO  [] -                           TRIAL NO :1 
2018-01-09 09:37:04,957 INFO  [] - Local timeout for 1st remote procedure call :2064ms 
2018-01-09 09:37:04,961 INFO  [] - Responce delay for remote procedure call :2000ms 
2018-01-09 09:37:08,214 ERROR [] - Failed to get responce within local timeout 
2018-01-09 09:37:12,215 INFO  [] - ---------------------------------------------------------------------------- 
2018-01-09 09:37:12,217 INFO  [] -                           TRIAL NO :2 
2018-01-09 09:37:12,218 INFO  [] - Local timeout for 1st remote procedure call :2973ms 
2018-01-09 09:37:12,221 INFO  [] - Responce delay for remote procedure call :1000ms 
2018-01-09 09:37:14,392 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:14,394 INFO  [] - Local timeout for 2nd remote procedure call :3031ms 
2018-01-09 09:37:14,395 INFO  [] - Responce delay for remote procedure call :2000ms 
2018-01-09 09:37:17,624 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:17,626 INFO  [] - Local timeout for 3rd remote procedure call :3996ms 
2018-01-09 09:37:17,628 INFO  [] - Responce delay for remote procedure call :0ms 
2018-01-09 09:37:18,773 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:22,775 INFO  [] - ---------------------------------------------------------------------------- 
2018-01-09 09:37:22,777 INFO  [] -                           TRIAL NO :3 
2018-01-09 09:37:22,779 INFO  [] - Local timeout for 1st remote procedure call :2693ms 
2018-01-09 09:37:22,781 INFO  [] - Responce delay for remote procedure call :2000ms 
2018-01-09 09:37:25,749 ERROR [] - Failed to get responce within local timeout 
2018-01-09 09:37:29,751 INFO  [] - ---------------------------------------------------------------------------- 
2018-01-09 09:37:29,752 INFO  [] -                           TRIAL NO :4 
2018-01-09 09:37:29,753 INFO  [] - Local timeout for 1st remote procedure call :2425ms 
2018-01-09 09:37:29,755 INFO  [] - Responce delay for remote procedure call :0ms 
2018-01-09 09:37:30,993 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:30,995 INFO  [] - Local timeout for 2nd remote procedure call :3460ms 
2018-01-09 09:37:30,996 INFO  [] - Responce delay for remote procedure call :0ms 
2018-01-09 09:37:32,150 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:32,151 INFO  [] - Local timeout for 3rd remote procedure call :4115ms 
2018-01-09 09:37:32,153 INFO  [] - Responce delay for remote procedure call :1000ms 
2018-01-09 09:37:34,232 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:38,233 INFO  [] - ---------------------------------------------------------------------------- 
2018-01-09 09:37:38,234 INFO  [] -                           TRIAL NO :5 
2018-01-09 09:37:38,236 INFO  [] - Local timeout for 1st remote procedure call :3058ms 
2018-01-09 09:37:38,237 INFO  [] - Responce delay for remote procedure call :0ms 
2018-01-09 09:37:39,455 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:39,457 INFO  [] - Local timeout for 2nd remote procedure call :5828ms 
2018-01-09 09:37:39,459 INFO  [] - Responce delay for remote procedure call :2000ms 
2018-01-09 09:37:42,691 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:42,692 INFO  [] - Local timeout for 3rd remote procedure call :1114ms 
2018-01-09 09:37:42,694 INFO  [] - Responce delay for remote procedure call :1000ms 
2018-01-09 09:37:44,118 ERROR [] - Failed to get responce within local timeout 
2018-01-09 09:37:48,120 INFO  [] - ---------------------------------------------------------------------------- 
2018-01-09 09:37:48,121 INFO  [] -                           TRIAL NO :6 
2018-01-09 09:37:48,121 INFO  [] - Local timeout for 1st remote procedure call :3013ms 
2018-01-09 09:37:48,123 INFO  [] - Responce delay for remote procedure call :0ms 
2018-01-09 09:37:49,381 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:49,381 INFO  [] - Local timeout for 2nd remote procedure call :1687ms 
2018-01-09 09:37:49,383 INFO  [] - Responce delay for remote procedure call :0ms 
2018-01-09 09:37:50,597 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:50,598 INFO  [] - Local timeout for 3rd remote procedure call :5300ms 
2018-01-09 09:37:50,600 INFO  [] - Responce delay for remote procedure call :0ms 
2018-01-09 09:37:51,882 INFO  [] - HTTP responce status code : 200 
2018-01-09 09:37:55,883 INFO  [] - ---------------------------------------------------------------------------- 
```
