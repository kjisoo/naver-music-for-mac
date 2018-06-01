//
//  NSView+BackgroundColor.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 6. 1..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

extension NSView {
  var bgColor: NSColor? {
    get {
      guard let layer = layer, let backgroundColor = layer.backgroundColor else { return nil }
      return NSColor(cgColor: backgroundColor)
    }
    
    set {
      wantsLayer = true
      layer?.backgroundColor = newValue?.cgColor
    }
  }
}
