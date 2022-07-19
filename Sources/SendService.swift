//
//  SendService.swift
//  EventSDK
//
//  Created by Maksim Mironov on 17.05.2022.
//

import Foundation

final class SendService {
  typealias ItemsType = String
  var sendingIsAvailable: Bool = true
  var clientConfiguration: ConfigurationType! {
    didSet {
      hasFullinformation = false
      setBaseQueryItems()
    }
  }

  private(set) var baseQueryItems: [[String: Any]] = [[:]]
  private(set) var sendingQueue: RingBuffer<ItemsType>!

  private let lock = NSRecursiveLock()
  private var hasFullinformation = false
  private var timer: Timer?

  init(configuration: ConfigurationType, with: [ItemsType] = []) {
    self.clientConfiguration = configuration
    self.sendingQueue = RingBuffer(count: configuration.sendingQueueBufferSize)
  }

  func insertItems(items: [ItemsType]) {
    let items = items.filter {
      URL(string: $0) != nil
    }
    lock.with { [weak self] in
      self?.sendingQueue.insert(items: items)
    }
  }

  func sendNext(event: Event) {
    if !hasFullinformation {
      setBaseQueryItems()
    }
    let nextQueryDictionary = extendQuery(join: event.toQuery())
    let queryItems = clientConfiguration.mapQuery(query: nextQueryDictionary)

    guard var stringUrl = clientConfiguration.baseUrl.appending(queryItems)?.absoluteString else {
      return
    }

    if clientConfiguration.urlReplacingOccurrences.count > 0 {
      for (spChar, repl) in clientConfiguration.urlReplacingOccurrences {
        stringUrl = stringUrl.replacingOccurrences(of: spChar, with: repl, options: .literal, range: nil)
      }
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
    guard sendingIsAvailable, !sendingQueue.isEmpty else {
      return
    }
    lock.with { [weak self] in
      guard
        let target = sendingQueue.read(),
        let url = target.item
      else {
        return
      }
      sendEvent(url: url) { [weak self] success, _ in
        if success {
          self?.sendingQueue.clear(atIndex: target.at)
        }
        self?.sendFromQueue()
      }
    }
  }

  private func setBaseQueryItems() {
    let defaultPackage = DefaultPackageData()
    baseQueryItems = defaultPackage.initBaseQuery(join: clientConfiguration.toQuery())
    hasFullinformation = defaultPackage.hasFullinformation
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
      print("\(success) - \(url)")
      completion?(success, url)
    }
  }

  private func extendQuery(join with: [[String: Any?]] ) -> [[String: Any?]] {
    return baseQueryItems + with
  }
}
