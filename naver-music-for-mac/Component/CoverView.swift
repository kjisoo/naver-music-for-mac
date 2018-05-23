//
//  CoverView.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 23..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class CoverView: NSView {
  let coverImageView = NSImageView()
  
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
