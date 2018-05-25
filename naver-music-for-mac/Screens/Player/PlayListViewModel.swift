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
  
  // Output
  private(set) public var playListCellViewModels = BehaviorSubject<[PlayListCellViewModel]>(value: [])
  private(set) public var isExistingSelectedCell: Observable<Bool>!
  public var coverImageURLString: Observable<URL?>!
  public var musicName: Observable<String?>!
  public var albumeName: Observable<String?>!
  public var artistName: Observable<String?>!
  public var isPaused: Observable<Bool>!
  
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
    
    self.coverImageURLString = player.playingMusicState.map { $0?.music.album?.coverImageURL(size: .large) }
    self.musicName = player.playingMusicState.map { $0?.music.name }
    self.albumeName = player.playingMusicState.map { $0?.music.album?.name }
    self.artistName = player.playingMusicState.map { $0?.music.artist?.name }
    self.isPaused = player.isPaused.asObservable().distinctUntilChanged()
  }
  
  public func play(index: Int) {
    self.player.play(index: index)
  }
  
  public func play() {
    self.player.togglePlay()
  }
  
  public func prev() {
    self.player.prev()
  }
  
  public func next() {
    self.player.next()
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
      self.player.playList.remove(at: cellViewModels.enumerated().filter({ try! $1.isChecked.value() }).map({ $0.offset }))
    }
  }
}

