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
  private var shuffledMusicStates: [MusicState] = []
  private var currentMusicStates: [MusicState] {
    if self.isShuffled {
      if self.shuffledMusicStates.count != self.musicStates.count {
        self.shuffledMusicStates = self.musicStates.toArray().shuffled()
      }
      return self.shuffledMusicStates
    } else {
      return self.musicStates.toArray()
    }
  }
  
  class func getMyPlayList() -> Playlist {
    var playList: Playlist!
    let realm = try! Realm()
    try? realm.write {
      playList = realm.create(Playlist.self, value: ["id": "MY"], update: true)
    }
    return playList
  }
  
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
    if isShuffled {
      self.shuffledMusicStates = self.musicStates.toArray().shuffled()
    }
  }
  
  private func index(id: String) -> Int? {
    return self.currentMusicStates.index(where: { $0.id == id })
  }
  
  private func playingIndex() -> Int? {
    return self.currentMusicStates.index(where: { $0.isPlaying })
  }
  
  public func playingMusicState() -> MusicState? {
    return self.currentMusicStates.filter({ $0.isPlaying }).first
  }
  
  public func appendMusic(musics: [Music]) {
    let musicStates = musics.map { MusicState(value: ["music": $0]) }
    try? self.realm?.write {
      self.musicStates.append(objectsIn: musicStates)
    }
    self.shuffledMusicStates.append(contentsOf: musicStates)
  }
  
  // TODO: 셔플 배열에서도 삭제해야함
  func remove(at index: Int) {
    try? self.realm?.write {
      if index < self.musicStates.count {
        self.musicStates.remove(at: index)
      }
    }
  }
  
  // TODO: 셔플 배열에서도 삭제해야함
  func remove(at indexs: [Int]) {
    self.realm?.beginWrite()
    for index in indexs.sorted().reversed().filter({ $0 < self.musicStates.count }) {
      self.musicStates.remove(at: index)
    }
    try? self.realm?.commitWrite()
  }
  
  public func next() -> MusicState? {
    if let index = self.playingIndex(),
      let currentState = self.playingMusicState() {
      currentState.changePlaying(isPlaying: false)
      if index + 1 < self.currentMusicStates.count {
        let nextState = self.currentMusicStates[index + 1]
        nextState.changePlaying(isPlaying: true)
        return nextState
      } else {
        self.shuffledMusicStates = self.musicStates.toArray().shuffled()
        let nextState = self.currentMusicStates.first
        nextState?.changePlaying(isPlaying: true)
        return nextState
      }
    } else if self.currentMusicStates.count > 0,
      let nextState = self.currentMusicStates.first {
      nextState.changePlaying(isPlaying: true)
      return nextState
    }
    return nil
  }
  
  public func prev() -> MusicState? {
    if let index = self.playingIndex(),
      let currentState = self.playingMusicState() {
      currentState.changePlaying(isPlaying: false)
      if index - 1 >= 0 {
        let nextState = self.currentMusicStates[index - 1]
        nextState.changePlaying(isPlaying: true)
        return nextState
      } else {
        self.shuffledMusicStates = self.musicStates.toArray().shuffled()
        let nextState = self.currentMusicStates.last
        nextState?.changePlaying(isPlaying: true)
        return nextState
      }
    } else if self.currentMusicStates.count > 0,
      let nextState = self.currentMusicStates.last {
      nextState.changePlaying(isPlaying: true)
      return nextState
    }
    return nil
  }
}
