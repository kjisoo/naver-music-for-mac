//
//  SideMenuViewModel.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 18..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift

struct MenuItem {
  let name: String?
  let iconNmae: String?
  let isSelected: Bool
  let command: (() -> Void)?
}

class SideMenuViewModel {
  // Outputs
  public let menuItems = BehaviorSubject<[MenuItem]>(value: [])
  
  init() {
    self.binding()
  }
  
  private func binding() {
    self.menuItems.onNext([
      MenuItem(name: "MENU", iconNmae: nil, isSelected: false, command: nil),
      MenuItem(name: "TOP100", iconNmae: "play", isSelected: true, command: nil),
      MenuItem(name: "Album", iconNmae: "play", isSelected: false, command: nil),
      MenuItem(name: "Player", iconNmae: "play", isSelected: false, command: nil),
      MenuItem(name: nil, iconNmae: nil, isSelected: false, command: nil),
      MenuItem(name: "PLAYLISTS", iconNmae: nil, isSelected: false, command: nil),
      MenuItem(name: "POP", iconNmae: "play", isSelected: false, command: nil),
      MenuItem(name: "haha", iconNmae: "play", isSelected: false, command: nil)
      ])
  }
  
  public func replace(menuItems: [MenuItem]) {
    self.menuItems.onNext(menuItems)
  }
  
  public func execute(at row: Int) {
    try? self.menuItems.value()[row].command?()
  }
}
