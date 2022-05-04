//
//  ApiRequest.swift
//  EventSDK
//
//  Created by Maksim Mironov on 13.04.2022.
//

import Foundation
public protocol PluginType {
    /// Called to modify a request before sending.
  func prepare(_ request: URLRequest) -> URLRequest
}

struct RequestService {
  
  var plugins: [PluginType] = []
  
  init(plugins: [PluginType] = []){
    self.plugins = plugins
  }
  
  func sendData(queryitems: [URLQueryItem] = [], path: String? = nil, completion: @escaping Action){
    let request = makeRequest(queryitems, path)
    sendRequest(request: request, completion: completion)
  }
  
  func makeRequest(_ queryitems: [URLQueryItem] = [], _  path: String! = "") -> URLRequest {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "tns-counter.ru"
    urlComponents.path = path
    urlComponents.queryItems = queryitems
    return URLRequest(url: urlComponents.url!)
  }
  
  func sendRequest(request: URLRequest, completion: @escaping Action){
    var currentRequest = request
    let urlSession = URLSessionApiSrevices()
    if !plugins.isEmpty {
      plugins.forEach{
        currentRequest = $0.prepare(request)
      }
    }
    urlSession.send(with: currentRequest) { success in
        completion(success)
    }
  }
  
}

struct URLSessionApiSrevices {
  private var urlSession: URLSession
  
  fileprivate let cache = URLCache.shared
  
  public init(config:URLSessionConfiguration = URLSessionConfiguration.default) {
    self.urlSession = URLSession(configuration: config)
  }
  
  func send(with request: URLRequest, completion: @escaping (Bool) -> ()) {
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


