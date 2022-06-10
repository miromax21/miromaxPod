
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
> This article is about swift using, if you want to use Objective-C you have to go [here](https://github.com/miromax21/miromaxPod/blob/master/Sources/NS/Readme.ns.md)

In any file you'd like to use EventSDK in, don't forget to
import the framework with `import EventSDK`.

## Usage
### Build
```swift
  let eventSdk = EventSDK(cid: "cid", tms: "tms", uid: "uid", hid: "hid", uidc: 3123)
```
> for advanced configuration you can see [here](https://github.com/miromax21/miromaxPod/blob/master/Sources/Readme.advanced.md)
#### Check Base Attributes
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

- `Sending availability` 
  if request cannot be sended or rejected, url will be added to [sending queue](https://github.com/miromax21/miromaxPod#sending-queue) 
  ```swift 
    var sendingIsAvailable: Bool
  ```

  > After the internet connection is restored  the requests from the [sending queue](https://github.com/miromax21/miromaxPod#sending-queue) will try to resume, otherwise the sending of pending requests will be suspended
  
- `Sending queue`
  ```swift
    var sendingQueue: [String?]
    // eventSdk.sendingQueue -> [String?]
  ```
  
