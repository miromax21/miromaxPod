//
//  DefaultPackageData.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation
final class DefaultPackageData {

  private var osVersion : String {
      let version = ProcessInfo().operatingSystemVersion
      return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
  }
  
  private lazy var queryDictionary: [[QueryKeys: Any?]] = {
    let device = DeviceUtils.shared
    return [
      [.deviceInterface: DefaultQueryKeysValues.deviceIdentity.rawValue],
      [.deviceIdType : device.identity.id],
      [.deviceModel : device.getDeviceName()],
      [.deviceMNFC : DefaultQueryKeysValues.deviceMNFC.rawValue],
      [.appVersion : getBundleData(for: "CFBundleShortVersionString")],
      [.deviceType : device.identity.type],
      [.sessionId : device.uuid],
      [.timeInit : device.getCurrentTimeStamp],
      [.uidClass : Int(DefaultQueryKeysValues.uidClass.rawValue) ?? 0],
      [.uidType : ""],
      [.appName : getBundleData(for: "CFBundleName")],
      [.osInfo : "ios \(osVersion)"],
    ]
  }()
  
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

