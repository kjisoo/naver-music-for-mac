//
//  PlayListView.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 23..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class PlayListView: NSView {
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.setupConstraint()
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraint() {
    
  }
}
