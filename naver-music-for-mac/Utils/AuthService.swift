//
//  AuthService.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 18..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift

class AuthService {
  static let instance = AuthService()
  private init() {
    refresh()
  }
  
  public static func shared() -> AuthService {
    return instance
  }
  
  public var changedAuthorizedState = BehaviorSubject<Bool>(value: false)
  
  public func refresh() {
    var isAuthorized = false
    if let url = URL(string: "http://naver.com"),
      let cookies = HTTPCookieStorage.shared.cookies(for: url) {
      isAuthorized = cookies.contains(where: {$0.name == "NID_AUT"})
    }
    self.changedAuthorizedState.onNext(isAuthorized)
  }
  
  public func signout() {
    for cookie in (HTTPCookieStorage.shared.cookies ?? []) {
      HTTPCookieStorage.shared.deleteCookie(cookie)
    }
    self.refresh()
  }
}
