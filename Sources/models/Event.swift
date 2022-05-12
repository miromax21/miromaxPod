//
//  Event.swift
//  EventSDK
//
//  Created by Maksim Mironov on 12.04.2022.
//

import Foundation
import UIKit

/// user Event object
public struct Event: Equatable {
  
  /// Event Initializer.
  public init(cuId: String,
              view: EventType!,
              contactType : ContactType!,
              frameTs: Int64? = nil,
              cuUrl: String?   = nil,
              media: String? = nil,
              tmsec: String? = nil,
              cuVer: Int?  = nil) {
    self.cuId = cuId
    self.view = view
    self.contactType = contactType
    self.frameTs = frameTs
    self.cuUrl = cuUrl
    self.media = media
    self.tmsec = tmsec
    self.cuVer = cuVer
  }
  
  /// Content ID within the local directory
  var cuId: String!
  
  /// event type
  var view: EventType!
  
  /// Type of contact.
  var contactType : ContactType!
  
  /// Timestamp of the stream frame.
  /// For live broadcasts (TV broadcasts, blogger streams, etc.) corresponds to the frame broadcast time, for VOD and catch-up broadcasts - offset from the beginning of the EC in milliseconds.
  /// Transmitted in heartbeat integrations.
  var frameTs: Int64? = nil
  
  /// Content unit url
  /// If not passed, it is cast to the canon address based on the field (http_referer)
  var cuUrl: String? = nil
  
  /// The name in the directory of the channel partner or other media in which the EC is contacted
  /// The value must be encoded encodeURIComponent
  var media: String? = nil
  
  /// The ID of the thematic section.  Assigned by Mediascope
  var tmsec: String? = nil
  
  ///The version number of the EC. Versions may differ in the content of the EC
  var cuVer: Int?  = nil
  
}
