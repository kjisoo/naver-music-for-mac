//
//  NaverPage.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 14..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import Moya

enum NaverPage {
  case top(domain: String, page: Int)
  case myList
  case listDetail(id: String)
  case musicDetail(id: String)
}

extension NaverPage: TargetType {
  var baseURL: URL {
    switch self {
    case .top, .musicDetail:
      return URL(string: "http://music.naver.com")!
    case .myList, .listDetail:
      return URL(string: "http://m.music.naver.com")!
    }
  }
  
  var path: String {
    switch self {
    case .top:
      return "/listen/top100.nhn"
    case .myList:
      return "/myMusic/myList.nhn"
    case .listDetail:
      return "/myMusic/myalbum.nhn"
    case .musicDetail:
      return "/lyric/index.nhn"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var task: Task {
    switch self {
    case .top(let domain, let page):
      return .requestParameters(parameters: ["domain": domain, "page": page],
                                encoding: URLEncoding.queryString)
    case .listDetail(let id):
      return .requestParameters(parameters: ["albumId": id],
                                encoding: URLEncoding.queryString)
    case .musicDetail(let id):
      return .requestParameters(parameters: ["trackId": id],
                                encoding: URLEncoding.queryString)
    default:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .myList, .listDetail:
      return ["User-Agent": "Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Mobile Safari/537.36"]
    default:
      return nil
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
}
