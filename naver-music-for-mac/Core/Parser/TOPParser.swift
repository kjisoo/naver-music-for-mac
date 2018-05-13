//
//  TOPParser.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 13..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import Kanna


protocol TOPParserType {
  associatedtype E = [(music: Music, album: Album?, artist: Artist?)]
  func parse(from htmlString: String) -> E
}

class TOPParser: TOPParserType {
  private func getQueryStringParameter(url: String, param: String) -> String? {
    guard let url = URLComponents(string: url) else { return nil }
    return url.queryItems?.first(where: { $0.name == param })?.value
  }

  func parse(from htmlString: String) -> E {
    guard let doc = try? HTML(html: htmlString, encoding: .utf8) else {
      return []
    }
    var musics: E = []
    for li in doc.css("tr._tracklist_move") {
      if let _ = li.css("td.ranking").first?.text {
        var music: Music? = nil
        var album: Album? = nil
        var artist: Artist? = nil
        
        for a in li.css("a") {
          if let href = a["href"] {
            if href.contains("albumId"),
              let id = getQueryStringParameter(url: href, param: "albumId"),
              let name = a.css("img").first?["title"] {
              album = Album()
              album?.id = id
              album?.name = name
            }
            
            if href.contains("artistId"),
              let id = getQueryStringParameter(url: href, param: "artistId"),
              let name = a["title"] {
              artist = Artist()
              artist?.id = id
              artist?.name = name
            }
            
            if (a.className ?? "").contains("title"),
              let name = a["title"] {
              music = Music()
              music?.id = String(href.dropFirst())
              music?.name = name
            }
          }
        }
        
        if let music = music {
          music.album = album
          music.artist = artist
          album?.artist = artist
          musics.append((music: music, album: album, artist: artist))
        }
      }
    }
    return musics
  }
}
