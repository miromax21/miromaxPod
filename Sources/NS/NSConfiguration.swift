//
//  NSConfiguration.swift
//  EventSDK
//
//  Created by Maksim Mironov on 02.06.2022.
//

import Foundation
public class NSConfiguration: NSObject, ConfigurationType {
  public var cid: String = ""

  public var tms: String = ""

  public var hid: String?

  public var uid: String?

  public var uidc: Int?

  @objc public init(cid: String, tms: String, uid: String?, hid: String?, uidc: NSNumber?) {
    super.init()
    self.cid = cid
    self.tms = tms
    self.hid = hid
    self.uidc = uidc as? Int
  }
}
