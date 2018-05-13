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
  func parse(from htmlString: String) -> [(music: Music, album: Album?, artist: Artist?)]
}

class TOPParser: TOPParserType {
  func parse(from htmlString: String) -> [(music: Music, album: Album?, artist: Artist?)] {
    return []
  }
}
