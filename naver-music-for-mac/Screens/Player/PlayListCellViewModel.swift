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
  public let name: Observable<String>
  public let isPlaying: Observable<Bool>
  public var isChecked = false
  public var propertyChanged: Observable<Void> {
    return _propertyChanged.asObservable()
  }
  private let _propertyChanged = PublishSubject<Void>()
  
  init(musicState: MusicState) {
    let musicStateObservable = Observable.from(object: musicState)
    self.isPlaying = musicStateObservable.map({$0.isPlaying})
    self.name = musicStateObservable.map({$0.music!.name!})
  }
  
  public func checked(checked: Bool) {
    self.isChecked = checked
    self._propertyChanged.onNext(Void())
  }
}
