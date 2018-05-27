//
//  TOPParser.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 13..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import Kanna


protocol ParserType {
  func parse(from htmlString: String) -> [Any]
}

extension ParserType {
  func getQueryStringParameter(url: String, param: String) -> String? {
    guard let url = URLComponents(string: url) else { return nil }
    return url.queryItems?.first(where: { $0.name == param })?.value
  }
  
  func slice(string: String, from: String, to: String) -> String? {
    return (string.range(of: from)?.upperBound).flatMap { substringFrom in
      (string.range(of: to, range: substringFrom..<string.endIndex)?.lowerBound).map { substringTo in
        String(string[substringFrom..<substringTo])
      }
    }
  }
}

class TOPParser: ParserType {

  func parse(from htmlString: String) -> [Any] {
    guard let doc = try? HTML(html: htmlString, encoding: .utf8) else {
      return []
    }
    var musics: [[String: Any]] = []
    for li in doc.css("tr._tracklist_move") {
      if let _ = li.css("td.ranking").first?.text {
        var music: [String: Any] = [:]
        
        for a in li.css("a") {
          if let href = a["href"] {
            if href.contains("albumId"),
              let id = getQueryStringParameter(url: href, param: "albumId"),
              let name = a.css("img").first?["title"] {
              music["album"] = ["id": id, "name": name]
            }
            
            if href.contains("artistId"),
              let id = getQueryStringParameter(url: href, param: "artistId"),
              let name = a["title"] {
              music["artist"] = ["id": id, "name": name]
            }
            
            if (a.className ?? "").contains("title"),
              let name = a["title"] {
              music["id"] = String(href.dropFirst())
              music["name"] = name
            }
          }
        }
        musics.append(music)
      }
    }
    return musics
  }
}
