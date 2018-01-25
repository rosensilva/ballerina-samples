import ballerina.net.http;
import connectors.bank as bankDatabaseConnector;

int count = 0;

service<http> bank {
    endpoint<bankDatabaseConnector:bankDatabaseConnector> bankDB {
        create bankDatabaseConnector:bankDatabaseConnector();
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/transfer/"
    }
    resource transferResource (http:Request req, http:Response res) {
        if (count == 0) {
            //call the init action for one time to create database tables and populate values
            bankDB.init();
        }
        count = count + 1;

        map params = req.getQueryParams();
        var from, _ = (string)params.from;
        var to, _ = (string)params.to;
        var amountString, _ = (string)params.amount;
        var amount, _ = <int>amountString;
        //call the transferMoney action from bankDatabaseConnector
        string status = bankDB.transferMoney(from, to, amount);
        //send the response back to the client with the status of the transaction
        res.setStringPayload(status);
        _ = res.send();
    }
}