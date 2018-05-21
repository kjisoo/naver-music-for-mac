//
//  PlayListRepository.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 21..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation

extension Repository where T == Playlist {
  func getMyPlayList() -> T {
    return self.getOrCreate(identifier: "MY")
  }
  
  func appendMusic(musics: [Music]) {
    let playlist = self.getMyPlayList()
    self.update(object: playlist, value: ["musicStates": playlist.musicStates + musics.map({ (music) -> MusicState in
      let m = MusicState()
      m.music = music
      return m})])
  }
  
  func remove(at index: Int) {
    let playList = self.getMyPlayList()
    try? self.realm.write {
      if index < playList.musicStates.count {
        playList.musicStates.remove(at: index)
      }
    }
  }
  
  func remove(at indexs: [Int]) {
    let playList = self.getMyPlayList()
    realm.beginWrite()
    for index in indexs.sorted().reversed().filter({ $0 < playList.musicStates.count }) {
      playList.musicStates.remove(at: index)
    }
    try? realm.commitWrite()
  }
}
