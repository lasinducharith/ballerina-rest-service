package services;

import ballerina.net.http;

service<http> helloService {

    int i = 1;
    resource sayHello (http:Request request, http:Response response) {
        // Set response json payload before sending out
        response.setJsonPayload({"id":i, "content":"Hello Ballerina!"});
        // Increment request count
        i = i + 1;
        _ = response.send();
    }
}