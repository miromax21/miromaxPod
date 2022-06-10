//
//  extention.ConfigurationType.swift
//  EventSDK
//
//  Created by Sergey Zhidkov on 03.06.2022.
//

import Foundation
extension ConfigurationType {
  
  public var sendingQueueBufferSize: Int {
      return 1000
  }
  
  public var heartbeatInterval: Double {
      return 30.0
  }
  
  public var urlComponents: URLComponents! {
      var urlComponents = URLComponents()
      urlComponents.scheme = "https"
      urlComponents.host = "tns-counter.ru"
      urlComponents.path = "/e/msdkev"
      return urlComponents
  }
  
  public func toQuery() -> [[String: Any?]] {
    typealias Keys = QueryKeys
    return [
      [Keys.cid.rawValue : cid],
      [Keys.hid.rawValue : hid],
      [Keys.uidc.rawValue : uidc],
      [Keys.uid.rawValue: uid],
      [Keys.tms.rawValue : tms],
    ]
  }
  
  public func mapQuery(query: [[String: Any?]]) -> [URLQueryItem]{
    let queryItems: [URLQueryItem?] = query.compactMap {
      if let key = $0.first?.key, let value = $0.first?.value{
        return URLQueryItem(name: key, value: String(describing: value))
      }
      return nil
    }
    return queryItems.compactMap{$0}
  }
}
