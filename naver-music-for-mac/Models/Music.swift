//
//  Music.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 12..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RealmSwift

class Music: Object {
  @objc dynamic var id = ""
  @objc dynamic var name: String?
  @objc dynamic var lyrics: String?
  @objc dynamic var artist: Artist?
  @objc dynamic var album: Album?
  let playtime = RealmOptional<Double>()
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  func setPlaytime(time: Double) {
    guard self.playtime.value != time else {
      return
    }
    try? self.realm?.write {
      self.playtime.value = time
    }
  }
}
