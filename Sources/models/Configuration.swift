//
//  Configuration.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation

// User configuration object
// serves to recognize and calculate statistics on the server side
public protocol ConfigurationType: AnyObject {
  
  /// CatID - the ID of the local directory of the EC on the site where this EC is recorded.
  /// Assigned by Mediascope.
  var catId: Int! {get}
  
  /// User/device ID
  var uid: String! {get}
  
  /// Identifier linked to the user's account in the Owner's system
  var hardId: String! {get}
  
  /// Client ID.
  /// Assigned by Mediascope
  var partnerName: String! {get}
}

extension ConfigurationType {
  
  /// Request Configuration
  /// URLComponents based structure to configure the base part of the target URL
  public var urlComponents: URLComponents! {
    get {
      var urlComponents = URLComponents()
      urlComponents.scheme = "https"
      urlComponents.host = "tns-counter.ru"
      urlComponents.path = "e/msdkec01"
      return urlComponents
    }
  }
}
