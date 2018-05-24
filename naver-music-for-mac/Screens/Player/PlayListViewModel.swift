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
  private(set) public var isExistingSelectedCell: Observable<Bool>!
  
  init(player: PlayerService = PlayerService.shared()) {
    self.player = player
    self.binding()
  }
  
  private func binding() {
    self.player.playMusicStateList.subscribe(onNext: { [weak self] in
      self?.playListCellViewModels.onNext($0.map({PlayListCellViewModel(musicState: $0)}))
    }).disposed(by: self.disposeBag)
    
    self.isExistingSelectedCell = self.playListCellViewModels
      .flatMapLatest({ Observable.merge($0.map({$0.isChecked})) })
      .map { _ -> Bool in let index = try! self.playListCellViewModels.value().index(where: { try! $0.isChecked.value() == true })
        return index != nil
    }
  }
  
  public func play(index: Int) {
    self.player.play(index: index)
  }
  
  public func selectAll() {
    if let cellViewModels = try? self.playListCellViewModels.value() {
      cellViewModels.forEach { $0.isChecked.onNext(true) }
    }
  }
  
  public func deselectAll() {
    if let cellViewModels = try? self.playListCellViewModels.value() {
      cellViewModels.forEach { $0.isChecked.onNext(false) }
    }
  }
  
  public func deleteSelectedList() {
    if let cellViewModels = try? self.playListCellViewModels.value() {
      Repository<Playlist>.factory().remove(at: cellViewModels.enumerated().filter({ try! $1.isChecked.value() }).map({ $0.offset }))
    }
  }
}

