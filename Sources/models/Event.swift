//
//  Event.swift
//  EventSDK
//
//  Created by Maksim Mironov on 12.04.2022.
//

import Foundation
import UIKit

/// user Event object
public struct Event: Equatable, Hashable {
  
  /// Event Initializer.
  public init(
    contactType : ContactType! = .undefined,
              view: EventType? = nil,
              idlc: String? = nil,
              fts: Int64? = nil,
              urlc: String?   = nil,
              media: String? = nil,
              tms: String? = nil,
              ver: Int?  = nil) {
    self.idlc = idlc
    self.view = view
    self.type = contactType
    self.fts = fts
    self.urlc = urlc
    self.media = media
    self.tms = tms
    self.ver = ver
    self.tsu = Date().getCurrentTimeStamp()
  }
  
  /// Content ID within the local directory
  var idlc: String? = nil
  
  /// event type
  var view: EventType? = nil
  
  /// Type of contact.
  var type : ContactType! = .undefined
  
  /// Timestamp of the stream frame.
  /// For live broadcasts (TV broadcasts, blogger streams, etc.) corresponds to the frame broadcast time, for VOD and catch-up broadcasts - offset from the beginning of the EC in milliseconds.
  /// Transmitted in heartbeat integrations.
  var fts: Int64? = nil
  
  /// Content unit url
  /// If not passed, it is cast to the canon address based on the field (http_referer)
  var urlc: String? = nil
  
  /// The name in the directory of the channel partner or other media in which the EC is contacted
  /// The value must be encoded encodeURIComponent
  var media: String? = nil
  
  /// The ID of the thematic section.  Assigned by Mediascope
  var tms: String? = nil
  
  ///The version number of the EC. Versions may differ in the content of the EC
  var ver: Int?  = nil
  
  /// The local timestamp of the curretn event
  private(set) var tsu: Int = 0
  
  
  /// Request `URLQueryItem` configuration
  /// Map self to  `[URLQueryItem: Value]` for  `QueryItems`
  func toQuery() -> [[String: Any?]] {
    typealias Keys = QueryKeys
    return [
      [Keys.type.rawValue : type],
      [Keys.tsu.rawValue : tsu],
      [Keys.fts.rawValue : fts],
      [Keys.media.rawValue : String(describing: media?.cString(using: .utf8))],
      [Keys.urlc.rawValue : String(describing: urlc?.cString(using: .utf8))],
      [Keys.tms.rawValue : tms],
      [Keys.ver.rawValue : ver],
      [Keys.idlc.rawValue : idlc],
      [Keys.view.rawValue : view],
    ]
  }
  
}
