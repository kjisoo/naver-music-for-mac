//
//  Playlist.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 12..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RealmSwift

class Playlist: Object {
  @objc dynamic var id = "MY"
  @objc dynamic var name = ""
  @objc dynamic var isRepeated = true
  @objc dynamic var isShuffled = false
  @objc dynamic var volume: Double = 1.0
  let musicStates = List<MusicState>()
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  public func setIsRepeated(isRepeated: Bool) {
    try? self.realm?.write {
      self.isRepeated = isRepeated
    }
  }
  
  public func setIsShuffled(isShuffled: Bool) {
    try? self.realm?.write {
      self.isShuffled = isShuffled
    }
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
  
  class func getMyPlayList() -> Playlist {
    var playList: Playlist!
    let realm = try! Realm()
    try? realm.write {
      playList = realm.create(Playlist.self, value: ["id": "MY"], update: true)
    }
    return playList
  }
  
  func appendMusic(musics: [Music]) {
    try? self.realm?.write {
      self.musicStates.append(objectsIn: musics.map { MusicState(value: ["music": $0]) })
    }
  }
  
  func remove(at index: Int) {
    try? self.realm?.write {
      if index < self.musicStates.count {
        self.musicStates.remove(at: index)
      }
    }
  }
  
  func remove(at indexs: [Int]) {
    self.realm?.beginWrite()
    for index in indexs.sorted().reversed().filter({ $0 < self.musicStates.count }) {
      self.musicStates.remove(at: index)
    }
    try? self.realm?.commitWrite()
  }
}
