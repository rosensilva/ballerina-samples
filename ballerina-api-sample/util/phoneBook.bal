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