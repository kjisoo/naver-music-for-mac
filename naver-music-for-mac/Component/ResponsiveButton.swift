//
//  ResponsiveButton.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class ResponsiveButton: NSButton {
  // MARK: Variables
  private var isMouseEntered  = false {
    didSet {
      self.changeScale()
    }
  }
  override var state: NSControl.StateValue {
    didSet {
      self.changeScale()
    }
  }
  private var trackingArea: NSTrackingArea?
  
  
  override func updateTrackingAreas() {
    if let trackingArea = self.trackingArea {
      self.removeTrackingArea(trackingArea)
    }
    let area = NSTrackingArea.init(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
    self.addTrackingArea(area)
    self.trackingArea = area
  }
  
  override func mouseEntered(with event: NSEvent) {
    super.mouseEntered(with: event)
    self.isMouseEntered = true
  }
  
  override func mouseExited(with event: NSEvent) {
    super.mouseExited(with: event)
    self.isMouseEntered = false
  }
  
  // MARK: Private Methods
  private func changeScale() {
    guard let mutableAttributedTitle = self.attributedTitle.mutableCopy() as? NSMutableAttributedString,
      let font = self.font else {
        return
    }
    var fontSize: CGFloat = 28
    
    if self.isMouseEntered || self.state == .on {
      fontSize = 34
    } else {
      fontSize = 28
    }
    
    mutableAttributedTitle.addAttribute(NSAttributedStringKey.font,
                                        value: NSFont(name: font.fontName, size: fontSize) as Any,
                                        range: NSRange(location: 0,
                                                       length: mutableAttributedTitle.length))
    self.attributedTitle = mutableAttributedTitle
  }
}
