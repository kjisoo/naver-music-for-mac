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
  let musicStates = List<MusicState>()
  
  override class func primaryKey() -> String? {
    return "id"
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
