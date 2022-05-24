
# MiromaxPod

## Installation

### CocoaPods

Use the following entry in your Podfile:

```rb
pod 'EventSDK'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding EventSDK as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/miromax21/miromaxPod.git", .upToNextMajor(from: "0.1.1"))
]
```

In any file you'd like to use EventSDK in, don't forget to
import the framework with `import EventSDK`.

## Usage

You have to create configuration *class* 
The configuration *must* additionally conform `ConfigurationType` protocol
```swift
  final class sdkConfiguration: ConfigurationType {
    // ConfigurationType implementation
  }
```
### Customize your default configuration:

##### - urlComponents (base implementation):
  ```swift
    var urlComponents: URLComponents! {
      var urlComponents = URLComponents()
      urlComponents.scheme = "https"
      urlComponents.host = "domain" 
      urlComponents.path = "/path" // **important** use '/'
      return urlComponents
    }
  ```
  > don't foget '/' in host trailing or path leading otherwise Request will be failed

##### - toQuery()
  map current configuration to Dictionary<String, Any?>
  for extending the default url configuration elements
  ```swift
    func toQuery() -> [[String: Any?]] {}
  ```

##### - mapQuery map sending url query items
  > you can modify query items of the url before you send request at the `first time`:
  ```swift
     func mapQuery(query: [[String: Any?]]) -> [URLQueryItem] {}
  ```

   - [x] check
   - [x] filtering
   - [x] append query items


## Build
```swift
  let eventSdk = EventSDK(configuration: config)
```
#### - check Configuration
  ```swift
    var userAttributes:  [[String: Any?]]
    // eventSdk.userAttributes -> [[String: Any?]] 
  ```

## Events Sending
> You can see more Event properties [here](https://github.com/miromax21/miromaxPod/blob/master/Sources/models/Event.swift)
```swift
  let event = Event(contactType: .undefined, view: .start)
  eventSdk.next(event)
```

### - SendingQueue
  ```swift
    var sendingQueue: [String?]
    // eventSdk.sendingQueue -> [String?]
  ```
  #### Warning
  > if request cannot be sended or rejected, url will be added to [sending queue](https://github.com/miromax21/miromaxPod#sendingqueue) 

  ```swift 
    var sendingIsAvailable: Bool
  ```

  > After the internet connection is restored  the requests from the [sending queue](https://github.com/miromax21/miromaxPod#sendingqueue) will try to resume, otherwise the sending of pending requests will be suspended

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
