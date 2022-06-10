
## Usage
### Build
#### For SDK initialization use `convenience init`

```swift
    NSMediatagSDK  *sdk = [[NSMediatagSDK alloc] initWithCid: @"cid" tms: @"tms" uid: @"uid" hid: @"hid" uidc: @1];
```
  
#### or advanced configuration:

```swift
    NSConfiguration *configuration = [[NSConfiguration alloc] 
    initWithCid: @"userCid" 
    tms: @"tms" 
    uid: @"uid" 
    hid: @"hid" 
    uidc: @1
  ];
  NSMediatagSDK *mediatagSDK = [[NSMediatagSDK alloc] initWithConfiguration: configuration];

```

### Check Configuration
  ```swift
    func getUserAttributes() -> NSMutableDictionary
  ```
### Events Sending
> all Event properties [here](https://github.com/miromax21/miromaxPod/blob/master/Sources/models/Event.swift)
```swift
  [mediatagSDK nextWithContactType:  @1
                           view:  @2
                            idc:  @3
                           idlc:  @"idlc"
                            fts:  43234
                           urlc:  @"http://event_url.ru?query=query"
                          media:  @"media"
                            ver:  @36 ];
```
- `Sending availability` 
  if request cannot be sended or rejected, url will be added to [sending queue](https://github.com/miromax21/miromaxPod#sending-queue) 
  ```swift 
    func getSendingAbility() -> Bool
  ```

  > After the internet connection is restored  the requests from the [sending queue](https://github.com/miromax21/miromaxPod#sending-queue) will try to resume, otherwise the sending of pending requests will be suspended
  
- `Sending queue`
  ```swift
    func getSendingQueue() -> Array<String>
  ```
