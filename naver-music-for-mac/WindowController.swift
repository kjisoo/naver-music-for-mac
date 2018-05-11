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
  
  
  // MARK: Variables
  lazy var sideMenuViewController: SideMenuViewController = {
    return SideMenuViewController()
  }()
  
  
  // MARK: Life cycle
  override func windowDidLoad() {
    super.windowDidLoad()
    self.window?.titleVisibility = .hidden
    self.window?.backgroundColor = .white
    self.setupSplitView()
  }
  
  // MARK: Private Methods
  private func setupSplitView() {
    guard let window = self.window else {
      return
    }
    let splitViewController = SplitViewController()
    
    let sideMenuSplitViewItem = NSSplitViewItem(contentListWithViewController: self.sideMenuViewController)
    sideMenuSplitViewItem.minimumThickness = 200
    sideMenuSplitViewItem.maximumThickness = 200
    splitViewController.addSplitViewItem(sideMenuSplitViewItem)
    
    let contentSplitViewItem = NSSplitViewItem(viewController: PlayerController())
    contentSplitViewItem.minimumThickness = 400
    splitViewController.addSplitViewItem(contentSplitViewItem)
    
    let frameSize = window.contentRect(forFrameRect: window.frame).size
    splitViewController.view.setFrameSize(frameSize)
    window.contentViewController = splitViewController
  }
}


extension WindowController: NSWindowDelegate {
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    NSApp.hide(nil)
    return false
  }
}

