
## Usage

You have to create configuration with the `ConfigurationType` protocol implementation

  ```swift
    final class SDKConfiguration: ConfigurationType{

      var cid: String! = "example_com"
      
      var hid: String? = "27fa89c8-e7af-435d-b0b7-0dd2b17b3fa7"
      
      var uid: String? = nil
      
      var idc: Int? = nil
      
      var uidc: Int?  = 2

    }
  ```
### Customize default configuration settings:
The ConfigurationType protocol inherits [RequestConfiguration](https://github.com/miromax21/miromaxPod/blob/master/Sources/models/Configuration.swift)
> You can override some methods of constructing the url
- `baseUrl` (base implementation):
  ```swift
  var baseUrl: URL! {
    return URL(string: "https/tns-counter.ru/e/msdkev")!
  }
  ```
  > don't foget '/' in host trailing or path leading otherwise Request will be failed

- `toQuery()` 
  map current configuration to Dictionary<String, Any?>
  for extending the default url [configuration](https://github.com/miromax21/miromaxPod#check-configuration)  elements
  ```swift
    func toQuery() -> [[String: Any?]] {}
  ```

- `mapQuery` 
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
