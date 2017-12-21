import ballerina.net.http;
import connectors as conn;
import weather.util as weatherUtil;
import ballerina.log;
    
service<http> travel {    
    @http:resourceConfig {
        methods:["GET"]
        
    }
    
    resource weather (http:Request req, http:Response res ) {
        
        var start="";
        var end="";
        var wa="";
        var waypoints=4;

        try{
            map params = req.getQueryParams();
        
            start, _ = (string)params.start;
            end, _ = (string)params.end;
            wa, _ = (string)params.waypoints;

            println("start : "+start + "end : "+end+ "waypoints : "+wa);
            
            waypoints,_ = <int> wa;
        
            if(waypoints<=0){
                error err = {msg:"waypoints should be a valid int"};
                throw err;
            }

            json retval = weatherUtil:getWeatherSummery(start,end,waypoints);
            
            res.setJsonPayload(retval);
            _ = res.send();
            log:printInfo("Completed request for trip from : "+ start + " to " + end);
        
        }

        catch(error err){
            println("error occured while processing user request: " + err.msg);
            log:printErrorCause("error log with cause", err);
            
            res.setJsonPayload({error:err.msg});
            _ = res.send();
        }     
    }
}




