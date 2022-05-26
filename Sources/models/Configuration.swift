//
//  Configuration.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation

public protocol RequestConfiguration: AnyObject  {
  
  var heartbeatInterval: Double { get }
  var sendingQueueBufferSize: Int { get }
  
  /// Request `URLComponents` configuration
  /// URLComponents based structure to configure the base part of the target URL
  var urlComponents: URLComponents! {get}

  /// Request `URLQueryItem` configuration
  /// Map self to  `[URLQueryItem: Value]` for  `baseQueryItems` configuration
  func toQuery() -> [[String: Any?]]
  
  /// Request `URLQueryItem` configuration
  /// Map dictionary of data to `[URLQueryItem]` for request to server
  func mapQuery(query: [[String: Any?]]) -> [URLQueryItem]
}

// User configuration object
// serves to recognize and calculate statistics on the server side
public protocol ConfigurationType: RequestConfiguration {
  
  /// Client ID.
  /// Assigned by Mediascope
  var cid: String! {get}
  
  /// The ID of the thematic section.  Assigned by Mediascope
  var tms: String!  {get}
  
  /// Identifier linked to the user's account in the Owner's system
  var hid: String? {get}
  
  ///Application/user install ID (technical)
  var uid: String? {get}
  
  /// User/device ID
  var uidc: Int? {get}

}

extension ConfigurationType {
  
  
  public var heartbeatInterval: Double {
      return 30.0
  }
  
  public var sendingQueueBufferSize: Int {
      return 1000
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
