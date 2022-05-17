//
//  EventSDK.swift
//  EventSDK
//
//  Created by Maksim Mironov on 11.04.2022.
//

import Foundation

public protocol EventFactoryProtocol{
  func next( _ event: Event)
}

public final class EventSDK: EventFactoryProtocol {
  
  private let sendService: SendService!
  private var timer: Timer?
  
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
  var sendingQueue: [Event] {
      return sendService.sendingQueue
  }
  
  var userAttributes:  [[String: Any?]] {
    return sendService.baseQueryItems
  }
}
