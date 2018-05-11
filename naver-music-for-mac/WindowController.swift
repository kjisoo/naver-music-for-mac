//
//  WindowController.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
  override var windowNibName: NSNib.Name? {
    return NSNib.Name("WindowController")
  }
}

extension WindowController: NSWindowDelegate {
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    NSApp.hide(nil)
    return false
  }
}
