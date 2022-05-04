//
//  DefaultPackageData.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation
final class DefaultPackageData {
  
  private var deviceIdType : String!
  private var deviceModel : String!
  private var appVersion : String!
  private var deviceType : String!
  private var deviceMNFC : String!
  private var uidClass : Int!
  private var appName : String!
  private var osInfo : String!

  private var uidType : String?
  
  private var osVersion : String {
      let version = ProcessInfo().operatingSystemVersion
      return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
  }
  
  private lazy var queryDictionary: [[QueryKeys: Any?]] = {
    return [
      [.deviceModel : deviceModel],
      [.deviceType : deviceType],
      [.deviceMNFC : deviceMNFC],
      [.appVersion : appVersion],
      [.uidClass : uidClass],
      [.uidType : uidType],
      [.appName : appName],
      [.osInfo : osInfo],
    ]
  }()
  
  init() {
    appVersion = getBundleData(for: "CFBundleShortVersionString")
    uidClass = Int(DefaultQueryKeysValues.uidClass.rawValue) ?? 0
    deviceMNFC  = DefaultQueryKeysValues.deviceMNFC.rawValue
    deviceType = DefaultQueryKeysValues.deviceType.rawValue
    deviceModel = DeviceUtils.shared.getDeviceName()
    appName = getBundleData(for: "CFBundleVersion")
    osInfo = "ios \(osVersion)"
    deviceIdType = ""
    uidType = ""
  }
  
  func initBaseQuery(join with: [[QueryKeys: Any?]] ) -> [[QueryKeys: Any?]]{
    var query = queryDictionary
    with.forEach{
      query.append($0)
    }
    return query
  }
  
  private func getBundleData<T>(for key: String) -> T? {
    return Bundle.main.infoDictionary![key] as? T
  }
  
}

