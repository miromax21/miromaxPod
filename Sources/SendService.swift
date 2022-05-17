//
//  SendService.swift
//  EventSDK
//
//  Created by Sergey Zhidkov on 17.05.2022.
//

import Foundation
final class SendService {
  
  lazy var baseQueryItems: [[String: Any?]] = {
    let depaultPackage = DefaultPackageData()
    return depaultPackage.initBaseQuery(join: clientConfiguration.toQuery())
  }()
  
  var sendingQueue: [Event] = []
  
  private let lock = NSRecursiveLock()
  private let clientConfiguration: ConfigurationType!
  private let plugins: [PluginType]!
  
  init(
    configuration: ConfigurationType,
    plugins: [PluginType] = []
  ) {
    self.clientConfiguration = configuration
    self.plugins = plugins
  }
  
  func sendNext(event: Event, fromQueue: Bool = false){
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
  
  private func intsert(event: Event){
    
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
}
