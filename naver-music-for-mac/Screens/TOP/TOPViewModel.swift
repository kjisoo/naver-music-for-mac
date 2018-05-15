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
  
  // MARK: Input
  public let topType = PublishSubject<TOPType>()
  
  // MARK: Output
  private(set) public var musicDatasource: Observable<[TOPCellViewModel]>!
  
  init(musicBrowser: MusicBrowser) {
    self.musicBrowser = musicBrowser
    let realm = try! Realm()
    
    self.musicDatasource = self.topType.flatMapLatest { (type) -> Observable<Playlist> in
      if let playList = realm.object(ofType: Playlist.self, forPrimaryKey: type.rawValue) {
        return Observable.from(object: playList)
      }
      else {
        let playList = Playlist(value: ["name": type.rawValue])
        try? realm.write {
          realm.add(playList)
        }
        return Observable.from(object: playList)
      }
    }.map{ $0.musics.enumerated().map { TOPCellViewModel(music: $1, rank: $0+1) } }
    
    self.topType.subscribe(onNext: { [weak self] type in
      if let `self` = self {
        self.musicBrowser.search(top: type).filter { $0.count > 0 }.subscribe(onSuccess: { [weak self] musics in
          if let playList = realm.object(ofType: Playlist.self, forPrimaryKey: type.rawValue) {
            try? realm.write {
              realm.add(musics, update: true)
              playList.musics.replaceSubrange(0..<playList.musics.count, with: musics)
            }
          }
        }).disposed(by: self.disposeBag)
      }
      
    }).disposed(by: self.disposeBag)
  }
}
