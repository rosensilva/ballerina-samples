import ballerina.task;
import ballerina.log;

function main (string[] args) {
    println("Scheduling Tasks Demo ...");
    //Starting the scheduled tasks with a 5 second interval by calling scheduleTimer in the ballerina.task package
    var taskId, schedulerError = task:scheduleTimer(scheduledDemoTask, taskError, {delay:500, interval:5000});

    if (schedulerError != null) {
        println("Timer scheduling failed: " + schedulerError.msg);
    }
    else {
        println("Task ID:" + taskId);
    }
}

function scheduledDemoTask () returns (error e) {
    int hour;
    int minute;
    int second;
    int milliSecond;
    string timeString;

    try {
        //Get the current time and log the current time
        Time time = currentTime();
        hour, minute, second, milliSecond = time.getTime();
        timeString = "Time: " + <string>hour + ":" + <string>minute + ":" + <string>second;
        log:printInfo("Current Time : " + timeString);
    }

    catch (error err) {
        e = {msg:"Scheduled task error : " + err.msg};
    }
    return;
}

function taskError (error e) {
    log:printError("[ERROR] Something went wrong " + e.msg);
}