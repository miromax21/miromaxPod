//
//  Configuration.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation

enum QueryKeys: String {
  //UserData
  case contactType = "type"
  case partnerName = "cid"
  case srcType = "typ"
  case frameTs = "fts"
  case hardId = "hid"
  case catId = "idc"
  case cuUrl = "urlc"
  case cuVer = "ver"
  case tmsec = "tms"
  case cuId = "idlc"
  case media = "media"
  case view = "view"
  case uid = "uid"
  
  // PackageData
  case deviceIdType = "dvid"
  case deviceModel = "dvm"
  case deviceMNFC = "dvn"
  case appVersion = "appv"
  case deviceType = "dvt"
  case uidClass = "uidc"
  case uidType = "uidt"
  case appName = "appn"
  case osInfo = "os"
}

enum DefaultQueryKeysValues: String {
  case uidClass = "1"
  case deviceType = "2"
  case deviceMNFC = "apple"
}
