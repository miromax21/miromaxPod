//
//  EventSDK.swift
//  EventSDK
//
//  Created by Maksim Mironov on 11.04.2022.
//

import Foundation

public protocol EventFactoryProtocol{
  func next( _ event: Event)
  var sendingIsAvailable: Bool {get set}
}

public final class EventSDK: EventFactoryProtocol {
  
  private let sendService: SendService!
  private var timer: Timer?
  /// Data sending ability trigger
  /// # Notes: #
  /// 1.  case `false`current  request will be add into  sendingQueue
  /// 2. case `true` will try send current request and one by one request from queue while it won't be empty
  public var sendingIsAvailable: Bool = true{
    didSet{
      sendService.sendingIsAvailable = sendingIsAvailable
      if sendingIsAvailable {
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
    plugins: [PluginType] = []
  ) {
    self.sendService = SendService(configuration: configuration, plugins: plugins)
    start(heartbeatInterval: configuration.heartbeatInterval)
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
}

public extension EventSDK {
  var sendingQueue: [String?] {
    return sendService.sendingQueue.state
  }
  
  var userAttributes:  [[String: Any?]] {
    return sendService.baseQueryItems
  }
}
