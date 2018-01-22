package services;

import ballerina.test;
import ballerina.net.http;

function testHelloService () {

    endpoint<http:HttpClient> httpEndpoint {
        create http:HttpClient("http://localhost:9090/helloService", {});
    }

    http:Request req = {};
    http:Response resp = {};
    // Start helloService
    _ = test:startService("helloService");
    // Send a GET request to helloService
    resp, _ = httpEndpoint.get("/sayHello", req);
    // Assert Response
    test:assertStringEquals(resp.getStringPayload(), "{\"id\":1,\"content\":\"Hello Ballerina!\"}",
                            "Response mismatch!");

}