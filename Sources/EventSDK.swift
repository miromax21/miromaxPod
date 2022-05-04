//
//  EventSDK.swift
//  EventSDK
//
//  Created by Maksim Mironov on 11.04.2022.
//

import Foundation
public typealias Action = (_ success: Bool) -> ()
public protocol EventFactoryType{
  func next(send event: Event)
}

public final class EventFactory: EventFactoryType {
  
  /// User configuration object
  public let clientConfig: Configuration!
  
  /// A list of plugins.
  /// e.g. for logging, network activity indicator or credentials.
  public let plugins: [PluginType]

  private let lock = NSLock()
  
  private(set) var sendQueue: [Event] = []
  
  private lazy var baseQueryItems: [[QueryKeys: Any?]] = {
    let depaultPackage = DefaultPackageData()
    return depaultPackage.initBaseQuery(join: queryDictionary())
  }()
  
  /// Creates a new EventFactory
  ///
  /// Use this initializer with configuration
  /// - Parameters:
  ///   - configuration: an object containing user information
  public init(
    configuration: Configuration,
    plugins: [PluginType] = []
  ) {
    self.clientConfig = configuration
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

private extension EventFactory{
  private func sendNext(event: Event, fromQueue: Bool = false){
    let nextQueryDictionary = initQuery(event: event)
    sendData(query: nextQueryDictionary) { [weak self] success in
      guard !success && fromQueue || !fromQueue && success else {
        return
      }
      
      if !success && !fromQueue{
        self?.lock.with { [weak self] in
          self?.sendQueue.append(event)
        }
      }
      
      if success && fromQueue {
        self?.lock.with { [weak self] in
          self?.sendQueue = self?.sendQueue.filter{$0 == event} ?? []
        }
      }
    }
  }

  private func sendData(query: [[QueryKeys: Any?]], completion: Action? = nil) {
    let queryitems = query.compactMap {
      URLQueryItem(name: "\($0.keys.first!.rawValue)" , value: String(describing: $0.values.first ?? ""))
    }
    let service = RequestService(plugins: self.plugins)
    service.sendData(queryitems: queryitems, path: clientConfig.urlPath) { success in
      completion?(success)
    }
  }
  
  private func initQuery(event: Event) -> [[QueryKeys: Any?]]{
    let query: [[QueryKeys: Any?]] = [
      [.contactType : event.contactType],
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
    return query
  }
  
  private func queryDictionary() -> [[QueryKeys: Any?]] {
    return [
      [.partnerName : clientConfig.partnerName],
      [.srcType : clientConfig.srctype],
      [.hardId : clientConfig.hardId],
      [.catId : clientConfig.catId],
      [.uid : clientConfig.uid],
    ]
  }
}
