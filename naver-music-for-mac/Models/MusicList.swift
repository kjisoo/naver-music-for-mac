//
//  MusicList.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 21..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RealmSwift

class MusicList: Object {
  @objc dynamic var id = ""
  @objc dynamic var name = ""
  let musics = List<Music>()
  
  override class func primaryKey() -> String? {
    return "id"
  }
}
