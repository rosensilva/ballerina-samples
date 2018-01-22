# RESTful API with OAuth2 authorization
This web service is a phone book web application that uses standard OAuth2 authorization framework. The RESTful APIs 
are protected using OAuth2 framework. The oauth2 connector is used for `oauth-secured-phonebook.bal` to communicate 
with oauth2 protected APIs. This application is capable of saving, changing, deleting telephone numbers.

# How to deploy
1) Go to http://www.ballerinalang.org and click Download.
2) Download the Ballerina Tools distribution and unzip it on your computer. Ballerina Tools includes the Ballerina runtime plus
the visual editor (Composer) and other tools.
3) Add the <ballerina_home>/bin directory to your $PATH environment variable so that you can run the Ballerina commands from anywhere.
4) After setting up <ballerina_home>, run: `$ ballerina run phone-book-service.bal`
5) Setup an API manager and protect the phone-book-service REST APIs.
6) Update the OAuth credentials and protected APIs at `oauth-secured-phonebook.bal1`
7) After setting up <ballerina_home>, run: `$ ballerina run oauth-secured-phonebook.bal`

#### Expected Output  
```$xslt
-----Calling POST method-----
{"Status":"Save Operation Success","Name":"Alice","Number":"123456789"}
-----Calling GET method-----
{"Name":"Alice","Number":"123456789"}
-----Calling DELETE method-----
{"Status":"Delete Operation success","Name":"Alice"}

Process finished with exit code 0
```