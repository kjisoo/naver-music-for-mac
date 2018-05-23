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
  
  public func replace(menuItems: [MenuItem]) {
    self.menuItems.onNext(menuItems)
  }
  
  public func execute(at row: Int) {
    try? self.menuItems.value()[row].command?()
  }
}
