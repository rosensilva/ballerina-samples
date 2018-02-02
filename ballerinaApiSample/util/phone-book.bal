package util;
import ballerina.log;

map phoneBookDataMap = {};

public function saveContact (string name, string number) (int) {
    //save the contact to the phoneBookMap map data structure
    phoneBookDataMap[name] = number;
    return 0;
}

public function getContact (string name) (string) {
    var result = phoneBookDataMap[name];
    //casting the results to a string using multivalued return for unsafe casting
    var resultString, err = (string)result;
    if (err == null) {
        //if no casting error occurred, return the result
        return resultString;
    }
    else {
        //if phoneBookMap doesn't contain an value for that name send error msg
        string noNumberString = "Sorry! the numebr cannot be found at directory";
        return noNumberString;
    }
}

public function deleteContact (string name) (int) {
    var result = phoneBookDataMap[name];

    if (result != null) {
        phoneBookDataMap[name] = null;
        return 0;
    }
    else {
        log:printInfo("cannot find number in the map data structure");
        return 1;
    }
}

public function changeNumber (string name, string number) (int) {
    var result = phoneBookDataMap[name];

    if (result != null) {
        phoneBookDataMap[name] = number;
        return 0;
    }
    else {
        log:printInfo("cannot find number in the map data structure");
        return 1;
    }
}