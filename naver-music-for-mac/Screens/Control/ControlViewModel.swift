//
//  ControlViewModel.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 6. 1..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation



import Foundation
import RealmSwift
import RxRealm
import RxSwift

class ControlViewModel {
  private let disposeBag = DisposeBag()
  private let playlist: Playlist
  
  // Output
  public var coverImageURLString: Observable<URL?>!
  public var musicName: Observable<String?>!
  public var lyrics: Observable<String?>!
  public var albumeName: Observable<String?>!
  public var artistName: Observable<String?>!
  public var isPaused: Observable<Bool>!
  public var volume: Observable<Int>!
  public var isShuffled: Observable<Bool>!
  public var playTime: Observable<(current: Int, playtime: Int)>!
  
  init(playlist: Playlist = Playlist.getMyPlayList()) {
    self.playlist = playlist
    self.binding()
  }
  
  private func binding() {
    self.playTime = Observable.from(object: self.playlist, properties: ["seek"]).map {
      if let playtime = $0.playingMusicState()?.music.playtime.value {
        return (current: Int($0.seek), playtime: Int(playtime))
      } else {
        return (current: 0, playtime: 0)
      }
    }
    let musicObserable = Observable.changeset(from: self.playlist.musicStates).map { _ in self.playlist.playingMusicState()?.music }
    self.coverImageURLString = musicObserable.map { $0?.album?.coverImageURL(size: .large) }
    self.musicName = musicObserable.map { $0?.name }
    self.lyrics = musicObserable.map { $0?.lyrics }
    self.albumeName = musicObserable.map { $0?.album?.name }
    self.artistName = musicObserable.map { $0?.artist?.name }
    self.isPaused = Observable.from(object: self.playlist).map { $0.isPaused }.distinctUntilChanged()
    self.volume = Observable.from(object: self.playlist).map { $0.volume }.distinctUntilChanged().map { Int($0*10) }
    self.isShuffled = Observable.from(object: self.playlist).map { $0.isShuffled }.distinctUntilChanged()
  }
  
  public func play() {
    self.playlist.setIsPaused(isPaused: !self.playlist.isPaused)
  }
  
  public func prev() {
    self.playlist.prev()
  }
  
  public func next() {
    self.playlist.next()
  }
  
  public func toggleShuffle() {
    self.playlist.setIsShuffled(isShuffled: !self.playlist.isShuffled)
  }
  
  public func update(volume: Int) {
    self.playlist.changeVolume(volume: Double(volume) / 10.0)
  }
  
  public func update(seek: Int) {
    self.playlist.update(seek: Double(seek))
  }
}
