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
  @objc dynamic var playtime: Double = 0.0
  
  override class func primaryKey() -> String? {
    return "id"
  }
}
