# Ballerina RESTful Web Service
Following guide walks you through the step by step process of building a RESTful Web Service with Ballerina.
Guide also explains the development and deployment workflow of a standard Ballerina Service in-detail.

## What you'll build
You’ll build a Hello service that will accept HTTP GET requests at:
```
http://localhost:9090/hello
```
and respond with a JSON representation of a greeting
```
{"id":1,"content":"Hello, Ballerina!"}
```
You can customize the greeting with an optional name parameter in the query string:
```
http://localhost:9090/hello?name=User
```
The name parameter value overrides the default value of "Ballerina" and is reflected in the response:
```
{"id":1,"content":"Hello, User!"}
```
## Before you begin:  What you'll need
- About 15 minutes
- A favorite text editor or IDE
- JDK 1.8 or later
- Ballerina Distribution (Install Instructions:  https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
- You can import or write the code straight on your text editor/Ballerina Composer


## How to complete this guide
You can either start writing the service in Ballerina from scratch or by cloning the service to continue with the next steps.

To skip the basics:
Download and unzip the source repository for this guide in https://github.com/lasinducharith/ballerina-rest-service
Skip "Writing the Service" section

## Writing the Service
Create a new directory(Ex: hello-ballerina). Inside the directory,create a package(Ex: service). Package is another directory in the project hierarchy.
Create a new file in your text editor and copy following content. Save the file with .bal extension (ex:helloService.bal) 
```
hello-ballerina
   └── services
       └── helloService.bal
```

##### helloService.bal
```
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
```
Services represent collections of network accessible entry points in Ballerina. Resources represent one such entry point. 
Ballerina supports writing RESTFul services according to JAX-RS specification. BasePath, Path and HTTP verb annotations such as POST, GET, etc can be used to constrain your service in RESTful manner.
Post annotation constrains the resource only to accept post requests. Similarly, for each HTTP verb there are different annotations. Path attribute associates a sub-path to resource.

Ballerina supports extracting values both from PathParam and QueryParam. Query Parameters are read from a map.
A string template **responseTemplate** holds the response string. In ballerina you could define a response structure or a json inline in the code.

### Running Service in Command-line
You can run the ballerina service/application from the command line. Navigate to hello-ballerina directory and execute following command to compile and execute the ballerina program.

```
$ballerina run services/
```

Following commands will compile the ballerina program and run. Note that compiler will create a **.balx** file, which is the executable binary of the service/application upon execution of **build** command.
The executable will be created with name <package_name>.balx

```
$ballerina build services/
$balleina run services.balx
```
Console Output
```
ballerina: deploying service(s) in 'services'
ballerina: started HTTP/WS server connector 0.0.0.0:9090
```

### Running Service in Ballerina Composer
Start Composer https://ballerinalang.org/docs/quick-tour/quick-tour/#run-the-composer
Navigate to File -> Open Program Directory, and pick the project folder (hello-ballerina). Navigate to helloService.bal.

Click on **Run**(Ctrl+Shift+R) button in the tool bar.

![alt text](https://github.com/lasinducharith/ballerina-rest-service/raw/master/images/helloService_Composer.png)


### Running in Intellij IDEA
<TODO>

### Running in VSCode
<TODO>


## Test the Service
Now that the service is up, visit http://localhost:9090/hello where you see:
```
{"id":1,"content":"Hello, Ballerina!"}
```
Provide a name query parameter with http://localhost:9090/hello?name=User. Notice following response.
```
{"id":1,"content":"Hello, User!"}
```

## Writing Test cases

Create a new file inside services directory with name helloService_test.bal. Make sure your test file ends with _test.bal
Refer Testerina test framework for more information https://github.com/ballerinalang/testerina
```
hello-ballerina
   └── services
       ├── helloService.bal
       └── helloService_test.bal
```

##### helloService_test.bal
```
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
```

The test case start the helloService and sends a sample get request to the HTTP endpoint.
It also asserts if the response payload matches the expected result.

#### Running Test case

```
$ballerina test services/
```

Console output 
```
$ballerina test services/
ballerina: started HTTP/WS server connector 0.0.0.0:9090

result: 
tests run: 1, passed: 1, failed: 0
```

## Creating Documentation
<TODO>

## Run Service on Docker
<TODO>

## Run Service on Cloud Foundry
<TODO>


