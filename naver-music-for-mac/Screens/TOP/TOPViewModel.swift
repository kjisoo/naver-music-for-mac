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
import RealmSwift
import RxRealmDataSources

class TOPViewModel {
  // MARK: Varibales
  private let musicBrowser: MusicBrowser
  private let disposeBag = DisposeBag()
  private let realm: Realm
  private var playList: Playlist?
  
  // MARK: Input
  public let topType = PublishSubject<TOPType>()
  
  // MARK: Output
  private(set) public var musicDatasource: Observable<[TOPCellViewModel]>!
  
  init(musicBrowser: MusicBrowser) {
    self.musicBrowser = musicBrowser
    self.realm = try! Realm()
    
    self.musicDatasource = self.topType.flatMapLatest { [weak self] (type) -> Observable<Playlist> in
      guard let `self` = self else {
        return Observable.never()
      }
      return Observable.from(object: self.musicBrowser.getPlayList(type: type))
    }.do(onNext: {[weak self] in self?.playList = $0})
    .map{ $0.musics.enumerated().map { TOPCellViewModel(music: $1, rank: $0+1) } }

    
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
    let myList = Playlist.createIfNil(name: "MY", realm: self.realm)
    self.realm.beginWrite()
    for index in indexs {
      myList.musics.append(self.playList!.musics[index])
    }
    try? self.realm.commitWrite()
  }
}
