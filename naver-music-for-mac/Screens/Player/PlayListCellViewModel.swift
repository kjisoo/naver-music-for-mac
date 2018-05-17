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
  // MARK: Variables
  public var _isPlaying = false {
    didSet {
      if oldValue != self._isPlaying {
        self.isPlaying.onNext(self._isPlaying)
      }
    }
  }
  
  // MARK: Output
  public let name: Observable<String>
  public let isPlaying = BehaviorSubject<Bool>(value: false)
  public var isChecked = false
  public var propertyChanged: Observable<Void> {
    return _propertyChanged.asObservable()
  }
  private let _propertyChanged = PublishSubject<Void>()
  
  init(music: Music) {
    let musicObservable = Observable.from(object: music)
    self.name = musicObservable.map { $0.name! }
  }
  
  public func checked(checked: Bool) {
    self.isChecked = checked
    self._propertyChanged.onNext(Void())
  }
}
