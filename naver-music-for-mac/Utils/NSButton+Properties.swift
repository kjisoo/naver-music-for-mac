//
//  NSButton+Properties.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 6. 1..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

extension NSButton {
  var isSelected: Bool {
    get {
      return state == .on
    }
    set {
      state = newValue ? .on : .off
    }
  }
}
