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
  
  // MARK: Output
  private(set) public var musicDatasource: Observable<[MusicCellViewModel]>!
  private(set) public var title: Observable<String> = BehaviorSubject<String>(value: "")

  
  public func changeTitle(title: String) {
    if let titleSubject = self.title as? BehaviorSubject<String> {
      titleSubject.onNext(title)
    }
  }
}
