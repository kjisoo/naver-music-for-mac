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
  
  let prevButton: NSButton = {
    let button = NSButton()
    button.title = ""
    button.setButtonType(NSButton.ButtonType.momentaryChange)
    button.isBordered = false
    button.imageScaling = .scaleProportionallyUpOrDown
    button.image = NSImage(named: NSImage.Name(rawValue: "cover_prev"))?.tint(color: .lightGray)
    return button
  }()
  
  let playButton: NSButton = {
    let button = NSButton()
    button.title = ""
    button.setButtonType(NSButton.ButtonType.momentaryChange)
    button.isBordered = false
    button.imageScaling = .scaleProportionallyUpOrDown
    button.image = NSImage(named: NSImage.Name(rawValue: "cover_play"))?.tint(color: .lightGray)
    return button
  }()
  
  let nextButton: NSButton = {
    let button = NSButton()
    button.title = ""
    button.setButtonType(NSButton.ButtonType.momentaryChange)
    button.isBordered = false
    button.imageScaling = .scaleProportionallyUpOrDown
    button.image = NSImage(named: NSImage.Name(rawValue: "cover_next"))?.tint(color: .lightGray)
    return button
  }()
  
  let lyricsView: NSTextView = {
    let textView = NSTextView()
    textView.isEditable = false
    textView.isSelectable = false
    textView.alignment = .center
    textView.textColor = .darkGray
    textView.isVerticallyResizable = true
    textView.isHorizontallyResizable = true
    return textView
  }()
  
  let volumeSlider: NSSlider = {
    let slider = NSSlider()
    slider.isVertical = false
    slider.minValue = 0
    slider.maxValue = 10
    slider.intValue = 5
    return slider
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
    self.addSubview(prevButton)
    self.addSubview(playButton)
    self.addSubview(nextButton)
    self.addSubview(volumeSlider)
    
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
    
    playButton.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.artistNameField.snp.bottom).offset(32)
      make.width.height.equalTo(50)
    }
    
    prevButton.snp.makeConstraints { (make) in
      make.trailing.equalTo(self.playButton.snp.leading).offset(-16)
      make.centerY.equalTo(self.playButton)
      make.width.height.equalTo(40)
    }
    
    nextButton.snp.makeConstraints { (make) in
      make.leading.equalTo(self.playButton.snp.trailing).offset(16)
      make.centerY.equalTo(self.playButton)
      make.width.height.equalTo(40)
    }
    
    volumeSlider.snp.makeConstraints { (make) in
      make.leading.trailing.equalTo(coverImageView)
      make.top.equalTo(playButton.snp.bottom)
      make.height.equalTo(20)
    }
    
    let scrollView = NSScrollView()
    scrollView.contentView.documentView = lyricsView
    self.addSubview(scrollView)
    scrollView.snp.makeConstraints { (make) in
      make.leading.trailing.equalTo(self.coverImageView)
      make.bottom.equalToSuperview().offset(-16)
      make.top.equalTo(volumeSlider.snp.bottom).offset(16)
    }
  }
  
  public func setPaused(isPuased: Bool) {
    if isPuased {
      self.playButton.image = NSImage(named: NSImage.Name(rawValue: "cover_play"))?.tint(color: .lightGray)
    } else {
      self.playButton.image = NSImage(named: NSImage.Name(rawValue: "cover_pause"))?.tint(color: .lightGray)
    }
  }
}
