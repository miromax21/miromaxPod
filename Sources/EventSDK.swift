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
  
  private lazy var baseQueryItems: [[String: Any?]] = {
    let depaultPackage = DefaultPackageData()
    return depaultPackage.initBaseQuery(join: clientConfiguration.toQuery())
  }()
  
  private let lock = NSRecursiveLock()
  
  private var timer: Timer?
  
  /// A list of plugins.
  /// e.g. for logging, network activity indicator or credentials.
  public let plugins: [PluginType]!
  
  /// User configuration object
  public let clientConfiguration: ConfigurationType!
  
  /// A list of events that, for whatever reason, were not sent
  public private(set) var sendingQueue: [Event] = []
  
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
    self.clientConfiguration = configuration
    self.plugins = plugins
    self.timer = Timer.scheduledTimer(
      timeInterval: configuration.heartbeatInterval,
      target: self,
      selector: #selector(sendHeartbeat),
      userInfo: nil,
      repeats: true
    )
  }
  
  /// Send next event to the server immediately
  /// - Parameters:
  ///   - event: An Event type object for sending on servert
  public func next( _ event: Event){
    sendNext(event: event)
    if !sendingQueue.isEmpty{
      sendingQueue.forEach{
        sendNext(event: $0, fromQueue: true)
      }
    }
  }
}

extension EventSDK{
  private func sendNext(event: Event, fromQueue: Bool = false){
    let nextQueryDictionary = extendQuery(join: event.toQuery())
    sendData(query: nextQueryDictionary) { [weak self] success in
      guard !success && fromQueue || !fromQueue && success else {
        return
      }
      self?.applyEventSending(event: event, success && fromQueue)
    }
  }
  
  private func applyEventSending(event: Event, _ success: Bool){
    lock.with { [weak self] in
      guard let self = self else { return }
      if success {
        self.sendingQueue = self.sendingQueue.filter{$0 == event}
      } else {
        self.sendingQueue.append(event)
      }
    }
  }

  private func sendData(query: [[String: Any?]], completion: Action? = nil) {
    
    let service = RequestService(plugins: self.plugins)
    var urlComponents = clientConfiguration.urlComponents
    urlComponents?.queryItems = clientConfiguration.mapQuery(query:  query)
    
    guard let url = urlComponents?.url else {
      return
    }
    service.sendRequest(request: URLRequest(url: url)) { success in
      completion?(success)
    }
  }
  
  private func extendQuery(join with: [[String: Any?]] ) -> [[String: Any?]]{
    var query = baseQueryItems
    query = query + with
    query.append([QueryKeys.tsc.rawValue: String(describing: Date().getCurrentTimeStamp())])
    return query
  }
  
  @objc private func sendHeartbeat() {
    let event = Event(contactType: .undefined, view: .heartBeat)
    sendNext(event: event)
  }
}
