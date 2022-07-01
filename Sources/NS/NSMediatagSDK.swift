//
//  NSMediatagSDK.swift
//  MediatagSDK
//
//  Created by Maksim Mironov on 02.06.2022.
//

import Foundation
public class NSEvemtSDK: NSObject {
  private var mediatagSDK: EventSDK!

  @objc public static var shared = NSEvemtSDK(cid: "", tms: "", uid: nil, hid: nil, uidc: nil)

  /// Creates a new SDK
  ///
  /// Use this initializer with configuration
  /// - Parameters:
  ///   - configuration: an object containing user information
  ///   - plugins: Called to modify a request before sending.
  @objc public init(configuration: NSConfiguration) {
    super.init()
    mediatagSDK = EventSDK(configuration: configuration)
  }

  /// SDK convenience init
  /// - Parameters:
  ///   - params: user configuration perameters
  @objc public convenience init(cid: String, tms: String!, uid: String?, hid: String?, uidc: NSNumber?) {
    self.init(configuration: NSConfiguration(cid: cid, tms: tms, uid: uid, hid: hid, uidc: uidc))
  }

  /// SDK configuration
  /// - Parameters:
  ///   - configuration: user configuration perameters
  @objc public func setConfiguration(cid: String, tms: String!, uid: String?, hid: String?, uidc: NSNumber?) {
    mediatagSDK.setConfiguration(cid: cid, tms: tms, uid: uid, hid: hid, uidc: uidc)
  }

  /// SDK configuration
  /// - Parameters:
  ///   - configuration: an object containing user information
  @objc public func setConfiguration(configuration: NSConfiguration) {
    mediatagSDK.configuration = configuration
  }

  /// Send next event to the server immediately
  /// - Parameters:
  ///   - event: An Event type object for sending on servert
  // swiftlint:disable function_parameter_count
  @objc public func next(
    contactType: NSNumber,
    view: NSNumber?,
    idc: NSNumber?,
    idlc: NSString,
    fts: Int64,
    urlc: NSString,
    media: String,
    ver: NSNumber?
  ) {
    var eventView: EventType?
    if let view = view {
      eventView = EventType(rawValue: Int(truncating: view))
    }
    mediatagSDK.next(
      Event(contactType: ContactType(rawValue: contactType.intValue),
            view: eventView, idc: idc as? Int,
            idlc: idlc as String,
            fts: fts,
            urlc: urlc as String,
            media: media,
            ver: ver as? Int)
    )
  }

  /// Data sending ability trigger
  /// # Notes: #
  /// 1.  case `false`current  request will be add into  sendingQueue
  /// 2. case `true` will try send current request and one by one request from queue while it won't be empty
  @objc public func getSendingAbility() -> Bool {
    return mediatagSDK.sendingIsAvailable
  }

  // swiftlint:disable syntactic_sugar
  @objc public func getSendingQueue() -> Array<String> {
    return mediatagSDK.sendingQueue.compactMap {$0}
  }

  @objc public func getUserAttributes() -> NSMutableDictionary {
    let nsAttributes: NSMutableDictionary = [:]
    mediatagSDK.userAttributes.forEach {
      if let next = $0.first {
        nsAttributes.setObject(next.value, forKey: next.key as NSCopying)
      }
    }
    return nsAttributes
  }
}
