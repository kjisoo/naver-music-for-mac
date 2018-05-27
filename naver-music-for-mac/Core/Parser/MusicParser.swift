//
//  MusicParser.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 28..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import Kanna

class MusicParser: ParserType {
  private func slice(string: String, from: String, to: String) -> String? {
    return (string.range(of: from)?.upperBound).flatMap { substringFrom in
      (string.range(of: to, range: substringFrom..<string.endIndex)?.lowerBound).map { substringTo in
        String(string[substringFrom..<substringTo])
      }
    }
  }
  
  func parse(from htmlString: String) -> [Any] {
    guard let doc = try? HTML(html: htmlString, encoding: .utf8) else {
      return []
    }
    
    var music: [String: Any] = [:]
    
    if let id = doc.css("span.ico_play").first?.css("a").first?["href"]?.dropFirst() {
      music["id"] = id
    }
    
    if let name = doc.css("span.ico_play").first?.css("a").first?.text {
      music["name"] = name
    }
    
    if let artist = doc.css("span.artist").first?.css("a").first,
      let artistName = artist["title"],
      let href = artist["href"],
      let artistID = getQueryStringParameter(url: href, param: "artistId") {
      music["artist"] = ["name": artistName, "id": artistID]
    }
    
    if let albumName = doc.css("span.album").first?.text,
      let href = doc.css("a.btn_album_info").first?["href"],
      let albumID = getQueryStringParameter(url: href, param: "albumId"){
      music["album"] = ["name": albumName, "id": albumID]
    }
    
    if let lyrics = doc.css("div.show_lyrics").first?.innerHTML?.replacingOccurrences(of: "<br>", with: "\n") {
      music["lyrics"] = lyrics
    }
    
    if let _ = music["id"] {
      return [music]
    }
    return []
  }
}
