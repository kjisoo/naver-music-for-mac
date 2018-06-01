//
//  ControlViewModel.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 6. 1..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation



import Foundation
import RealmSwift
import RxRealm
import RxSwift

class ControlViewModel {
  private let disposeBag = DisposeBag()
  private let playlist: Playlist
  
  // Output
  private(set) public var playListCellViewModels = BehaviorSubject<[PlayListCellViewModel]>(value: [])
  public var coverImageURLString: Observable<URL?>!
  public var musicName: Observable<String?>!
  public var lyrics: Observable<String?>!
  public var albumeName: Observable<String?>!
  public var artistName: Observable<String?>!
  public var isPaused: Observable<Bool>!
  public var volume: Observable<Int>!
  public var isShuffled: Observable<Bool>!
  
  init(playlist: Playlist = Playlist.getMyPlayList()) {
    self.playlist = playlist
    self.binding()
  }
  
  private func binding() {
    Observable.collection(from: self.playlist.musicStates).subscribe(onNext: { [weak self] in
      self?.playListCellViewModels.onNext($0.map({PlayListCellViewModel(musicState: $0)}))
    }).disposed(by: self.disposeBag)
    let musicObserable = Observable.changeset(from: self.playlist.musicStates).map { _ in self.playlist.playingMusicState()?.music }
    self.coverImageURLString = musicObserable.map { $0?.album?.coverImageURL(size: .large) }
    self.musicName = musicObserable.map { $0?.name }
    self.lyrics = musicObserable.map { $0?.lyrics }
    self.albumeName = musicObserable.map { $0?.album?.name }
    self.artistName = musicObserable.map { $0?.artist?.name }
    self.isPaused = Observable.from(object: self.playlist).map { $0.isPaused }.distinctUntilChanged()
    self.volume = Observable.from(object: self.playlist).map { $0.volume }.distinctUntilChanged().map { Int($0*10) }
    self.isShuffled = Observable.from(object: self.playlist).map { $0.isShuffled }.distinctUntilChanged()
  }
  
  public func play(index: Int) {
    if let id = try? self.playListCellViewModels.value()[index].id {
      self.playlist.play(stateID: id)
    }
  }
  
  public func play() {
    self.playlist.setIsPaused(isPaused: !self.playlist.isPaused)
  }
  
  public func prev() {
    self.playlist.prev()
  }
  
  public func next() {
    self.playlist.next()
  }
  
  public func change(volume: Int) {
    self.playlist.changeVolume(volume: Double(volume) / 10.0)
  }
  
  public func change(isShuffled: Bool) {
    self.playlist.setIsShuffled(isShuffled: isShuffled)
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
      self.playlist.remove(at: cellViewModels.enumerated().filter({ try! $1.isChecked.value() }).map({ $0.element.id }))
    }
  }
}
