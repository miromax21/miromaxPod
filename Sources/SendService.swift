//
//  SendService.swift
//  EventSDK
//
//  Created by Maksim Mironov on 17.05.2022.
//

import Foundation
final class SendService {
  
  lazy var baseQueryItems: [[String: Any?]] = {
    let depaultPackage = DefaultPackageData()
    return depaultPackage.initBaseQuery(join: clientConfiguration.toQuery())
  }()
  
  var sendingQueue: RingBuffer<String>!
  var sendingIsAvailable: Bool = true
  private let lock = NSRecursiveLock()
  private let clientConfiguration: ConfigurationType!
  private let plugins: [PluginType]!
  private var timer: Timer?
  
  init(
    configuration: ConfigurationType,
    plugins: [PluginType] = []
  ) {
    self.clientConfiguration = configuration
    self.plugins = plugins
    self.sendingQueue = RingBuffer(count: clientConfiguration.sendingQueueBufferSize)
  }
  
  func sendNext(event: Event){
    let nextQueryDictionary = extendQuery(join: event.toQuery())
    let queryItems = clientConfiguration.mapQuery(query: nextQueryDictionary)
    var urlComponents = clientConfiguration.urlComponents
    urlComponents?.queryItems = queryItems
    guard let stringUrl = urlComponents?.url?.absoluteString else {
      return
    }
    guard sendingIsAvailable else{
      write(url: stringUrl)
      return
    }
    sendEvent(url: stringUrl) { [weak self] success, url in
      if !success {
        self?.write(url: url)
      }
    }
  }
  
  func sendFromQueue(){
    while sendingIsAvailable && !sendingQueue.isEmpty {
      lock.with { [weak self] in
        guard
          let target = sendingQueue.read(),
          let url = target.item
        else {
          return
        }
        sendEvent(url: url) { [weak self] success, query in
          self?.sendingQueue.clear(atIndex: target.at)
        }
      }
    }
  }
  
  private func write(url:String){
    lock.with { [weak self] in
      self?.sendingQueue.write(url)
    }
  }
  
  private func sendEvent(url: String, completion: Action? = nil) {
    let service = RequestService(plugins: self.plugins)
    let nextUrl = url + "&\(QueryKeys.tsc.rawValue)=\(Date().getCurrentTimeStamp())"
  
    service.sendRequest(request: URLRequest(url: URL(string: nextUrl)!)) { success in
      completion?(success, url)
    }
  }
  
  private func extendQuery(join with: [[String: Any?]] ) -> [[String: Any?]]{
    var query = baseQueryItems
    query = query + with
    return query
  }
}
