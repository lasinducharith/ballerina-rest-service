# Developing and Deploying a Ballerina RESTful Web Service
Following guide walks you through the step by step process of building a RESTful Web Service with Ballerina.
It also explains the development and deployment workflow of a simple standard Ballerina Service.

- [What we'll build](#What-we-ll-build)
- [Before beginning:  What we'll need](#what-we-ll-need)
- [Setting up tools](#setting-up-tools)
  - [Ballerina Composer](#ballerina-composer)
  - [Intellij Idea](#intellij-idea)
  - [VSCode](#vscode)
- [Writing the Service](#writing-the-service)
- [Running the Service](#running-the-service)
- [Testing the Service](#testing-service)
  - [Invoking the service](#invoking-the-service)
  - [Writing test cases](#writing-test-cases)
- [Creating Documentation](#creating-documentation)
- [Deploying the Service](#deploying-the-service)  
  - [Deploying on Docker](#deploying-on-docker)
  - [Deploying on Kubernetes](#deploying-on-kubernetes)


## <a name="What-we-ll-build"></a> What we'll build
We’ll build a Hello service that will accept HTTP GET requests at:
```
http://localhost:9090/helloService/sayHello
```
and respond with a JSON representation of a greeting with a request ID.
```
{"id":1,"content":"Hello, Ballerina!"}
```

In the next steps, we'll run, test, document and deploy the service to cover the complete workflow of developing and deploying an service.

## <a name="what-we-ll-need"></a> Before beginning:  What we'll need
- About 45 minutes
- JDK 1.8 or later
- Ballerina Distribution (Install Instructions:  https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
- Docker (Follow instructions in https://docs.docker.com/engine/installation/)
- Ballerina Composer (optional). Refer instructions in https://ballerinalang.org/docs/quick-tour/quick-tour/#run-the-composer
- Intellij IDEA (optional). https://github.com/ballerinalang/plugin-intellij/tree/master/getting-started
- Testerina (Refer: https://github.com/ballerinalang/testerina)
- Container-support (Refer: https://github.com/ballerinalang/container-support)
- Docerina (Refer: https://github.com/ballerinalang/docerina)

## <a name="setting-up-tools"></a> Setting up tools

### <a name="ballerina-composer"></a> Ballerina Composer

The Ballerina Composer provides a flexible and powerful browser-based tool for creating your Ballerina programs. 
This section only describes how to open and execute already created .bal files, but ballerina composer is intended to be used for visually developing an integration. 

Start Composer https://ballerinalang.org/docs/quick-tour/quick-tour/#run-the-composer

### <a name="intellij-idea"></a> Intellij IDEA

Refer https://github.com/ballerinalang/plugin-intellij/tree/master/getting-started to setup your IntelliJ IDEA environment for Ballerina.

### <a name="vscode"></a> VSCode

## <a name="writing-the-service"></a> Writing the Service
Create a new directory(Ex: hello-ballerina). Inside the directory, create a package(Ex: services). Ballerina package is another directory in the project hierarchy.
Create a new file in your text editor and copy following content. Save the file with .bal extension (ex:helloService.bal) 
```
hello-ballerina
   └── services
       └── hello-service.bal
```

##### helloService.bal
```ballerina
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
```
Services represent collections of network accessible entry points in Ballerina. Resources represent one such entry point. 
Ballerina supports writing RESTFul services according to JAX-RS specification. BasePath, Path and HTTP verb annotations such as POST, GET, etc can be used to constrain your service in RESTful manner.
Post annotation constrains the resource only to accept post requests. Similarly, for each HTTP verb there are different annotations. Path attribute associates a sub-path to resource.

There is an incremental counter which returns the *id*, in the response.

## <a name="running-the-service"></a> Running the Service

You can run the ballerina service/application from the command line. Navigate to hello-ballerina directory and execute following command to compile and execute the ballerina program.

```
$ballerina run services/
```

Following commands will compile the ballerina program and run. Note that compiler will create a **.balx** file, which is the executable binary of the service/application upon execution of **build** command.
The executable will be created with name <package_name>.balx. The balx file will package all the ballerina files inside the package/directory to a single executable binary file.

```
$ballerina build services/
$balleina run services.balx
```
Console Output
```
ballerina: deploying service(s) in 'services'
ballerina: started HTTP/WS server connector 0.0.0.0:9090
```

## <a name="testing-service"></a> Testing the service

### <a name="invoking-the-service"></a> Invoking the Service
Now that the service is up, visit http://localhost:9090/helloService/sayHello where you see:
```
{"id":1,"content":"Hello, Ballerina!"}
```
If not send a GET request from curl/postman to test if the service is running.

### <a name="writing-test-cases"></a> Writing Test cases

Create a new ballerina file inside *services* directory (Ex:helloService_test.bal). Make sure your test file ends with _test.bal to mark it as a testerina file.
Refer Testerina Test framework for more information https://github.com/ballerinalang/testerina
```
hello-ballerina
   └── services
       ├── hello-service.bal
       └── hello-service_test.bal
```

##### helloService_test.bal
```ballerina
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
    string helloServiceURL = test:startService("helloService");
    // Send a GET request to helloService
    resp, _ = httpEndpoint.get("/sayHello", req);
    // Assert Response
    test:assertStringEquals(resp.getStringPayload(), "{\"id\":1,\"content\":\"Hello Ballerina!\"}",
                            "Response mismatch!");

}
```

The test package contains functions to start a service and assert results. The test case start the helloService and sends a sample get request to the HTTP endpoint.
It also asserts if the response payload matches the expected result, using test function **assertStringEquals**.

#### Running test case

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

#### Running test case using .balx

```
$ballerina build services/
$ballerina test services.balx
```

## <a name="creating-documentation"></a> Creating Documentation

Cannot generate docs for files inside a ballerina package
https://github.com/ballerinalang/docerina/issues/143


## <a name="deploying-the-service"></a> Deploying the Service
### <a name="deploying-on-docker"></a> Deploying on Docker

Container support for Ballerina provides the implementation for packaging Ballerina programs with Docker using **ballerina docker** command.
Refer https://github.com/ballerinalang/container-support for setting up ballerina container-support.

Notice the docker **image name** and **versions** are helloservice and 1.0


```
# ballerina docker services.balx -t helloservice:1.0
Build docker image [helloservice:0.1] in docker host [localhost]? (y/n): y

Docker image helloservice:0.1 successfully built.


Use the following command to execute the main program bal/balx in a container.
	docker run --name federal_breath -it helloservice:0.1

Use the following command to start the main service bal/balx in container.
	docker run -p 34361:9090 --name federal_breath -d helloservice:0.1

Use the following command to inspect the logs.
	docker logs federal_breath

Use the following command to retrieve the IP address of the container
	docker inspect federal_breath | grep IPAddress

Ballerina service will be running on the following ports.
	http://localhost:34361
	http://<container-ip>:9090

Make requests using the format [curl -X <http-method> http://localhost:34361/<service-name>]

```

Make sure you have no services already started in port 9090. Now execute **docker run** command to start the service. Follow the previous section [Invoking the Service](#invoking-the-service) to see if the service is running on container.


```
# docker run -it helloservice:1.0
ballerina: deploying service(s) in '/ballerina/files/services.balx'
ballerina: started HTTP/WS server connector 0.0.0.0:9090
```


### <a name="deploying-on-kubernetes"></a> Deploying on Kubernetes
<TODO>


