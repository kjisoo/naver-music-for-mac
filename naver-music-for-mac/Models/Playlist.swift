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
  @objc dynamic var id = ""
  @objc dynamic var name = ""
  let musicStates = List<MusicState>()
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  public static func get(type: PlayListType) -> Playlist {
    var playList: Playlist!
    try? realm.write {
      playList = realm.create(Playlist.self, value: ["id": type.rawValue], update: true)
    }
    return playList
  }
  
  public func append(musicID: String) {
    self.realm.beginWrite()
    let music = realm.create(MusicState.self, value: ["music": ["id": musicID]], update: true)
    self.musicStates.append(music)
    try? self.realm.commitWrite()
  }
  
  public func append(musicIDs: [String]) {
    self.realm.beginWrite()
    let musics = musicIDs.map({realm.create(MusicState.self, value: ["music": ["id": $0]], update: true)})
    self.musicStates.append(objectsIn: musics)
    try? self.realm.commitWrite()
  }
  
  public func append(music: MusicState) {
    try? self.realm.write {
      self.musicStates.append(music)
    }
  }
  
  public func append(musics: [MusicState]) {
    try? self.realm.write {
      self.musicStates.append(objectsIn: musics)
    }
  }
  
  public func remove(at index: Int) {
    try? self.realm.write {
      if index < self.musicStates.count {
        self.musicStates.remove(at: index)
      }
    }
  }
  
  public func remove(at indexs: [Int]) {
    realm.beginWrite()
    for index in indexs.sorted().reversed().filter({ $0 < self.musicStates.count }) {
      self.musicStates.remove(at: index)
    }
    try? realm.commitWrite()
  }
  
  public func index(id: String) -> Int? {
    return self.musicStates.index(where: { $0.id == id })
  }
  
  public func playingIndex() -> Int? {
    return self.musicStates.index(where: { $0.isPlaying })
  }
  
  public func playingMusicState() -> MusicState? {
    return self.musicStates.filter({ $0.isPlaying }).first
  }
}
