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
  private var playList: Playlist!
  private var cellViewModels: [PlayListCellViewModel] = []
  
  private(set) public var playListViewModels: Observable<[PlayListCellViewModel]>!
  
  init() {
    self.binding()
  }
  
  private func binding() {
    let realm = try! Realm()
    self.playList = Playlist.createIfNil(name: "MY", realm: realm)
    
    self.playListViewModels = Observable.from(object: self.playList)
      .map { $0.musics.map{ PlayListCellViewModel(music: $0) } }
      .do(onNext: { [weak self] in self?.cellViewModels = $0 })
  }
  
  public func play(index: Int) {
    print(#file, #function, #line)
  }
  
  public func selectAll() {
    self.cellViewModels.forEach { $0.checked(checked: true) }
  }
  
  public func deselectAll() {
    self.cellViewModels.forEach { $0.checked(checked: false) }
  }
  
  public func deleteSelectedList() {
    print(#file, #function, #line)
  }
}

