<p align="center">
  <img height="160" src="web/logo_github.png" />
</p>

# MiromaxPod

## Installation
```swift
import PackageDescription

let package = Package(
    name: "MyPackage",
    products: [
        .library(
            name: "MyPackage",
            targets: ["MyPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/miromax21/miromaxPod.git")
    ],
    targets: [
        .target(name: "MyPackage")
    ]
)
```

### CocoaPods

Use the following entry in your Podfile:

```rb
pod 'EventSDK', 'version'
```

Then run `pod install`.

In any file you'd like to use EventSDK in, don't forget to
import the framework with `import EventSDK`.

## Usage

You have to create configuration *class* 
The configuration *must* additionally conform `ConfigurationType` protocol

### Customize your default configuration

##### custom URLComponents (base implementation)
###### Warning
  don't foget '/' in host trailing or path leading otherwise Request will be failed
```swift
  var urlComponents: URLComponents! {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "domain" 
    urlComponents.path = "/path" // **important** use '/'
    return urlComponents
  }
```

##### toQuery()
the returned values extend the default url configuration elements
```swift
  func toQuery() -> [[String: Any?]] {}
```

##### map sending url query items
before `first sending` you can Modify the query items in Request:

- check
- filtering
- append query items

```swift
   func mapQuery(query: [[String: Any?]]) -> [URLQueryItem] {}
```

## Build
```swift
  let eventSdk = EventSDK(configuration: config)
```
#### check Configuration
```swift
  var userAttributes:  [[String: Any?]]
  // eventSdk.userAttributes -> [[String: Any?]] 
```

## Events Sending
all keyses
```swift
  let event = Event(contactType: .undefined, view: .start)
  eventSdk.next(event)
```
#### [All keyses](https://github.com/miromax21/miromaxPod/blob/master/Sources/models/Event.swift).

### SendingQueue
```swift
  var sendingQueue: [String?]
  // eventSdk.sendingQueue -> [String?]
```
#### Warning
> if request cannot be sended or rejected, url will be added to [sending queue](https://github.com/miromax21/miromaxPod#sendingqueue)  you have check the availability of the Internet connection yourself

```swift 
  var sendingIsAvailable: Bool
  // eventSdk.sendingIsAvailable = false 
```
  if `true`, the request from [sending queue](https://github.com/miromax21/miromaxPod#sendingqueue) will try resume
  otherwise requests will be suspended
  and resumed again if set `true`
  
### Prepare request
```swift
  // MARK: - PluginType Implementation
  struct SDKPlugin :PluginType {
    func prepare(_ request: URLRequest) -> URLRequest {
      /// some code
      return request
    }
  }

  let eventSdk = EventSDK(configuration: config, plugins: [SDKPlugin()])
  
```
