//
//  ModelEnums.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

public enum ContactType: Int {
  /// Undefined
  case undefined = 0
  /// TV broadcast, streaming
  case liveStream
  /// Video-on-Demand
  case vod
  /// Delayed TV viewing
  case catchUp
  /// Contact with textual material (article)
  case article
  /// Social media post
  case socialMediaPost
  /// Online radio, streaming audio
  case liveAudio
  /// Audio on demand
  case audioByRequest
}

public enum EventType: Int {
  case stop = 0, start, heartBeat, pause
}
