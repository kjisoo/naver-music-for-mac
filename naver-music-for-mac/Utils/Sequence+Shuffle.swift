//
//  Sequence+Shuffle.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 31..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation

extension MutableCollection {
  mutating func shuffle() {
    for i in indices.dropLast() {
      let diff = distance(from: i, to: endIndex)
      let j = index(i, offsetBy: numericCast(arc4random_uniform(numericCast(diff))))
      swapAt(i, j)
    }
  }
}

extension Collection {
  func shuffled() -> [Element] {
    var list = Array(self)
    list.shuffle()
    return list
  }
}
