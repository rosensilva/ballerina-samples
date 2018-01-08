import ballerina.net.http;
import connectors as conn;

int count = 0;

service<http> bank {
    endpoint<conn:bankDatabaseConnector> bankDB {
        create conn:bankDatabaseConnector();
    }

    @http:resourceConfig {
        methods:["POST"],
        path:"/transfer/"
    }
    resource transferResource (http:Request req, http:Response res) {
        if (count == 0) {
            bankDB.init();
        }
        count = count + 1;
        map params = req.getQueryParams();
        var from, _ = (string)params.from;
        var to, _ = (string)params.to;
        var amountStr, _ = (string)params.amount;
        var amount, _ = <int>amountStr;

        string status = bankDB.transferMoney(from, to, amount);

        res.setStringPayload(status);
        _ = res.send();
    }
}
