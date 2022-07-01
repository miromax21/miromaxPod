//
//  SendService.swift
//  MediatagSDK
//
//  Created by Maksim Mironov on 17.05.2022.
//

final class SendService {
  var baseQueryItems: [[String: Any]] = [[:]]
  var sendingQueue: RingBuffer<String>!
  var sendingIsAvailable: Bool = true
  var clientConfiguration: ConfigurationType {
    didSet {
      let depaultPackage = DefaultPackageData()
      baseQueryItems = depaultPackage.initBaseQuery(join: clientConfiguration.toQuery())
    }
  }
  private let lock = NSRecursiveLock()

  private var timer: Timer?

  init(configuration: ConfigurationType) {
    self.clientConfiguration = configuration
    self.sendingQueue = RingBuffer(count: clientConfiguration.sendingQueueBufferSize)
  }

  func sendNext(event: Event) {
    let nextQueryDictionary = extendQuery(join: event.toQuery())
    let queryItems = clientConfiguration.mapQuery(query: nextQueryDictionary)
    var urlComponents = clientConfiguration.urlComponents
    urlComponents?.queryItems = queryItems
    guard let stringUrl = urlComponents?.url?.absoluteString else {
      return
    }
    guard sendingIsAvailable else {
      write(url: stringUrl)
      return
    }
    sendEvent(url: stringUrl) { [weak self] success, url in
      if !success {
        self?.write(url: url)
      }
    }
  }

  func sendFromQueue() {
    guard sendingIsAvailable, !sendingQueue.isEmpty else {return}
    while sendingIsAvailable && !sendingQueue.isEmpty {
      lock.with { [weak self] in
        guard
          let target = sendingQueue.read(),
          let url = target.item
        else {
          return
        }
        sendEvent(url: url) { [weak self] success, _ in
          if !success {return}
          self?.sendingQueue.clear(atIndex: target.at)
        }
      }
    }
  }

  private func write(url: String) {
    lock.with { [weak self] in
      self?.sendingQueue.write(url)
    }
  }

  private func sendEvent(url: String, completion: Action? = nil) {
    var service = RequestService()
    service.plugins = clientConfiguration.plugins ?? []
    let nextUrl = url + "&\(QueryKeys.tsc.rawValue)=\(Date().getCurrentTimeStamp())"

    service.sendRequest(request: URLRequest(url: URL(string: nextUrl)!)) { success in
      completion?(success, url)
    }
  }

  private func extendQuery(join with: [[String: Any?]] ) -> [[String: Any?]] {
    return baseQueryItems + with
  }
}
