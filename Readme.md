<p align="center">
  <img height="160" src="web/logo_github.png" />
</p>

# MiromaxPod

## Installation
```swift
// swift-tools-version:5.3
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

For Moya, use the following entry in your Podfile:

```rb
pod 'EventSDK', 'version'
```

Then run `pod install`.

In any file you'd like to use Moya in, don't forget to
import the framework with `import EventSDK`.


## Usage

You have to create configuration *class* 
The configuration *must* additionally conform `ConfigurationType` protocol

## Customize your default configuration

##### setting your custom base URLComponents 

```swift
  var urlComponents: URLComponents! {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "domain"
    urlComponents.path = "path"
    return urlComponents
  }
```

##### toQuery()
this data will be merged with default keys and cashed for current session 
```swift
  func toQuery() -> [[String: Any?]] {}
```

##### map sending url query items
check, filtering, append query items before *first* sending 
after that, if the request is rejected, the url will be taken from *sendingQueueue*
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
```swift
  let event = Event(contactType: .undefined, view: .start)
  eventSdk.next(event)
```

#### sendingQueue
```swift
    var sendingQueue: [String?]
    // eventSdk.sendingQueue -> [String?]
```
### *Warning*
  if request cannot be sended of rejected, url will be added to *sendingQueue*
  you have check the availability of the Internet connection yourself
    eventSdk
```swift 
  var sendingIsAvailable: Bool
```
  if `true` we'll try send all request from *sendingQueue*.
  otherwise requests sending will be stoped 
  and resumed again if set `true`
  
##### prepare request
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
