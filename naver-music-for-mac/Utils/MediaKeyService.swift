//
//  MediaKeyService.swift
//  naver-music-for-mac
//
//  Created by IISUE on 2018. 6. 17..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import MediaKeyTap

class MediaKeyService {
  static let shared = MediaKeyService()
  
  fileprivate var playlist: Playlist?
  fileprivate var mediaKeyTab: MediaKeyTap?
  
  func start(playlist: Playlist = Playlist.getMyPlayList()) {
    self.playlist = playlist
    self.mediaKeyTab = MediaKeyTap(delegate: self)
    self.mediaKeyTab?.start()
  }
}

extension MediaKeyService: MediaKeyTapDelegate {
  func handle(mediaKey: MediaKey, event: KeyEvent) {
    
    guard let playlist = self.playlist else {
      return
    }
    
    switch mediaKey {
    case .playPause:
      playlist.setIsPaused(isPaused: !playlist.isPaused)
      break
      
    case .rewind:
      playlist.prev()
      break
      
    case .fastForward:
      playlist.next()
      break
      
    default:
      break
    }
  }
}

