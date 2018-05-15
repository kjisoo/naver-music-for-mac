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
  public let isChecked: Observable<Bool>
  private let checkedStream = BehaviorSubject<Bool>(value: false)
  
  init(music: Music) {
    let musicObservable = Observable.from(object: music)
    self.name = musicObservable.map { $0.name! }
    self.isPlaying = musicObservable.map { $0.isPlaying }
    self.isChecked = checkedStream.asObservable().distinctUntilChanged()
  }
  
  public func checked(checked: Bool) {
    self.checkedStream.onNext(checked)
  }
}
