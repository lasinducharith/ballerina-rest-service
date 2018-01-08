package services;

import ballerina.net.http;

@http:configuration {basePath:"/hello"}
service<http> helloService {

    int i = 1;
    @http:resourceConfig {
        methods:["GET"],
        path:"/"
    }
    resource sayHello (http:Request request, http:Response response) {
        string name = "Ballerina";
        // Retrieve query parameters in the request
        map params = request.getQueryParams();
        // Check for query parameter 'name'
        if (params["name"] != null) {
            name, _ = (string)params["name"];
        }
        // Use of string template to generate the response
        string responseTemplate = string `Hello, {{name}}!`;
        // Set response json payload before sending out
        response.setJsonPayload({"id":i, "content":responseTemplate});
        // Increment request count
        i = i + 1;
        _ = response.send();
    }
}