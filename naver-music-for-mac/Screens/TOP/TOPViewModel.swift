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
  private let playListRepository: Repository<Playlist>
  private let disposeBag = DisposeBag()
  private let musicList = BehaviorSubject<[Music]>(value: [])
  
  // MARK: Input
  public let topType = PublishSubject<TOPType>()
  
  // MARK: Output
  private(set) public var musicDatasource: Observable<[TOPCellViewModel]>!
  
  init(musicBrowser: MusicBrowser, playListRepository: Repository<Playlist>) {
    self.musicBrowser = musicBrowser
    self.playListRepository = playListRepository

    self.musicDatasource = self.musicList.map({ $0.enumerated().map { TOPCellViewModel(music: $0.element, rank: $0.offset + 1) }})
    
    self.topType.subscribe(onNext: { [weak self] type in
      if let `self` = self {
        self.musicBrowser.fetchTOPMusics(top: type)
          .subscribe(onSuccess: { [weak self] in
            self?.musicList.onNext($0)
          }).disposed(by: self.disposeBag)
      }
    }).disposed(by: self.disposeBag)
  }
  
  // MARK: Actions
  public func addMusicToList(indexs: [Int]) {
    self.playListRepository.appendMusic(musics: indexs.map { try! self.musicList.value()[$0] })
  }
}
