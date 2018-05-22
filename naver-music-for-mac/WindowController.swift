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
  
  let statusBarItems: [NSStatusItem] = {
    let nextItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let playItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let prevItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    nextItem.action = #selector(WindowController.next(sender:))
    nextItem.image = NSImage(named: NSImage.Name("next"))
    
    playItem.action = #selector(WindowController.palyOrPause(sender:))
    playItem.image = NSImage(named: NSImage.Name("play"))
    
    prevItem.action = #selector(WindowController.prev(sender:))
    prevItem.image = NSImage(named: NSImage.Name("prev"))
    return [nextItem, playItem, prevItem]
  }()
  
  // MARK: Variables
  lazy var sideMenuViewController: SideMenuViewController = {
    return SideMenuViewController()
  }()
  lazy var contentTabViewController: NSTabViewController = {
    let tabViewController = NSTabViewController()
    tabViewController.tabStyle = .unspecified
    tabViewController.view.translatesAutoresizingMaskIntoConstraints = true
    tabViewController.addTabViewItem(NSTabViewItem(viewController: PlayerController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: TOPViewController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: MusicListViewController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: SettingViewController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: SignViewController()))
    return tabViewController
  }()
  
  
  // MARK: Life cycle
  override func windowDidLoad() {
    super.windowDidLoad()
    self.window?.titleVisibility = .hidden
    self.window?.backgroundColor = .white
    self.window?.titlebarAppearsTransparent = true
    self.window?.isMovableByWindowBackground = true
    self.window?.backgroundColor = .clear
    self.window?.isOpaque = false
    self.setupSplitView()
    self.setupPlayer()
    self.setupAuthorizedState()
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
    _ = PlayerService.shared().isPaused
      .map { $0 ? NSImage(named: NSImage.Name("play")) : NSImage(named: NSImage.Name("pause")) }
      .subscribe(onNext: { self.statusBarItems[1].image = $0 })
  }

  private func setupAuthorizedState() {
    _ = AuthService.shared().changedAuthorizedState.subscribe(onNext: {
      if $0, self.contentTabViewController.selectedTabViewItemIndex == 4 {
        self.contentTabViewController.selectedTabViewItemIndex = 1
      } else if $0 == false, self.contentTabViewController.selectedTabViewItemIndex == 2 {
        self.contentTabViewController.selectedTabViewItemIndex = 4
      }
    })
  }
  
  // IBActions
  @IBAction func settting(sender: NSButton) {
    self.contentTabViewController.selectedTabViewItemIndex = 3
  }
  
  @IBAction func sign(sender: NSButton) {
    if try! AuthService.shared().changedAuthorizedState.value() == true {
      AuthService.shared().signout()
    } else {
      self.contentTabViewController.selectedTabViewItemIndex = 4
    }
  }
  
  @objc public func selected(index: Any) {
    if let index = index as? Int {
      self.contentTabViewController.selectedTabViewItemIndex = index
    }
  }
  
  // MARK: IBActions
  @IBAction func prev(sender: NSButton) {
    PlayerService.shared().prev()
  }
  
  @IBAction func next(sender: NSButton) {
    PlayerService.shared().next()
  }
  
  @IBAction func palyOrPause(sender: NSButton) {
    PlayerService.shared().togglePlay()
  }
}


extension WindowController: NSWindowDelegate {
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    NSApp.hide(nil)
    return false
  }
}

