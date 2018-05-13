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
  @objc dynamic var name: String?
  @objc dynamic var musics: [Music] = []
  
  override class func primaryKey() -> String? {
    return "name"
  }
}
