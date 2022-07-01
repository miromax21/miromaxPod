//
//  DefaultPackageData.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation
final class DefaultPackageData {

  private var osVersion: String {
      let version = ProcessInfo().operatingSystemVersion
      return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
  }

  private lazy var queryDictionary: [[String: Any]] = {
    let device = DeviceData()
    typealias Keys = QueryKeys
    return [
      [Keys.os.rawValue: "ios \(osVersion)"],
      [Keys.typ.rawValue: "2"],
      [Keys.dvn.rawValue: "apple"],
      [Keys.sid.rawValue: device.uuid],
      [Keys.dvi.rawValue: device.identity],
      [Keys.dvm.rawValue: device.getDeviceName()],
      [Keys.appv.rawValue: getBundleData(for: "CFBundleShortVersionString") ?? ""],
      [Keys.appn.rawValue: getBundleData(for: "CFBundleName") as String? ?? ""]
    ]
  }()

  func initBaseQuery(join with: [[String: Any?]] ) -> [[String: Any]] {
    var query = queryDictionary
    with.forEach {
      if let next = $0.first, let value = next.value {
        query.append([next.key: value])
      }
    }
    return query
  }

  private func getBundleData<T>(for key: String) -> T? {
    return Bundle.main.infoDictionary![key] as? T
  }
}
