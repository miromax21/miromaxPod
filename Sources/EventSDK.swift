//
//  MediatagSDK.swift
//  MediatagSDK
//
//  Created by Maksim Mironov on 11.04.2022.
//

import Foundation
import Network
public final class EventSDK {

  private var sendService: SendService!
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

  internal var configuration: ConfigurationType? {
    didSet {
      guard let config = configuration else {return}
      sendService.clientConfiguration = config
      start(heartbeatInterval: config.heartbeatInterval)
    }
  }

  /// Data sending ability trigger
  /// # Notes: #
  /// 1.  case `false`current  request will be add into  sendingQueue
  /// 2. case `true` will try send current request and one by one request from queue while it won't be empty
  public private(set) var sendingIsAvailable: Bool = false {
    willSet {
      sendService?.sendingIsAvailable = newValue
      if newValue {
        sendService?.sendFromQueue()
      }
    }
  }

  public static let shared: EventSDK = {
    return EventSDK(cid: "", tms: "", uid: nil, hid: nil, uidc: nil)
  }()

  /// Creates a new SDK
  ///
  /// Use this initializer with configuration
  /// - Parameters:
  ///   - configuration: an object containing user information
  ///   - plugins: Called to modify a request before sending.
  public init(
    configuration: ConfigurationType,
    plugins: [PluginType] = []
  ) {
    self.monitor.start(queue: DispatchQueue(label: "com.tsifrasoftMediatagSDKInternetMonitor"))
    self.sendService = SendService(configuration: configuration)
  }

  /// SDK convenience init
  /// - Parameters:
  ///   - params: user configuration perameters
  public convenience init(cid: String, tms: String!, uid: String?, hid: String?, uidc: NSNumber?) {
    self.init(configuration: NSConfiguration(cid: cid, tms: tms, uid: uid, hid: hid, uidc: uidc))
  }

  /// SDK configuration
  /// - Parameters:
  ///   - params: set configuration with perameters
  public func setConfiguration(cid: String, tms: String!, uid: String?, hid: String?, uidc: NSNumber?) {
    self.configuration = NSConfiguration(cid: cid, tms: tms, uid: uid, hid: hid, uidc: uidc)
  }

  /// SDK configuration
  /// - Parameters:
  ///   - params: set configuration with object
  public func setConfiguration(configuration: ConfigurationType) {
    self.configuration = configuration
  }

  /// Send next event to the server immediately
  /// - Parameters:
  ///   - event: An Event type object for sending on servert
  public func next(_ event: Event) {
    sendService.sendNext(event: event)
  }

  private func start(heartbeatInterval: Double) {
    next(Event(contactType: .undefined))
    self.timer?.invalidate()
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

  deinit {
    monitor.cancel()
    timer?.invalidate()
  }
}

// MARK: MediatagSDK extension
extension EventSDK {

  /// Queue of unsent requests
  public var sendingQueue: [String?] {
    return sendService.sendingQueue.state
  }

  public var userAttributes: [[String: Any]] {
    return sendService.baseQueryItems
  }
}
