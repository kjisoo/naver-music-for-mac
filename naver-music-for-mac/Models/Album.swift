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
  enum Size {
    case small
    case medium
    case large
  }
  
  @objc dynamic var id = ""
  @objc dynamic var name: String?
  @objc dynamic var artist: Artist?
  let musics = LinkingObjects(fromType: Music.self, property: "album")
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  public func coverImageURL(size: Size) -> URL?{
    guard let numbericID = Int(id) else {
        return nil
    }
    var url = "http://musicmeta.phinf.naver.net"
    
    url += String(format: "/album/%03d/%03d/%@.jpg", numbericID / 1000000, (numbericID % 1000000) / 1000, id)
    
    switch size {
    case .small:
      url += "?type=r32Fll"
    case .medium:
      url += "?type=r104Fll"
    case .large:
      url += "?type=r204Fll"
    }
    return URL(string: url)
  }
}
