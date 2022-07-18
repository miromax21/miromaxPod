//
//  Configuration.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation
// # The list of keys to build URL
public enum QueryKeys: String {

  // MARK: Init

  /// Client ID.
  case cid
  case uid
  /// Identifier linked to the user's account in the Owner's system
  case hid
  /// CatID - the ID of the local directory of the EC on the site where this EC is recorded.
  case idc
  /// The ID of the thematic section.  Assigned by Mediascope
  case tms

  // MARK: Event

  /// Type of contact.
  case type
  /// User/device ID
  case uidc
  /// Content ID within the local directory
  case idlc
  /// event type
  case view
  /// Timestamp of the stream frame.
  case fts
  /// Content unit url
  case urlc
  /// The name in the directory of the channel partner or other media in which the EC is contacted
  case media
  /// The version number of the EC. Versions may differ in the content of the EC
  case ver
  /// Local timestamp of the event
  case tsu

  // MARK: PackageData

  /// Device IDs
  case dvi
  /// Device Model
  case dvm
  /// Производитель устройства
  case dvn
  /// Уникальный идентификатор приложения (BundleName)
  case appn
  /// SDK Version
  case appv
  /// Source type identifier.
  case typ
  /// Name and version of the operating system
  // swiftlint:disable identifier_name
  case os
  /// Installation ID generated in the SDK
  case sid

  // MARK: Runtime send keys
  /// The local timestamp of when the event was sent.
  case tsc
}
