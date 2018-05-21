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

class MusicBrowser {
  private let provider: MoyaProvider<NaverPage>
  private let topParser: TOPParser
  
  init(provider: MoyaProvider<NaverPage>, parser: TOPParser = TOPParser()) {
    self.provider = provider
    self.topParser = parser
  }
  
  func fetchTOPMusics(top type: TOPType) -> Single<[Music]> {
    return Single.zip(self.provider.rx.request(.top(domain: type.rawValue, page: 1)).filterSuccessfulStatusCodes(),
                      self.provider.rx.request(.top(domain: type.rawValue, page: 2)).filterSuccessfulStatusCodes())
      .map { [weak self] (firstResponse, secondResponse) -> [Music] in
        if let `self` = self,
          let firstResponseString = String(data: firstResponse.data, encoding: .utf8),
          let secondResponseString = String(data: secondResponse.data, encoding: .utf8) {
          let result = self.topParser.parse(from: firstResponseString) + self.topParser.parse(from: secondResponseString)
          return result.map { Music(value: $0) }
        }
        return []
    }
  }
  
  func fetchMyList() -> Single<[MusicList]> {
    return self.provider.rx.request(.myList).map {
      if let responseString = String(data: $0.data, encoding: .utf8) {
        let result = MyListParser().parse(from: responseString)
        return result.map { MusicList(value: $0) }
      }
      return []
    }
  }
  
  func fetchMusicList(listId: String) -> Single<[Music]> {
    return self.provider.rx.request(.listDetail(id: listId)).map {
      if let responseString = String(data: $0.data, encoding: .utf8) {
        let result = MusicListParser().parse(from: responseString)
        return result.map { Music(value: $0) }
      }
      return []
    }
  }
}
