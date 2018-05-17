//
//  MusicCoverViewModel.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 17..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift

class MusicCoverViewModel {
  // MARK: Variables
  private let player: PlayerService
  
  // MARK: Outputs
  public let coverImageURLString: Observable<URL?>
  
  init(player: PlayerService = PlayerService.shared()) {
    self.player = player
    self.coverImageURLString = player.playingMusic.map { $0.music.album?.coverImageURL(size: .large) }
  }
  
  public func next() {
    self.player.next()
  }
  
  public func prev() {
    self.player.prev()
  }
}
