//
//  PlayListViewModel.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 15..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

class PlayListViewModel {
  private let playList: Playlist
  
  public let playListViewModels: Observable<[PlayListCellViewModel]>
  
  init() {
    let realm = try! Realm()
    self.playList = Playlist.createIfNil(name: "MY", realm: realm)
    
    self.playListViewModels = Observable.from(object: self.playList).map { $0.musics.map{ PlayListCellViewModel(music: $0) } }
  }
}

