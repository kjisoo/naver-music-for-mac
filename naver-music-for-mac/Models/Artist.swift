//
//  Artist.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 12..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RealmSwift

class Artist: Object {
  @objc dynamic var id = ""
  @objc dynamic var name: String?
  let albums = LinkingObjects(fromType: Album.self, property: "artist")
  let musics = LinkingObjects(fromType: Music.self, property: "artist")
  
  override class func primaryKey() -> String? {
    return "id"
  }
}
