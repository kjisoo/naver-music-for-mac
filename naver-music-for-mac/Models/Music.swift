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
  @objc dynamic var id: String?
  @objc dynamic var name: String?
  @objc dynamic var lyrics: String?
  @objc dynamic var coverImageURL: String?
  let artist = LinkingObjects(fromType: Artist.self, property: "musics")
  let album = LinkingObjects(fromType: Album.self, property: "musics")
}
