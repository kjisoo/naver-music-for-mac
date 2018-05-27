//
//  MusicListParser.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 21..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import Kanna

class MusicListParser: ParserType {
  func parse(from htmlString: String) -> [Any] {
    guard let doc = try? HTML(html: htmlString, encoding: .utf8) else {
      return []
    }
    
    var musicList:[[String: Any]] = []
    
    if let ul = doc.css("ul#addList").first {
      for li in ul.css("li") {
        var list: [String: Any] = [:]
        var album: [String: Any] = [:]
        if let title = li.css(".tit").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
          list["name"] = title
        }
        if let href = li.css("a.btn_play").first?["onclick"],
          let id = slice(string: href, from: "playByTrackId(", to: ")") {
          list["id"] = id
        }
        if let href = li.css("a.img").first?["onclick"],
          let albumId = slice(string: href, from: "goAlbum(", to: ")") {
          album["id"] = albumId
        }
        if let subTitle = li.css("span.stit").first?.text,
          let albumName = subTitle.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false).last {
          album["name"] = albumName
        }
        if album.keys.count > 0 {
          list["album"] = album
        }
        musicList.append(list)
      }
    }
    return musicList
  }
}
