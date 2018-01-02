import ballerina.task;
import ballerina.log;


function main (string[] args) {
 
    println("Scheduling Tasks Demo ...");

    var taskId, schedulerError = task:scheduleTimer(scheduledTask,
                                         taskError, {delay:500, interval:5000});

    if (schedulerError != null) {
        println("Timer scheduling failed: " + schedulerError.msg) ;
    }
    else {
        println("Task ID:" + taskId);
    }
}


function scheduledTask() returns (error e) {
    int hour;
    int minute;
    int second;
    int milliSecond;
    string timeString;
    
    try{
        Time time = currentTime();
        hour, minute, second, milliSecond = time.getTime();
        timeString = "Time: " + <string>hour + ":" + <string>minute + ":" + <string>second;
        log:printInfo("Current Time : "+ timeString);
    }
    
    catch(error err){
        e = {msg:"Scheduled task error : "+err.msg}; 
    }
    return;
}

function taskError(error e) {
    log:printError("[ERROR] Oops! something went wrong" + e.msg);
}
