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
  public let name: Observable<String?>
  public let albumeName: Observable<String?>
  public let artistName: Observable<String?>
  
  init(player: PlayerService = PlayerService.shared()) {
    self.player = player
    self.coverImageURLString = player.playingMusicState.map { $0?.music.album?.coverImageURL(size: .large) }
    self.name = player.playingMusicState.map { $0?.music.name }
    self.albumeName = player.playingMusicState.map { $0?.music.album?.name }
    self.artistName = player.playingMusicState.map { $0?.music.artist?.name }
  }
  
  public func next() {
    self.player.next()
  }
  
  public func prev() {
    self.player.prev()
  }
}
