//
//  Configuration.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation
// User configuration object
// serves to recognize and calculate statistics on the server side
public struct Configuration {
  
  var urlPath: String! = "e/msdkec01"
  
  /// User/device ID
  var uid: String!
  
  /// CatID - the ID of the local directory of the EC on the site where this EC is recorded.
  /// Assigned by Mediascope.
  var catId: Int!
  
  /// Identifier linked to the user's account in the Owner's system
  var hardId: String!
  
  /// Source type identifier.
  var srctype: SrcTypeEnum!
  
  /// Client ID.
  /// Assigned by Mediascope
  var partnerName: String!
  
}
