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
  // Variable
  private let authService = AuthService.shared() // TODO: DI
  
  // Outputs
  public var menuList: Observable<[String]>!
  public var signState: Observable<Bool>!
  
  init() {
    self.binding()
  }
  
  private func binding() {
    self.signState = authService.changedAuthorizedState.asObservable()
    self.menuList = self.signState.map {
      if $0 {
        return ["Player", "TOP100", "My list"]
      } else {
        return ["Player", "TOP100"]
      }
    }
  }
}
