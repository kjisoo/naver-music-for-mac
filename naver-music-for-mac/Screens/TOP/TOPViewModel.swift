//
//  TOPViewModel.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 15..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm

class TOPViewModel {
  // MARK: Varibales
  private let musicBrowser: MusicBrowser
  private let disposeBag = DisposeBag()
  private let myPlayList = Playlist.get(type: .my)
  private var playList: Playlist?
  
  // MARK: Input
  public let topType = PublishSubject<PlayListType>()
  
  // MARK: Output
  private(set) public var musicDatasource: Observable<[TOPCellViewModel]>!
  
  init(musicBrowser: MusicBrowser) {
    self.musicBrowser = musicBrowser
    
    self.musicDatasource = self.topType.flatMapLatest { (type) -> Observable<Playlist> in
      return Observable.from(object: Playlist.get(type: type))
    }.do(onNext: {[weak self] in self?.playList = $0})
    .map{ $0.musicStates.enumerated().map { TOPCellViewModel(music: $1.music!, rank: $0+1) } }

    
    self.topType.subscribe(onNext: { [weak self] type in
      if let `self` = self {
        self.musicBrowser.updateTOPPlayList(top: type)
          .subscribe(onSuccess: nil, onError: { (error) in
            print(error)
          }).disposed(by: self.disposeBag)
      }
    }).disposed(by: self.disposeBag)
  }
  
  public func addMusicToList(indexs: [Int]) {
    self.myPlayList.append(musics: indexs.map{ self.playList!.musicStates[$0] })
  }
}
