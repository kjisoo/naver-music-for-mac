//
//  NSStatusItemManager.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 29..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RxSwift
import Cocoa

enum StatusButtonType {
  case prev
  case next
  case playOrPause
}

class NSStatusItemManager {
  private var disposeBag = DisposeBag()
  private var nextItem: NSStatusItem?
  private var playItem: NSStatusItem?
  private var prevItem: NSStatusItem?
  
  public let selectedButtonType = PublishSubject<StatusButtonType>()
  
  init() {
    setupAllItems()
    changeImageColor()
    DistributedNotificationCenter.default().addObserver(self,
                                                        selector: #selector(NSStatusItemManager.changeImageColor),
                                                        name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"),
                                                        object: nil)
  }
  
  private func setupAllItems() {
    nextItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    playItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    prevItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    nextItem?.image = NSImage(named: NSImage.Name("next"))
    playItem?.image = NSImage(named: NSImage.Name("play"))
    prevItem?.image = NSImage(named: NSImage.Name("prev"))
    nextItem?.button?.rx.controlEvent.map { StatusButtonType.next }.bind(to: self.selectedButtonType).disposed(by: self.disposeBag)
    playItem?.button?.rx.controlEvent.map { StatusButtonType.playOrPause }.bind(to: self.selectedButtonType).disposed(by: self.disposeBag)
    prevItem?.button?.rx.controlEvent.map { StatusButtonType.prev }.bind(to: self.selectedButtonType).disposed(by: self.disposeBag)
  }
  
  public func hideAllItems() {
    self.disposeBag = DisposeBag()
    nextItem = nil
    playItem = nil
    prevItem = nil
  }
  
  public func showAllItems() {
    self.hideAllItems()
    self.setupAllItems()
  }
  
  public func currentPlayingState(isPlaying: Bool) {
    if isPlaying {
      self.playItem?.image = NSImage(named: NSImage.Name("pause"))
    } else {
      self.playItem?.image = NSImage(named: NSImage.Name("play"))
    }
    self.changeImageColor()
  }
  
  @objc private func changeImageColor() {
    var tintColor = NSColor.black
    if let _ = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") {
      tintColor = NSColor.white
    } else {
      tintColor = NSColor.black
    }
    
    for items in [self.nextItem, self.playItem, self.prevItem] {
      items?.image = items?.image?.tint(color: tintColor)
    }
  }
}
