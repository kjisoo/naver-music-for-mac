//
//  TOPViewModel.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 15..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class TOPViewModel {
  // MARK: Varibales
  private let musicBrowser: MusicBrowser
  private let disposeBag = DisposeBag()
  private let musicList = BehaviorSubject<[Music]>(value: [])
  
  // MARK: Input
  public let topType = PublishSubject<TOPType>()
  
  // MARK: Output
  private(set) public var musicDatasource = BehaviorSubject<[MusicCellViewModel]>(value: [])
  private(set) public var isExistingSelectedCell: Observable<Bool>!
  
  init(musicBrowser: MusicBrowser) {
    self.musicBrowser = musicBrowser

    self.musicList.map({ $0.enumerated().map { MusicCellViewModel(music: $0.element) }}).subscribe(onNext: { [weak self] in
      self?.musicDatasource.onNext($0)
    }).disposed(by: self.disposeBag)
    
    self.topType.subscribe(onNext: { [weak self] type in
      if let `self` = self {
        self.musicBrowser.fetchTOPMusics(top: type)
          .subscribe(onSuccess: { [weak self] in
            self?.musicList.onNext($0)
          }).disposed(by: self.disposeBag)
      }
    }).disposed(by: self.disposeBag)
    
    self.isExistingSelectedCell = self.musicDatasource
      .flatMapLatest({ Observable.combineLatest(Observable.just($0), Observable.merge($0.map({$0.isChecked}))) })
      .map { (viewModels, _) -> Bool in
        let index = viewModels.index(where: { try! $0.isChecked.value() == true })
        return index != nil
    }
  }
  
  // MARK: Actions
  public func selectAll() {
    if let cellViewModels = try? self.musicDatasource.value() {
      cellViewModels.forEach { $0.isChecked.onNext(true) }
    }
  }
  
  public func deselectAll() {
    if let cellViewModels = try? self.musicDatasource.value() {
      cellViewModels.forEach { $0.isChecked.onNext(false) }
    }
  }
  
  public func addSelectedMusicToPlaylist() {
    if let cellViewModels = try? self.musicDatasource.value() {
      self.addMusicToList(indexs: cellViewModels.enumerated().filter({ try! $1.isChecked.value() }).map({ $0.offset }))
      self.deselectAll()
    }
  }
  
  public func addMusicToList(indexs: [Int]) {
    Playlist.getMyPlayList().appendMusic(musics: indexs.map { try! self.musicList.value()[$0] })
  }
}
