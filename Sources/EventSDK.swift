//
//  EventSDK.swift
//  EventSDK
//
//  Created by Maksim Mironov on 11.04.2022.
//

import Foundation
import Network
public protocol EventFactoryProtocol{
  func next( _ event: Event)
  var sendingIsAvailable: Bool {get}
}

public final class EventSDK: EventFactoryProtocol {
  
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
  private var heartbeatInterval: Double = 30.0
  
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
    queue: DispatchQueue = DispatchQueue(label: "com.tsifrasoft.EventSdkInternetMonitor")
  ) {
    self.sendService = SendService(configuration: configuration, plugins: plugins)
    self.heartbeatInterval = configuration.heartbeatInterval
    start(heartbeatInterval: heartbeatInterval)
    monitor.start(queue: queue)
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
    guard sendingIsAvailable else {return}
    let event = Event(contactType: .undefined, view: .heartBeat)
    next(event)
  }
  
  deinit{
    monitor.cancel()
  }
}

public extension EventSDK {
  var sendingQueue: [String?] {
    return sendService.sendingQueue.state
  }
  
  var userAttributes:  [[String: Any?]] {
    return sendService.baseQueryItems
  }
}
