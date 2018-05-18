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
  lazy var contentTabViewController: NSTabViewController = {
    let tabViewController = NSTabViewController()
    tabViewController.tabStyle = .unspecified
    tabViewController.addTabViewItem(NSTabViewItem(viewController: PlayerController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: TOPViewController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: NSViewController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: SettingViewController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: SignViewController()))
    return tabViewController
  }()
  
  
  // MARK: Life cycle
  override func windowDidLoad() {
    super.windowDidLoad()
    self.window?.titleVisibility = .hidden
    self.window?.backgroundColor = .white
    self.setupSplitView()
    self.setupPlayer()
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
    
    let contentSplitViewItem = NSSplitViewItem(viewController: contentTabViewController)
    contentSplitViewItem.minimumThickness = 400
    splitViewController.addSplitViewItem(contentSplitViewItem)
    
    let frameSize = window.contentRect(forFrameRect: window.frame).size
    splitViewController.view.setFrameSize(frameSize)
    window.contentViewController = splitViewController
  }
  
  private func setupPlayer() {
    self.window?.contentView?.addSubview(PlayerService.shared().webPlayer)
  }

  @IBAction func settting(sender: NSButton) {
    self.contentTabViewController.selectedTabViewItemIndex = 3
  }
  
  @IBAction func sign(sender: NSButton) {
    self.contentTabViewController.selectedTabViewItemIndex = 4
  }
  
  @objc public func selected(index: Any) {
    if let index = index as? Int {
      self.contentTabViewController.selectedTabViewItemIndex = index
    }
  }
}


extension WindowController: NSWindowDelegate {
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    NSApp.hide(nil)
    return false
  }
}

