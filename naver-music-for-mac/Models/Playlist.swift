//
//  Playlist.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 12..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RealmSwift

enum PlayListType: String {
  case total = "TOTAL"
  case domestic = "DOMESTIC"
  case oversea = "OVERSEA"
  case my = "MY"
}

class Playlist: Object {
  @objc dynamic var name = ""
  let musics = List<Music>()
  
  override class func primaryKey() -> String? {
    return "name"
  }
  
  public static func get(type: PlayListType) -> Playlist {
    var playList: Playlist!
    try? realm.write {
      playList = realm.create(Playlist.self, value: ["name": type.rawValue], update: true)
    }
    return playList
  }
  
  public func append(musicID: String) {
    self.realm.beginWrite()
    let music = realm.create(Music.self, value: ["id": musicID], update: true)
    self.musics.append(music)
    try? self.realm.commitWrite()
  }
  
  public func append(musicIDs: [String]) {
    self.realm.beginWrite()
    let musics = musicIDs.map({realm.create(Music.self, value: ["id": $0], update: true)})
    self.musics.append(objectsIn: musics)
    try? self.realm.commitWrite()
  }
  
  public func append(music: Music) {
    try? self.realm.write {
      self.musics.append(music)
    }
  }
  
  public func append(musics: [Music]) {
    try? self.realm.write {
      self.musics.append(objectsIn: musics)
    }
  }
  
  public func remove(at index: Int) {
    try? self.realm.write {
      if index < self.musics.count {
        self.musics.remove(at: index)
      }
    }
  }
  
  public func remove(at indexs: [Int]) {
    realm.beginWrite()
    for index in indexs.sorted().reversed().filter({ $0 < self.musics.count }) {
      self.musics.remove(at: index)
    }
    try? realm.commitWrite()
  }
}
