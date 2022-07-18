//
//  DefaultPackageData.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

struct DefaultPackageData {

  var hasFullinformation: Bool = false

  private var osVersion: String {
    let version = ProcessInfo().operatingSystemVersion
    return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
  }

  private(set) var queryDictionary: [[String: Any]] = []

  func initBaseQuery(join with: [[String: Any?]] ) -> [[String: Any]] {
    var query = queryDictionary
    with.forEach {
      if let next = $0.first, let value = next.value {
        query.append([next.key: value])
      }
    }
    return query
  }

  init() {
    let device = DeviceData()
    queryDictionary = [
      [QueryKeys.os.rawValue: "ios \(osVersion)"],
      [QueryKeys.typ.rawValue: "2"],
      [QueryKeys.dvn.rawValue: "apple"],
      [QueryKeys.sid.rawValue: device.uuid],
      [QueryKeys.dvi.rawValue: device.identity],
      [QueryKeys.dvm.rawValue: device.getDeviceName()],
      [QueryKeys.appv.rawValue: getBundleData(for: "CFBundleShortVersionString") ?? ""],
      [QueryKeys.appn.rawValue: getBundleData(for: "CFBundleName") as String? ?? ""]
    ]
    hasFullinformation = device.isFulldentity
  }

  private func getBundleData<T>(for key: String) -> T? {
    return Bundle.main.infoDictionary![key] as? T
  }
}
