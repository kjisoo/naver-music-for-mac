//
//  WindowController.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 8..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
  override func windowDidLoad() {
    super.windowDidLoad()
    self.window?.titlebarAppearsTransparent = true
    self.window?.titleVisibility = .hidden
    self.window?.styleMask.update(with: .fullSizeContentView) 
  }
}

extension WindowController: NSWindowDelegate {
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    NSApp.hide(nil)
    return false
  }
}
