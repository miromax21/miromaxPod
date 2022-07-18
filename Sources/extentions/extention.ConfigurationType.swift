//
//  extention.ConfigurationType.swift
//  EventSDK
//
//  Created by Maksim Mironov on 03.06.2022.
//

import Foundation

extension ConfigurationType {

  public var sendingQueueBufferSize: Int {
    return 1000
  }

  public var heartbeatInterval: Double {
    return 30.0
  }

  public var plugins: [PluginType]? {
    return nil
  }

  public var baseUrl: URL {
     return URL(string: "https://tns-counter.ru/e/msdkev/")!
  }

  public var urlReplacingOccurrences: [String: String] {
    ["msdkev/?": "msdkev/&"]
  }

  public func toQuery() -> [[String: Any?]] {
    typealias Keys = QueryKeys
    return [
      [Keys.cid.rawValue: cid],
      [Keys.hid.rawValue: hid],
      [Keys.uidc.rawValue: uidc],
      [Keys.uid.rawValue: uid],
      [Keys.tms.rawValue: tms]
    ]
  }

  public func mapQuery(query: [[String: Any?]]) -> [URLQueryItem] {
    var queryItems: [URLQueryItem] = []
    query.forEach {
      guard
        let key = $0.first?.key,
        let value = $0.first?.value,
        String(describing: value) != ""
      else { return }
      queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
    }
    return queryItems
  }
}
