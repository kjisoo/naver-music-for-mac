//
//  TimeSliderBar.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 6. 1..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import SnapKit

class TimeSliderBar: NSControl {
  private let currentTimelabel: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.backgroundColor = .clear
    textField.textColor = .systemGray
    textField.alignment = .right
    textField.stringValue = "0:00"
    textField.font = NSFont.systemFont(ofSize: 10)
    return textField
  }()
  private let maxTimelabel: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.backgroundColor = .clear
    textField.textColor = .systemGray
    textField.alignment = .left
    textField.stringValue = "0:00"
    textField.font = NSFont.systemFont(ofSize: 10)
    return textField
  }()
  private let slider: NSSlider = {
    let slider = NSSlider()
    slider.cell = SliderCell()
    slider.cell?.controlSize = .mini
    slider.identifier = NSUserInterfaceItemIdentifier(rawValue: "playBar")
    return slider
  }()
  
  override public var isEnabled: Bool {
    get {
      return self.slider.isEnabled
    }
    set {
      self.slider.isEnabled = newValue
      if newValue == false {
        self.currentTimelabel.stringValue = "0:00"
        self.maxTimelabel.stringValue = "0:00"
      }
    }
  }
  
  override var action: Selector? {
    didSet {
      self.slider.action = self.action
    }
  }
  
  override var target: AnyObject? {
    didSet {
      self.slider.target = self.target
    }
  }
  

  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.setupConstraint()
  }
  
  required init?(coder decoder: NSCoder) {
    super.init(coder: decoder)
    self.setupConstraint()
  }
  
  private func setupConstraint() {
    self.addSubview(currentTimelabel)
    self.addSubview(maxTimelabel)
    self.addSubview(slider)
    currentTimelabel.snp.makeConstraints { (make) in
      make.top.leading.bottom.equalToSuperview()
      make.width.equalTo(40)
    }
    maxTimelabel.snp.makeConstraints { (make) in
      make.top.trailing.bottom.equalToSuperview()
      make.width.equalTo(40)
    }
    slider.snp.makeConstraints { (make) in
      make.top.bottom.equalToSuperview()
      make.leading.equalTo(currentTimelabel.snp.trailing).offset(2)
      make.trailing.equalTo(maxTimelabel.snp.leading).offset(-2)
    }
    self.isEnabled = false
  }
  
  public func setTime(current: Int, max: Int) {
    guard max > 0 else {
      self.isEnabled = false
      return
    }
    self.isEnabled = true
    self.currentTimelabel.stringValue = String(format: "%01d:%02d",
                                               current / 60, current % 60)
    self.maxTimelabel.stringValue = String(format: "%01d:%02d",
                                           max / 60, max % 60)
    self.slider.maxValue = Double(max)
    self.slider.integerValue = current
  }
}
