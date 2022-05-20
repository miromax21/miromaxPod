//
//  extention.Date.swift
//  EventSDK
//
//  Created by Maksim Mironov on 16.05.2022.
//

import Foundation
extension Date {
  func getCurrentTimeStamp() -> Int{
    let secondsFromGmt = TimeZone.autoupdatingCurrent.secondsFromGMT()
    let timestamp  = Int(self.timeIntervalSince1970)
    return timestamp - secondsFromGmt
  }
}
