
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

You have to create configuration with the `ConfigurationType` protocol implementation

  ```swift
    final class SDKConfiguration: ConfigurationType{

      var cid: String? = "example_com"

      var hid: String? = "27fa89c8-e7af-435d-b0b7-0dd2b17b3fa7"
      
      var uidc: String! = "2"
      
      var idc: Int?
      
      var uid: String?
      
    }
  ```
### Customize default configuration settings:
The `ConfigurationType` protocol inherits [RequestConfiguration](https://github.com/miromax21/miromaxPod/blob/master/Sources/models/Configuration.swift)
> You can override some methods of constructing the url
- urlComponents (base implementation):
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

- toQuery()
  map current configuration to Dictionary<String, Any?>
  for extending the default url [configuration](https://github.com/miromax21/miromaxPod#check-configuration)  elements
  ```swift
    func toQuery() -> [[String: Any?]] {}
  ```

- mapQuery
  modify query items of the url before you send request at the `first time`:
  ```swift
     func mapQuery(query: [[String: Any?]]) -> [URLQueryItem] {}
  ```

   - [x] check
   - [x] filtering
   - [x] append query items


### Build
```swift
  let eventSdk = EventSDK(configuration: config)
```
#### Check Configuration
  ```swift
    var userAttributes:  [[String: Any?]]
    // eventSdk.userAttributes -> [[String: Any?]] 
  ```

### Events Sending
> all Event properties [here](https://github.com/miromax21/miromaxPod/blob/master/Sources/models/Event.swift)
```swift
  let event = Event(contactType: .undefined, view: .start)
  eventSdk.next(event)
```

- Sending availability
  if request cannot be sended or rejected, url will be added to [sending queue](https://github.com/miromax21/miromaxPod#sending-queue) 
  ```swift 
    var sendingIsAvailable: Bool
  ```

  > After the internet connection is restored  the requests from the [sending queue](https://github.com/miromax21/miromaxPod#sending-queue) will try to resume, otherwise the sending of pending requests will be suspended
  
- Sending queue
  ```swift
    var sendingQueue: [String?]
    // eventSdk.sendingQueue -> [String?]
  ```
  
### Prepare request
```swift
  // MARK: - PluginType Implementation
  struct SDKPlugin :PluginType {
    func prepare(_ request: URLRequest) -> URLRequest {
      ///  some request modification code
      return request
    }
  }

  let eventSdk = EventSDK(configuration: config, plugins: [SDKPlugin()])
  
```
