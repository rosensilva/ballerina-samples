# Ballerina RESTful API Sample
Following guide walk you through the step by step process of building a RESTful APIs with Ballerina.
Guide also explains the development and deployment workflow of a standard Ballerina Service in-detail.

## What you'll build
You’ll build a `Phone Book` service that will accept, 

##### HTTP GET requests at (view telephone numbers):
```
http://localhost:9090/phonebook/get_number/{Alice}
```
and respond with a JSON representation of a saved telephone contact number and name 
```json
{
    "Name": "Alice",
    "Number": "0123456789"
}
```

##### HTTP POST requests at (save new telephone numbers):
```
http://localhost:9090/phonebook/save_number?name=Alice&number=0123456789
```
and respond with a JSON representation of a saved telephone contact number, name and the status of the operation 
```json
{
    "Status": "Save Operation Success",
    "Name": "Alice",
    "Number": "0123456789"
}
```

##### HTTP PATCH requests at (change existing telephone numbers):
```
http://localhost:9090/phonebook/change_number?name=Alice&number=9876543210
```
and respond with a JSON representation of a modified telephone contact number, name and the status of the operation 
```json
{
    "Status": "Change Operation Success",
    "Name": "Alice",
    "Number": "9876543210"
}
```
##### HTTP DELETE requests at (delete existing telephone numbers):
```
http://localhost:9090/phonebook/delete_number?name=Alice
```
and respond with a JSON representation of a modified telephone contact number, name and the status of the operation 
```json
{
    "Status": "Delete Operation success",
    "Name": "Alice"
}
```

## Before you begin:  What you'll need
- About 15 minutes
- A favorite text editor or IDE
- JDK 1.8 or later
- Ballerina Distribution (Install Instructions:  https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
- You can import or write the code straight on your text editor/Ballerina Composer


## How to complete this guide
You can either start writing the service in Ballerina from scratch or by cloning the service to continue with the next steps.

To skip the basics:
Download and unzip the source repository for this guide in https://github.com/rosensilva/ballerina-samples/
Skip "Writing the Service" section

## Writing the Service
Create a new directory(Ex: ballerina-api-example). Inside the directory,create a new file in your text editor and copy the following content. Save the file with .bal extension (ex:phoneBookService.bal) 
```
ballerina-api-sample
   └── phoneBookService.bal
        └──util
            └──phoneBook.bal
```

##### phoneBookService.bal
```ballerina
import ballerina.net.http;
import util as phonebook;
import ballerina.log;

service<http> phonebook{
	@http:resourceConfig {
		methods:["GET"],	
        path:"/get_number/{name}"
	}
    resource getNumberResource (http:Request req, http:Response res, string name) {
       	string result = phonebook:getContact(name);
        json responseJson = {"Name":name,"Number":result};
        res.setJsonPayload(responseJson);
       	_ = res.send();
  	}

   	@http:resourceConfig {
    	methods:["POST"],
        path:"/save_number/"
    }
    resource saveContactResource (http:Request req, http:Response res) {
       	map params = req.getQueryParams();
       	var name, err1 = (string)params.name;
      	var num, err2 = (string)params.number;
      	string statusMsg = "";
       	int status = phonebook:saveContact(name,num);
       	if(status ==0){
        	statusMsg = "Save Operation Success";
        }
        else{
        	statusMsg = "Save Operation Failed";
        }
        json responseJson = {"Status":statusMsg,"Name":name, "Number":num};
        res.setJsonPayload(responseJson);
        _ = res.send();
 	}

   	@http:resourceConfig {
      	methods:["PATCH"],
       	path:"/change_number/"
    }
    resource changeNumberResource (http:Request req, http:Response res) {
      	map params = req.getQueryParams();
       	var name, _ = (string)params.name;
      	var num, _ = (string)params.number;
      	string statusMsg = "";
       	int status = phonebook:changeNumber(name,num);
       	if(status ==0){
       		statusMsg = "Change Operation Success";
       	}
       	else{
       		statusMsg = "Change Operation Failed";
        }
        json responseJson = {"Status":statusMsg,"Name":name, "Number":num};
        res.setJsonPayload(responseJson);
        _ = res.send();
   	}

    @http:resourceConfig {
		methods:["DELETE"],
        path:"/delete_number/"
    }
    resource deleteNumberResource (http:Request req, http:Response res) {
        map params = req.getQueryParams();
        var name, _ = (string)params.name;
        string statusMsg = "";
        int status = phonebook:deleteContact(name);
        if(status ==0){
         	statusMsg = "Delete Operation success";
        }
        else{
          	statusMsg = "Delete Operation failed";
        }
        json responseJson = {"Status":statusMsg,"Name":name};
        res.setJsonPayload(responseJson);
        _ = res.send();
	}
}
```

The service is written as "`` service<http> phonebook ``" in Ballerina. The service name (ex: phonebook) is used to direct the service through URL.

The http resource is configured by the following definition 
```
@http:resourceConfig {
	methods:["GET"],	
  	path:"/get_number/{name}"
}
```

The following code handles the http resource logic 
```
resource getNumberResource (http:Request req, http:Response res, string name) {
 	string result = phonebook:getContact(name);
    json responseJson = {"Name":name,"Number":result};
    res.setJsonPayload(responseJson);
    _ = res.send();
}
```


##### phoneBook.bal
```ballerina
package util;
import ballerina.log;
map phonebookDB = {};

public function saveContact(string key, string value)(int){
	phonebookDB[key]=value;	//save the contact to the phonebookDB map data stucture
	return 0;
}

public function getContact(string key)(string value){
	var result = phonebookDB[key];
	var resultString,err  = (string)result; //casting the results to a string using multivalue return for unsafe casting
	if(err == null){	//if there is no error while casting the result to a string return result
		return resultString;	
	}
	else{	//if casting cannot perform which means phonebookDB doesnot contain an value for that name send error msg
		string no_number = "Sorry! the numebr cannot be found at directory";
		log:printInfo("cannot find number in the map data structure");
		return no_number;
	}	
}

public function deleteContact(string key)(int){
	var result = phonebookDB[key];
	var resultString,err  = (string)result;
	if(err == null){	
		phonebookDB[key]=null;
		return 0;
	}
	else{
		log:printInfo("cannot find number in the map data structure");
		return 1;
	}
}

public function changeNumber(string key, string value)(int){
	var result = phonebookDB[key];
	var resultString,err  = (string)result;
	if(err == null){	
		phonebookDB[key]=value;
		return 0;
	}
	else{
		log:printInfo("cannot find number in the map data structure");
		return 1;
	}		
}
```

Services represent collections of network accessible entry points in Ballerina. Resources represent one such entry point. 
Ballerina supports writing RESTFul services according to JAX-RS specification. BasePath, Path and HTTP verb annotations such as POST, GET, etc can be used to constrain your service in RESTful manner.
Post annotation constrains the resource only to accept post requests. Similarly, for each HTTP verb there are different annotations. Path attribute associates a sub-path to resource.
Ballerina supports extracting values both from PathParam and QueryParam. Query Parameters are read from a map.
In ballerina you could define a response structure or a json inline in the code.

### Running Service in Command-line
You can run the ballerina service/application from the command line. Execute following command to compile and execute the ballerina program.

```
$ballerina run phoneBookService.bal
```

Following commands will compile the ballerina program and run. Note that compiler will create a .balx file, which is the executable binary of the service/application upon execution of **build** command.

```
$ballerina build phoneBookService.bal
$balleina run phoneBookService.balx
```

### Running Service in Composer
Start Composer https://ballerinalang.org/docs/quick-tour/quick-tour/#run-the-composer
Navigate to File -> Open Program Directory, and pick the project folder (ballerina-api-sample).

Click on **Run**(Ctrl+Shift+R) button in the tool bar.

![alt text](https://github.com/rosensilva/ballerina-samples/blob/master/ballerina-api-sample/images/phoneBook_composer.png)


### Running in Intellij IDEA
Refer https://github.com/ballerinalang/plugin-intellij/tree/master/getting-started to setup your IntelliJ IDEA environment with Ballerina.
Open hello-ballerina project in IntelliJ IDEA and run helloService.bal

![alt text](https://github.com/rosensilva/ballerina-samples/blob/master/ballerina-api-sample/images/phonebook_intellij_img.png)


### Running in VSCode
<TODO>


## Test the Service
Now that the service is up, send GET, PATCH, DELETE API call to http://localhost:9090/phonebook/ to 
+ Add new contacts
+ View existing contacts
+ Modify existing contacts
+ Delete existing contacts


## Writing Test cases

## Creating Documentation

## Run Service on Docker

## Run Service on Cloud Foundry


