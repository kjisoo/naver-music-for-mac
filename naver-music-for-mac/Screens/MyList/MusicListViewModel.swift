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
  private let playListRepository: Repository<Playlist>
  private let disposeBag = DisposeBag()
  private let musicList = BehaviorSubject<[Music]>(value: [])
  
  // MARK: Input
  public let musicListID = PublishSubject<String>()
  
  // MARK: Output
  private(set) public var musicDatasource: Observable<[MusicCellViewModel]>!
  private(set) public var title: Observable<String> = BehaviorSubject<String>(value: "")

  init(musicBrowser: MusicBrowser, playListRepository: Repository<Playlist>) {
    self.playListRepository = playListRepository
    musicDatasource = musicListID.flatMapLatest(musicBrowser.fetchMusicList).map{ $0.map(MusicCellViewModel.init) }
  }
  
  public func changeTitle(title: String) {
    if let titleSubject = self.title as? BehaviorSubject<String> {
      titleSubject.onNext(title)
    }
  }
}
