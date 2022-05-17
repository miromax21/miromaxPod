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
  
  private lazy var queryDictionary: [[String: Any]] = {
    let device = DeviceData()
    typealias Keys = QueryKeys
    return [
      [Keys.dvi.rawValue: device.identity],
      [Keys.dvm.rawValue : device.getDeviceName()],
      [Keys.dvn.rawValue : "apple"],
      [Keys.appv.rawValue : getBundleData(for: "CFBundleShortVersionString") ?? ""],
      [Keys.sid.rawValue : device.uuid],
      [Keys.appn.rawValue : getBundleData(for: "CFBundleName") ?? ""],
      [Keys.os.rawValue : "ios \(osVersion)"],
      [Keys.typ.rawValue : "2"]
    ]
  }()
  
  func initBaseQuery(join with: [[String: Any?]] ) -> [[String: Any?]]{
    var query = queryDictionary
    with
      .filter{ $0.values.first != nil  }
      .forEach{ query.append($0 as [String : Any])  }
    return query
  }
  
  private func getBundleData<T>(for key: String) -> T? {
    return Bundle.main.infoDictionary![key] as? T
  }
  
}
