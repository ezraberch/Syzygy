# Syzygy

**Syzygy** is a library which enables basic networking without the need for explicit networking code, using Swift function calls instead. The library includes both a client and server component, which can be used together or seperately.

## Syzygy (Client)

Start by creating a Server object to represent the remote server you will be sending requests to:

```swift
let server = Server("https://jsonplaceholder.typicode.com")
```

Then, use dot notation to specify the path to the API method as well as any arguments:

```swift
let request = server.posts(title: "qui est esse")
```

Finally, use 'sink' to send the request and process the response, again using dot notation:

```swift
let result = request.sink { response in
    for item in response {
        print(item.title.stringValue()!)
    }
}
```

## SyzygyServer

The Syzygy Server uses Sourcery to automatically transform Swift classes into a Vapor server. 

Create your class, using an annotation to mark it:

```swift
// sourcery: SyzygyServer
class TestServer {
    func sum(x: Int, y: Int) -> Int {
        return x+y
    }
}
```

Then create the Vapor server:

```swift
let server = SyzygyServer(TestServer())
```

Create a .sourcery.yml file to indicate where your server class is and where the output will go:

```yml
sources:
    - Server
templates:
    - ${BUILT_PRODUCTS_DIR}/Syzygy_SyzygyServer.bundle/Contents/Resources
output:
    path: ./Generated/
```
    
Finally, create a custom build phase to run Sourcery:

```
${BUILT_PRODUCTS_DIR}/sourcery --config ${PROJECT_DIR}
```

Run it once and add the generate file to your project. From then on, it should automatically update if you make any changes to the server class.
