//
//  Album.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 12..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RealmSwift

class Album: Object {
  @objc dynamic var id: String?
  @objc dynamic var name: String?
  @objc dynamic var coverImageURL: String?
  @objc dynamic var artist: Artist?
  let musics = LinkingObjects(fromType: Music.self, property: "album")
  
  override class func primaryKey() -> String? {
    return "id"
  }
}
