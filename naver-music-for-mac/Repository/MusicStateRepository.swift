//
//  MusicStateRepository.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 21..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation

extension Repository where T == MusicState {
  func changePlaying(object: T, isPlaying: Bool) {
    if object.isPlaying != isPlaying {
      try? self.realm.write {
        object.isPlaying = isPlaying
      }
    }
  }
}
