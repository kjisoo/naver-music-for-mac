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
  @objc dynamic var name = ""
  let musics = List<Music>()
  
  override class func primaryKey() -> String? {
    return "name"
  }
  
  static func createIfNil(name: String, realm: Realm) -> Playlist {
    if let playlist = realm.object(ofType: Playlist.self, forPrimaryKey: name) {
      return playlist
    } else {
      let playlist = Playlist(value: ["name": name])
      try? realm.write {
        realm.add(playlist)
      }
      return playlist
    }
  }
}
