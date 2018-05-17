//
//  MusicBrowser.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 13..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import Moya


class MusicBrowser {
  private let provider: MoyaProvider<NaverPage>
  private let topParser: TOPParser
  private let realm: Realm

  init(provider: MoyaProvider<NaverPage>, parser: TOPParser = TOPParser(), realm: Realm = try! Realm()) {
    self.provider = provider
    self.topParser = parser
    self.realm = realm
  }
  
  func updateTOPPlayList(top type: PlayListType) -> Single<Playlist> {
    return Single.zip(self.provider.rx.request(.top(domain: type.rawValue, page: 1)).filterSuccessfulStatusCodes(),
                      self.provider.rx.request(.top(domain: type.rawValue, page: 2)).filterSuccessfulStatusCodes())
      .map { [weak self] (firstResponse, secondResponse) in
        let playList = Playlist.get(type: type)
        if let `self` = self,
          let firstResponseString = String(data: firstResponse.data, encoding: .utf8),
          let secondResponseString = String(data: secondResponse.data, encoding: .utf8) {
          let result = self.topParser.parse(from: firstResponseString) + self.topParser.parse(from: secondResponseString)
          try? self.realm.write {
            playList.musicStates.removeAll()
            playList.musicStates.append(objectsIn: result.map({self.realm.create(MusicState.self, value: ["music": $0], update: true)}))
          }
        }
        return playList
    }
  }
}
