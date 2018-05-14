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
}

extension NaverPage: TargetType {
  var baseURL: URL {
    switch self {
    case .top:
      return URL(string: "http://music.naver.com")!
    }
  }
  
  var path: String {
    switch self {
    case .top:
      return "/listen/top100.nhn"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .top:
      return .get
    }
  }
  
  var task: Task {
    switch self {
    case .top(let domain, let page):
      return .requestParameters(parameters: ["domain": domain, "page": page],
                                encoding: URLEncoding.queryString)
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var sampleData: Data {
    return Data()
  }
  
}
