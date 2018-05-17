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
  private let disposeBag = DisposeBag()
  private let playList: Playlist
  private let player: PlayerService
  private var cellViewModels: [PlayListCellViewModel] = []
  
  private(set) public var playListViewModels: Observable<[PlayListCellViewModel]>!
  
  init(player: PlayerService = PlayerService.shared()) {
    self.playList = player.playList
    self.player = player
    self.binding()
  }
  
  private func binding() {
    self.playListViewModels = Observable.from(object: self.playList)
      .map { $0.musics.map{ PlayListCellViewModel(music: $0) } }
      .do(onNext: { [weak self] in self?.cellViewModels = $0 })
    
    player.playingMusic.subscribe(onNext: { [weak self] in
      self?.cellViewModels.forEach({ $0._isPlaying = false })
      self?.cellViewModels[$0.index]._isPlaying = true
    }).disposed(by: self.disposeBag)
  }
  
  public func play(index: Int) {
    self.player.play(index: index)
  }
  
  public func selectAll() {
    self.cellViewModels.forEach { $0.checked(checked: true) }
  }
  
  public func deselectAll() {
    self.cellViewModels.forEach { $0.checked(checked: false) }
  }
  
  public func deleteSelectedList() {
    self.playList.remove(at: self.cellViewModels.enumerated().filter({ $1.isChecked }).map({ $0.offset }))
  }
}

