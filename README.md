# Ballerina RESTful Web Service
Following guide walk you through the step by step process of building a RESTful Web Service with Ballerina.
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
Create a new directory(Ex: hello-ballerina). Inside the directory,create a new file in your text editor and copy the following content. Save the file with .bal extension (ex:helloService.bal) 
```
hello-ballerina
   └── helloService.bal
```

##### helloService.bal
```

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
You can run the ballerina service/application from the command line. Execute following command to compile and execute the ballerina program.

```
$ballerina run helloService.bal
```

Following commands will compile the ballerina program and run. Note that compiler will create a .balx file, which is the executable binary of the service/application upon execution of **build** command.

```
$ballerina build helloService.bal
$balleina run helloService.balx
```

### Running Service in Composer
Start Composer https://ballerinalang.org/docs/quick-tour/quick-tour/#run-the-composer
Navigate to File -> Open Program Directory, and pick the project folder (hello-ballerina).

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

## Creating Documentation

## Run Service on Docker

## Run Service on Cloud Foundry


