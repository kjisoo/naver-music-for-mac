//
//  MusicListViewModel.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 25..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift

class MusicListViewModel {
  // MARK: Varibales
  private let disposeBag = DisposeBag()
  private let musicList = BehaviorSubject<[Music]>(value: [])
  
  // MARK: Input
  public let musicListID = PublishSubject<String>()
  
  // MARK: Output
  private(set) public var musicDatasource = BehaviorSubject<[MusicCellViewModel]>(value: [])
  private(set) public var isExistingSelectedCell: Observable<Bool>!
  private(set) public var title: Observable<String> = BehaviorSubject<String>(value: "")

  init(musicBrowser: MusicBrowser) {
    musicListID.flatMapLatest(musicBrowser.fetchMusicList)
      .map{ [weak self] musics -> [MusicCellViewModel] in
        self?.musicList.onNext(musics)
        return musics.map(MusicCellViewModel.init)
      } .subscribe(onNext: { [weak self] in
        self?.musicDatasource.onNext($0)
      }).disposed(by: self.disposeBag)
    
    self.isExistingSelectedCell = self.musicDatasource
      .flatMapLatest({ Observable.combineLatest(Observable.just($0), Observable.merge($0.map({$0.isChecked}))) })
      .map { (viewModels, _) -> Bool in
        let index = viewModels.index(where: { try! $0.isChecked.value() == true })
        return index != nil
    }
  }
  
  public func changeTitle(title: String) {
    if let titleSubject = self.title as? BehaviorSubject<String> {
      titleSubject.onNext(title)
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
