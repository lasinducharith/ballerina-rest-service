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
        map params = request.getQueryParams();
        if (params["name"] != null) {
            name, _ = (string)params["name"];
        }
        string responseTemplate = string `Hello, {{name}}!`;
        response.setJsonPayload({"id":i, "content":responseTemplate});
        i = i + 1;
        _ = response.send();
    }
}