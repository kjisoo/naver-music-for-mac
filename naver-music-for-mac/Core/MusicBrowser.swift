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


enum TOPType: String {
  case total = "TOTAL"
  case domestic = "DOMESTIC"
  case oversea = "OVERSEA"
}

class MusicBrowser {
  private let provider: MoyaProvider<NaverPage>
  private let realm: Realm
  
  init(provider: MoyaProvider<NaverPage>, realm: Realm = try! Realm()) {
    self.provider = provider
    self.realm = realm
  }
  
  func fetchTOPMusics(top type: TOPType) -> Single<[Music]> {
    return Single.zip(self.provider.rx.request(.top(domain: type.rawValue, page: 1)).filterSuccessfulStatusCodes(),
                      self.provider.rx.request(.top(domain: type.rawValue, page: 2)).filterSuccessfulStatusCodes())
      .map { (firstResponse, secondResponse) -> [Music] in
        if let firstResponseString = String(data: firstResponse.data, encoding: .utf8),
          let secondResponseString = String(data: secondResponse.data, encoding: .utf8) {
          let parser = TOPParser()
          let result = parser.parse(from: firstResponseString) + parser.parse(from: secondResponseString)
          return result.map { value in
            var music: Music!
            try? self.realm.write {
              music = self.realm.create(Music.self, value: value, update: true)
            }
            return music
          }
        }
        return []
    }
  }
  
  func fetchMyList() -> Single<[MusicList]> {
    return self.provider.rx.request(.myList).map {
      if let responseString = String(data: $0.data, encoding: .utf8) {
        let result = MyListParser().parse(from: responseString)
        return result.map { value in
          var musicList: MusicList!
          try? self.realm.write {
            musicList = self.realm.create(MusicList.self, value: value, update: true)
          }
          return musicList
        }
      }
      return []
    }
  }
  
  func fetchMusicList(listId: String) -> Single<[Music]> {
    return self.provider.rx.request(.listDetail(id: listId)).map {
      if let responseString = String(data: $0.data, encoding: .utf8) {
        let result = MusicListParser().parse(from: responseString)
        return result.map { value in
          var music: Music!
          try? self.realm.write {
            music = self.realm.create(Music.self, value: value, update: true)
          }
          return music
        }
      }
      return []
    }
  }
  
  func fetchMusic(musicId: String) -> Single<Music> {
    return self.provider.rx.request(.musicDetail(id: musicId)).map {
      if let responseString = String(data: $0.data, encoding: .utf8) {
        let result = MusicParser().parse(from: responseString)
        if result.count > 0 {
          var music: Music!
          try? self.realm.write {
            music = self.realm.create(Music.self, value: result[0], update: true)
          }
          return music
        }
        throw MoyaError.jsonMapping($0)
      }
      throw MoyaError.jsonMapping($0)
    }
  }
}
