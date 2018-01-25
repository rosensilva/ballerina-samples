package util;
import ballerina.log;

map phoneBookDataMap = {};

public function saveContact (string key, string value) (int) {
    //save the contact to the phoneBookMap map data structure
    phoneBookDataMap[key] = value;
    return 0;
}

public function getContact (string key) (string) {
    var result = phoneBookDataMap[key];
    //casting the results to a string using multivalue return for unsafe casting
    var resultString, err = (string)result;
    if (err == null) {
        //check for any error while casting the result to a string return result
        return resultString;
    }
    else {
        //if casting cannot perform which means phoneBookMap doesn't contain an value for that name send error msg
        string noNumberString = "Sorry! the numebr cannot be found at directory";
        log:printInfo("cannot find number in the map data structure");
        return noNumberString;
    }
}

public function deleteContact (string key) (int) {
    var result = phoneBookDataMap[key];

    if (result != null) {
        phoneBookDataMap[key] = null;
        return 0;
    }
    else {
        log:printInfo("cannot find number in the map data structure");
        return 1;
    }
}

public function changeNumber (string key, string value) (int) {
    var result = phoneBookDataMap[key];

    if (result != null) {
        phoneBookDataMap[key] = value;
        return 0;
    }
    else {
        log:printInfo("cannot find number in the map data structure");
        return 1;
    }
}