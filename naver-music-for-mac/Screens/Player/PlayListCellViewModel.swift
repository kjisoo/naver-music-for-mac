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
  
  init(music: Music) {
    let musicObservable = Observable.from(object: music)
    self.name = musicObservable.map { $0.name! }
    self.isPlaying = musicObservable.map { $0.isPlaying }
  }
}
