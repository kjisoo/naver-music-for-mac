//
//  MusicCellViewModel.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 25..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift

class MusicCellViewModel {
  // MARK: Output
  public let name: String?
  public let artistName: String?
  public let albumName: String?
  public let albumImage: URL?
  public let isChecked = BehaviorSubject<Bool>(value: false)
  
  init(music: Music) {
    self.name = music.name
    self.artistName = music.artist?.name
    self.albumName = music.album?.name
    self.albumImage = music.album?.coverImageURL(size: .medium)
  }
}
