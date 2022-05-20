//
//  ApiRequest.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation
import CoreVideo
import UIKit
public typealias Action = (_ success: Bool,_ query: String) -> ()
public protocol PluginType {
  /// Called to modify a request before sending.
  func prepare(_ request: URLRequest) -> URLRequest
}

struct RequestService {
  
  var plugins: [PluginType] = []
  
  init(plugins: [PluginType] = []){
    self.plugins = plugins
  }
  
  func sendRequest(request: URLRequest, completion: @escaping (_ success: Bool) -> ()){
    var currentRequest = request
    let urlSession = URLSessionApiSrevices()
    if !plugins.isEmpty {
      plugins.forEach{
        currentRequest = $0.prepare(request)
      }
    }
    urlSession.callAPI(request: currentRequest) { success in
        completion(success)
    }
  }
  
}

struct URLSessionApiSrevices {
  var error : String?
  
  private var urlSession: URLSession
  
  public init(config:URLSessionConfiguration = .default) {
    self.urlSession = URLSession(configuration: config)
  }
  
  func callAPI(request: URLRequest, completion: @escaping (Bool) -> ())  {
    let task = self.urlSession.dataTask(with: request) { (data, response, error) in
      if error != nil {
        completion(false)
        return
      }
      if let httpResponse = response as? HTTPURLResponse, let statusCode = httpResponse.statusCode as Int?{
        completion(statusCode == 200)
        return
      }
      completion(false)
    }
    task.resume()
  }
  
}
