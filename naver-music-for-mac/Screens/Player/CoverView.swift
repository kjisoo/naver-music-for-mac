//
//  CoverView.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 23..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class CoverView: NSView {
  let coverImageView: NSImageView = {
    let imageView = NSImageView()
    imageView.imageScaling = .scaleProportionallyUpOrDown
    imageView.wantsLayer = true
    imageView.layer?.cornerRadius = 16
    return imageView
  }()
  
  let musicNameField: NSTextField = {
    let textField = NSTextField()
    textField.alignment = .center
    textField.isEditable = false
    textField.isBordered = false
    textField.font = NSFont.systemFont(ofSize: 16)
    textField.textColor = .darkGray
    return textField
  }()
  
  let albumNameField: NSTextField = {
    let textField = NSTextField()
    textField.alignment = .center
    textField.isEditable = false
    textField.isBordered = false
    return textField
  }()
  
  let artistNameField: NSTextField = {
    let textField = NSTextField()
    textField.alignment = .center
    textField.isEditable = false
    textField.isBordered = false
    textField.font = NSFont.systemFont(ofSize: 12)
    textField.textColor = .gray
    return textField
  }()
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.setupConstraint()
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraint() {
    self.addSubview(coverImageView)
    self.addSubview(musicNameField)
    self.addSubview(albumNameField)
    self.addSubview(artistNameField)
    
    self.coverImageView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(64)
      make.left.equalToSuperview().offset(32)
      make.right.equalToSuperview().offset(-32)
      make.width.equalTo(self.coverImageView.snp.height).multipliedBy(1)
    }
    
    self.musicNameField.snp.makeConstraints { (make) in
      make.top.equalTo(self.coverImageView.snp.bottom).offset(20)
      make.left.right.equalTo(self.coverImageView)
    }
    
    self.artistNameField.snp.makeConstraints { (make) in
      make.top.equalTo(self.musicNameField.snp.bottom).offset(8)
      make.left.right.equalTo(self.coverImageView)
    }
  }
}
