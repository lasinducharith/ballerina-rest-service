package services;

import ballerina.test;
import ballerina.net.http;

function testHelloService () {
    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:9090/hello", {});
    }

    http:Request req = {};
    http:Response resp = {};
    string helloServiceURL = test:startService("helloService");
    resp, _ = httpEndpoint.get("?name=User", req);
    test:assertStringEquals(resp.getStringPayload(), "{\"id\":1,\"content\":\"Hello, User!\"}", "Response mismatch!");

}