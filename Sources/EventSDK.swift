//
//  EventSDK.swift
//  EventSDK
//
//  Created by Maksim Mironov on 11.04.2022.
//

import Foundation

public protocol EventFactoryProtocol{
  func next(send event: Event)
}

public final class EventFactory: EventFactoryProtocol {
  
  private lazy var baseQueryItems: [[QueryKeys: Any?]] = {
    let depaultPackage = DefaultPackageData()
    return depaultPackage.initBaseQuery(join: queryDictionary())
  }()
  
  private let lock = NSRecursiveLock()
  
  /// User configuration object
  public var clientConfiguration: ConfigurationType!
  
  /// A list of plugins.
  /// e.g. for logging, network activity indicator or credentials.
  public var plugins: [PluginType] = []
  
  /// A list of events that, for whatever reason, were not sent
  public private(set) var sendQueue: [Event] = []
  
  /// Creates a new EventFactory
  ///
  /// Use this initializer with configuration
  /// - Parameters:
  ///   - configuration: an object containing user information
  public init(
    configuration: ConfigurationType,
    plugins: [PluginType] = []
  ) {
    self.clientConfiguration = configuration
    self.plugins = plugins
  }
  
  /// Send next event to the server immediately
  /// - Parameters:
  ///   - event: An Event type object for sending on servert
  public func next(send event: Event){
    sendNext(event: event)
    if !sendQueue.isEmpty{
      sendQueue.forEach{
        sendNext(event: $0, fromQueue: true)
      }
    }
  }
}

extension EventFactory{
  private func sendNext(event: Event, fromQueue: Bool = false){
    let nextQueryDictionary = initQuery(event: event)
    sendData(query: nextQueryDictionary) { [weak self] success in
      guard !success && fromQueue || !fromQueue && success else {
        return
      }
      self?.upplyEvent(event: event, success && fromQueue)
    }
  }
  
  private func upplyEvent(event: Event, _ success: Bool){
    lock.with { [weak self] in
      guard let self = self else { return }
      if success {
        self.sendQueue = self.sendQueue.filter{$0 == event}
      } else {
        self.sendQueue.append(event)
      }
    }
  }

  private func sendData(query: [[QueryKeys: Any?]], completion: Action? = nil) {
    
    let service = RequestService(plugins: self.plugins)
    var urlComponents = clientConfiguration.urlComponents
    urlComponents?.queryItems = query.compactMap {
      URLQueryItem(name: "\($0.keys.first!.rawValue)" , value: String(describing: $0.values.first ?? ""))
    }
    
    guard let url = urlComponents?.url else {
      return
    }
    service.sendRequest(request: URLRequest(url: url)) { success in
      completion?(success)
    }
  }
  
  private func initQuery(event: Event) -> [[QueryKeys: Any?]]{
    let query: [[QueryKeys: Any?]] = [
      [.contactType : event.contactType],
      [.timeInit : DeviceUtils.shared.getCurrentTimeStamp()],
      [.frameTs : event.frameTs],
      [.frameTs : event.media],
      [.cuUrl : event.cuUrl],
      [.tmsec : event.tmsec],
      [.cuVer : event.cuVer],
      [.cuId : event.cuId],
      [.view : event.view],

    ]
    let extendedQuery = extendQuery(join: query)
    return extendedQuery
  }
  
  private func extendQuery(join with: [[QueryKeys: Any?]] ) -> [[QueryKeys: Any?]]{
    var query = baseQueryItems
    with.forEach{
      query.append($0)
    }
    query.append([.timeUpload: String(describing: DeviceUtils.shared.getCurrentTimeStamp())])
    return query
  }
  
  private func queryDictionary() -> [[QueryKeys: Any?]] {
    return [
      [.partnerName : clientConfiguration.partnerName],
      [.hardId : clientConfiguration.hardId],
      [.catId : clientConfiguration.catId],
      [.uid : clientConfiguration.uid],
    ]
  }
}
