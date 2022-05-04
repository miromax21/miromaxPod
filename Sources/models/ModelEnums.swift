//
//  ModelEnums.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

public enum SrcTypeEnum: Int {
  case web = 1, app, ott
}

public enum ContactType: Int {
  case undefined = 0, liveStream, vod, catchUp, article, socialMediaPost, liveAudio, audioByRequest
}

public enum EventType: Int {
  case stop = 0, start, heartBeat, pause
}
