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
  private let player: PlayerService
  
  private(set) public var playListCellViewModels = BehaviorSubject<[PlayListCellViewModel]>(value: [])
  
  init(player: PlayerService = PlayerService.shared()) {
    self.player = player
    self.binding()
  }
  
  private func binding() {
    self.player.playMusicStateList.subscribe(onNext: { [weak self] in
      self?.playListCellViewModels.onNext($0.map({PlayListCellViewModel(musicState: $0)}))
    }).disposed(by: self.disposeBag)
  }
  
  public func play(index: Int) {
    self.player.play(index: index)
  }
  
  public func selectAll() {
    if let cellViewModels = try? self.playListCellViewModels.value() {
      cellViewModels.forEach { $0.checked(checked: true) }
    }
  }
  
  public func deselectAll() {
    if let cellViewModels = try? self.playListCellViewModels.value() {
      cellViewModels.forEach { $0.checked(checked: false) }
    }
  }
  
  public func deleteSelectedList() {
    if let cellViewModels = try? self.playListCellViewModels.value() {
      Repository<Playlist>.factory().remove(at: cellViewModels.enumerated().filter({ $1.isChecked }).map({ $0.offset }))
    }
  }
}

