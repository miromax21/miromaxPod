//
//  MediaTagSDK.swift
//  MediaTagSDK
//
//  Created by Maksim Mironov on 11.04.2022.
//

import Foundation
import Network

public final class EventSDK {
  
  private let sendService: SendService!
  private var timer: Timer?
  private lazy var monitor: NWPathMonitor = {
    let monitor = NWPathMonitor()
    monitor.pathUpdateHandler = { [weak self] path in
        let next = path.status != .unsatisfied
        if next != self?.sendingIsAvailable {
          self?.sendingIsAvailable = next
        }
    }
    return monitor
  }()

  /// Data sending ability trigger
  /// # Notes: #
  /// 1.  case `false`current  request will be add into  sendingQueue
  /// 2. case `true` will try send current request and one by one request from queue while it won't be empty
  public private(set) var sendingIsAvailable: Bool = false  {
    willSet{
      sendService.sendingIsAvailable = newValue
      if newValue {
        sendService.sendFromQueue()
      }
    }
  }
  
  /// Creates a new EventFactory
  ///
  /// Use this initializer with configuration
  /// - Parameters:
  ///   - configuration: an object containing user information
  ///   - plugins: Called to modify a request before sending.
  public init(
    configuration: ConfigurationType,
    plugins: [PluginType] = [],
    queue: DispatchQueue = DispatchQueue(label: "com.tsifrasoftMediaTagSdkInternetMonitor")
  ) {
    self.sendService = SendService(configuration: configuration, plugins: plugins)
    start(heartbeatInterval: configuration.heartbeatInterval)
    monitor.start(queue: queue)
  }
  
  public convenience init(cid: String, tms: String!, uid: String?, hid: String?, uidc: NSNumber?){
    let config = NSConfiguration(cid: cid, tms: tms, uid: uid, hid: hid, uidc: uidc)
    self.init(configuration: config)
  }
  
  /// Send next event to the server immediately
  /// - Parameters:
  ///   - event: An Event type object for sending on servert
  public func next(_ event: Event){
    sendService.sendNext(event: event)
  }
  
  private func start(heartbeatInterval: Double){
    next(Event(contactType: .undefined))
    self.timer = Timer.scheduledTimer(
      timeInterval: heartbeatInterval,
      target: self,
      selector: #selector(sendHeartbeat),
      userInfo: nil,
      repeats: true
    )
  }
  
  @objc private func sendHeartbeat() {
    let event = Event(contactType: .undefined, view: .heartBeat)
    next(event)
  }
  
  deinit{
    monitor.cancel()
    timer?.invalidate()
  }
}

extension EventSDK {
  public var sendingQueue: [String?] {
    return sendService.sendingQueue.state
  }
  
  public var userAttributes:  [[String: Any]] {
    return sendService.baseQueryItems
  }
}
