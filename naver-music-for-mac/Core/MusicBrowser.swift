//
//  MusicBrowser.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 13..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum TOPType: String {
  case total = "TOTAL"
  case domestic = "DOMESTIC"
  case oversea = "OVERSEA"
}

protocol MusicBrowserType {
  func search(top type: TOPType) -> Single<[Music]>
}

class MusicBrowser: MusicBrowserType {
  private let provider: MoyaProvider<NaverPage>
  private let topParser: TOPParser

  init(provider: MoyaProvider<NaverPage>, parser: TOPParser = TOPParser()) {
    self.provider = provider
    self.topParser = parser
  }
  
  func search(top type: TOPType) -> Single<[Music]> {
    return Single.zip(self.provider.rx.request(.top(domain: type.rawValue, page: 1)).filterSuccessfulStatusCodes(),
                      self.provider.rx.request(.top(domain: type.rawValue, page: 2)).filterSuccessfulStatusCodes())
      .map { [weak self] (firstResponse, secondResponse) -> [Music]  in
        if let `self` = self,
          let firstResponseString = String(data: firstResponse.data, encoding: .utf8),
          let secondResponseString = String(data: secondResponse.data, encoding: .utf8) {
          let result = self.topParser.parse(from: firstResponseString) + self.topParser.parse(from: secondResponseString)
          return result.map { $0.music }
        }
        return []
    }
  }
}
