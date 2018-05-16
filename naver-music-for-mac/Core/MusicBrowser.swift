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


protocol MusicBrowserType {
  func getPlayList(type: PlayListType) -> Playlist
  func updateTOPPlayList(top type: TOPType) -> Single<Playlist>
  func addMusicToMyList(trackID: String)
  func addMusicToMyList(trackIDs: [String])
}

class MusicBrowser: MusicBrowserType {
  private let provider: MoyaProvider<NaverPage>
  private let topParser: TOPParser
  private let realm: Realm

  init(provider: MoyaProvider<NaverPage>, parser: TOPParser = TOPParser(), realm: Realm = try! Realm()) {
    self.provider = provider
    self.topParser = parser
    self.realm = realm
  }
  
  func getPlayList(type: TOPType) -> Playlist {
    var playList: Playlist?
    try? realm.write {
      playList = self.realm.create(Playlist.self, value: ["name": type.rawValue], update: true)
    }
    return playList!
  }
  
  func getPlayList(type: PlayListType) -> Playlist {
    var playList: Playlist?
    try? realm.write {
      playList = self.realm.create(Playlist.self, value: ["name": type.rawValue], update: true)
    }
    return playList!
  }
  
  func updateTOPPlayList(top type: TOPType) -> Single<Playlist> {
    return Single.zip(self.provider.rx.request(.top(domain: type.rawValue, page: 1)).filterSuccessfulStatusCodes(),
                      self.provider.rx.request(.top(domain: type.rawValue, page: 2)).filterSuccessfulStatusCodes())
      .map { [weak self] (firstResponse, secondResponse) in
        var playList: Playlist!
        if let `self` = self,
          let firstResponseString = String(data: firstResponse.data, encoding: .utf8),
          let secondResponseString = String(data: secondResponse.data, encoding: .utf8) {
          let result = self.topParser.parse(from: firstResponseString) + self.topParser.parse(from: secondResponseString)
          try? self.realm.write {
            let playListValue: [String : Any] = ["name": type.rawValue, "musics": result]
            playList = self.realm.create(Playlist.self, value: playListValue, update: true)
          }
        }
        return playList
    }
  }
  
  func addMusicToMyList(trackID: String) {
    let playList = self.getPlayList(type: PlayListType.my)
    try? realm.write {
      let music = realm.create(Music.self, value: ["id": trackID], update: true)
      playList.musics.append(music)
    }
  }
  
  func addMusicToMyList(trackIDs: [String]) {
    trackIDs.forEach { self.addMusicToMyList(trackID: $0) }
  }
}
