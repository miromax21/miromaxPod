//
//  NSEventSDK.swift
//  EventSDK
//
//  Created by Sergey Zhidkov on 02.06.2022.
//

import Foundation
public class NSEventSDK: NSObject{
  private var eventSdk: EventSDK!
  @objc public init(configuration: NSConfiguration){
    super.init()
    eventSdk = EventSDK(configuration: configuration)
  }

  @objc public func next(contactType: Int, view: NSNumber?, idc: NSNumber?, idlc: String,  fts: Int64,  urlc: String,  media: String, ver: NSNumber?) {
    var eventView: EventType? = nil
    if let view = view {
      eventView = EventType(rawValue: Int(truncating: view))
    }
    eventSdk.next(Event(contactType: ContactType(rawValue: Int(contactType)), view: eventView, idc: idc as? Int, idlc: idlc, fts: fts, urlc: urlc, media: media, ver: ver as? Int))
  }

  @objc public func getSendingQueue() -> Array<String>{
    return eventSdk.sendingQueue.compactMap {$0}
  }
  
  @objc public func getSendingAbility() -> Bool{
    return eventSdk.sendingIsAvailable
  }
  
  @objc public func getUserAttributes() -> NSMutableDictionary  {
    let nsAttributes: NSMutableDictionary = [:]
    eventSdk.userAttributes.forEach{
      if let next = $0.first{
        nsAttributes.setObject(next.value, forKey: next.key as NSCopying)
      }
    }
    return nsAttributes
  }
}
