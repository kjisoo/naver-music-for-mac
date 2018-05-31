//
//  MusicState.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 17..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RealmSwift

class MusicState: Object {
  @objc dynamic var id = UUID().uuidString
  @objc dynamic var isPlaying = false
  @objc dynamic var music: Music!
  override class func primaryKey() -> String? {
    return "id"
  }
  
  func changePlaying(isPlaying: Bool) {
    if self.isPlaying != isPlaying {
      try? self.realm?.write {
        self.isPlaying = isPlaying
      }
    }
  }
}
