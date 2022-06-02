//
//  Configuration.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation
// # The list of keys to build URL
public enum QueryKeys: String {
  
  // ## UserData
  // ### Init
  /// Client ID.
  case cid = "cid"
  case uid = "uid"
  /// Identifier linked to the user's account in the Owner's system
  case hid = "hid"
  /// CatID - the ID of the local directory of the EC on the site where this EC is recorded.
  case idc = "idc"
  /// The ID of the thematic section.  Assigned by Mediascope
  case tms = "tms"
  
  // ### Event
  /// Type of contact.
  case type = "type"
  /// User/device ID
  case uidc = "uidc"
  /// Content ID within the local directory
  case idlc = "idlc"
  /// event type
  case view = "view"
  /// Timestamp of the stream frame.
  case fts = "fts"
  /// Content unit url
  case urlc = "urlc"
  /// The name in the directory of the channel partner or other media in which the EC is contacted
  case media = "media"
  /// The version number of the EC. Versions may differ in the content of the EC
  case ver = "ver"
  /// Local timestamp of the event
  case tsu = "tsu"
  
  // ## PackageData
  
  /// Device IDs
  case dvi = "dvi"
  /// Device Model
  case dvm = "dvm"
  /// Производитель устройства
  case dvn = "dvn"
  /// Уникальный идентификатор приложения (BundleName)
  case appn = "appn"
  /// SDK Version
  case appv = "appv"
  /// Source type identifier.
  case typ = "typ"
  /// Name and version of the operating system
  case os = "os"
  /// Installation ID generated in the SDK
  case sid = "sid"

  /// The local timestamp of when the event was sent.
  case tsc = "tsc"
}
