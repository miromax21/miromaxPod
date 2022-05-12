//
//  Configuration.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation

enum QueryKeys: String {
  //  UserData
  case contactType = "type"
  case partnerName = "cid"

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
  
  //  PackageData
  case deviceInterface = "dvi"
  case deviceIdType = "dvid"
  case deviceModel = "dvm"
  case deviceMNFC = "dvn"
  case appVersion = "appv"
  case deviceType = "dvt"
  case uidClass = "uidc"
  case srcType = "typ"
  case uidType = "uidt"
  case appName = "appn"
  case osInfo = "os"
  
  case sessionId = "sid"
  case timeInit = "tsu"
  case timeUpload = "tsc"
}

enum DefaultQueryKeysValues: String {
  case uidClass = "1"
  case deviceIdentity = "2"
  case deviceMNFC = "apple"
}
