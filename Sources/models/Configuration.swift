//
//  Configuration.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation

public protocol RequestConfiguration: AnyObject {

  /// Sending state:
  /// Interval of sending heartbeat request
  var heartbeatInterval: Double { get }

  /// Request `URL` transformation:
  /// User plugins
  var plugins: [PluginType]? { get }

  /// Request `URL` configuration:
  /// Replace all occurrences of the target URL with the value of the corresponding key
  var urlReplacingOccurrences: [String: String] { get }

  /// Sending state:
  /// Max number of saved unsent requests
  var sendingQueueBufferSize: Int { get }

  /// Request `URL` configuration:
  /// Basic URL that will be extended by events
  var baseUrl: URL {get}

  /// Request `URLQueryItem` configuration:
  /// Map self to  `[URLQueryItem: Value]` for  `baseQueryItems` configuration
  func toQuery() -> [[String: Any?]]

  /// Request `URLQueryItem` configuration:
  /// Map dictionary of data to `[URLQueryItem]` for request to server
  func mapQuery(query: [[String: Any?]]) -> [URLQueryItem]
}

// User configuration object
// serves to recognize and calculate statistics on the server side
public protocol ConfigurationType: RequestConfiguration {

  /// Client information:
  /// User/device ID
  var uidc: Int? {get}

  /// Client information:
  /// Assigned by Mediascope
  var cid: String {get}

  /// Client information:
  /// The ID of the thematic section.  Assigned by Mediascope
  var tms: String {get}

  /// Client information:
  /// Identifier linked to the user's account in the Owner's system
  var hid: String? {get}

  /// Client information:
  /// Application/user install ID (technical)
  var uid: String? {get}
}
