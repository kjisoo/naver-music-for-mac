//
//  SideMenuViewModel.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 18..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift

class SideMenuViewModel {
  // Outputs
  public var menuList: Observable<[String]>!
  public var signState: Observable<Bool>!
  
  init() {
    self.binding()
  }
  
  private func binding() {
    self.menuList = Observable.just(["A", "B", "C"])
    self.signState = Observable.just(false)
  }
}
