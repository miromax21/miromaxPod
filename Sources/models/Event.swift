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
  public init(contactType : ContactType!, view: EventType? = nil, idc: Int? = nil, idlc: String? = nil,  fts: Int64? = nil,  urlc: String?  = nil,  media: String? = nil, ver: Int?  = nil) {
    self.idlc = idlc
    self.idc = idc
    self.view = view
    self.type = contactType
    self.fts = fts
    self.urlc = toString(param: urlc)
    self.media = toString(param: media)
    self.idlc = toString(param: idlc)
    self.ver = ver
    self.tsu = Date().getCurrentTimeStamp()
  }
  
  public init(contactType : ContactType!){
    self.type = contactType
  }
  /// The local timestamp of the curretn event
  private(set) var tsu: Int = 0
  
  /// Type of contact.
  public private(set) var type: ContactType! = .undefined
  ///The version number of the EC. Versions may differ in the content of the EC
  
  /// event type
  public var view: EventType? = nil
  
  public var ver: Int?  = nil
  /// CatID - the ID of the local directory of the EC on the site where this EC is recorded.
  /// Assigned by Mediascope.
  public var idc: Int?  = nil
  
  /// Timestamp of the stream frame.
  /// For live broadcasts (TV broadcasts, blogger streams, etc.) corresponds to the frame broadcast time, for VOD and catch-up broadcasts - offset from the beginning of the EC in milliseconds.
  /// Transmitted in heartbeat integrations.
  public var fts: Int64? = nil
  
  /// Content ID within the local directory
  public var idlc: String? = nil
  
  /// Content unit url
  /// If not passed, it is cast to the canon address based on the field (http_referer)
  public var urlc: String? = nil
  
  /// The name in the directory of the channel partner or other media in which the EC is contacted
  /// The value must be encoded encodeURIComponent
  public var media: String? = nil
  
  /// Request `URLQueryItem` configuration
  /// Map self to  `[URLQueryItem: Value]` for  `QueryItems`
  func toQuery() -> [[String: Any?]] {
    typealias Keys = QueryKeys
    return [
      [Keys.type.rawValue : type.rawValue],
      [Keys.tsu.rawValue : tsu],
      [Keys.fts.rawValue : fts],
      [Keys.media.rawValue : media],
      [Keys.urlc.rawValue : urlc?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)],
      [Keys.ver.rawValue : ver],
      [Keys.idc.rawValue : idc],
      [Keys.idlc.rawValue : idlc],
      [Keys.view.rawValue : view?.rawValue],
    ]
  }
  
  private func toString(param: Any?) -> String? {
    guard let param = param, String(describing: param) != "" else {
      return nil
    }
    return String(describing: param)
  }
  
}
