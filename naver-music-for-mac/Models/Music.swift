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
  @objc dynamic var trackID: String?
  @objc dynamic var title: String?
  @objc dynamic var lyrics: String?
  @objc dynamic var cover: String?
}
