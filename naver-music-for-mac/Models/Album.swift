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
  let artist = LinkingObjects(fromType: Artist.self, property: "albums")
}
