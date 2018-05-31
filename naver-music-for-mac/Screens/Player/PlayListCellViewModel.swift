//
//  PlayListCellViewModel.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 15..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm

class PlayListCellViewModel {
  // MARK: Output
  public let id: String
  public let name: Observable<String>
  public let isPlaying: Observable<Bool>
  public let artistName: Observable<String?>
  public let albumName: Observable<String?>
  public let albumImage: Observable<URL?>
  public let isChecked = BehaviorSubject<Bool>(value: false)
  
  init(musicState: MusicState) {
    id = musicState.id
    let musicStateObservable = Observable.from(object: musicState)
    self.isPlaying = musicStateObservable.map({$0.isPlaying})
    self.name = musicStateObservable.map({$0.music!.name!})
    self.artistName = musicStateObservable.map({$0.music?.artist?.name})
    self.albumName = musicStateObservable.map({$0.music?.album?.name})
    self.albumImage = musicStateObservable.map({$0.music?.album?.coverImageURL(size: .small)})
  }
}
