//
//  MyListParser.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 21..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import Kanna

class MyListParser: ParserType {
  func parse(from htmlString: String) -> [Any] {
    guard let doc = try? HTML(html: htmlString, encoding: .utf8) else {
      return []
    }
    
    var myList:[[String: Any]] = []
    
    if let ul = doc.css("ul#addList").first {
      for li in ul.css("li") {
        var list: [String: Any] = [:]
        if let title = li.css(".tit").first?.text {
          list["name"] = title
        }
        if let subTitle = li.css(".stit").first?.text {
          print(subTitle)
        }
        if let href = li.css("a.inner").first?["onclick"],
          let id = slice(string: href, from: "albumId=", to: "'") {
          list["id"] = id
        }
        myList.append(list)
      }
    }
    return myList
  }
}
