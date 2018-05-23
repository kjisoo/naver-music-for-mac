//
//  PlayListCellView.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 15..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift
import Kingfisher


class PlayListCellView: NSView {
  private var coverImage: NSImageView = {
    let imageView = NSImageView()
    imageView.imageScaling = .scaleProportionallyUpOrDown
    imageView.wantsLayer = true
    imageView.layer?.masksToBounds = true
    imageView.layer?.cornerRadius = 4
    return imageView
  }()
  private var musicName: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.backgroundColor = .clear
    textField.font = .systemFont(ofSize: 12, weight: .semibold)
    textField.textColor = .lightGray
    return textField
  }()
  private var albumName: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.backgroundColor = .clear
    textField.font = .systemFont(ofSize: 12, weight: .semibold)
    textField.textColor = .lightGray
    return textField
  }()
  private var artistName: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.backgroundColor = .clear
    textField.font = .systemFont(ofSize: 12, weight: .semibold)
    textField.textColor = .lightGray
    return textField
  }()
  private var shadowView: NSView =  {
    let view = NSView()
    view.wantsLayer = true
    view.shadow = NSShadow()
    view.layer?.backgroundColor = NSColor.white.cgColor
    view.layer?.shadowRadius = 5
    view.layer?.shadowOpacity = 0.1
    view.layer?.shadowRadius = 4
    view.layer?.cornerRadius = 4
    view.layer?.masksToBounds = false
    view.layer?.shadowColor = NSColor.gray.cgColor
    return view
  }()
  private lazy var selectedButton: NSButton = {
    let button = NSButton()
    button.title = ""
    button.setButtonType(NSButton.ButtonType.momentaryChange)
    button.isBordered = false
    button.imageScaling = .scaleProportionallyUpOrDown
    button.target = self
    button.action = #selector(PlayListCellView.stateChange(sender:))
    button.image = NSImage(named: NSImage.Name(rawValue: "circle"))?.tint(color: .lightGray)
    return button
  }()
  private var disposeBag = DisposeBag()
  public var viewModel: PlayListCellViewModel? {
    didSet {
      self.disposeBag = DisposeBag()
      
      self.viewModel?.name.subscribe(onNext: { [weak self] in
        self?.musicName.stringValue = $0
      }).disposed(by: self.disposeBag)

      self.viewModel?.albumName.subscribe(onNext: { [weak self] in
        self?.albumName.stringValue = $0 ?? ""
      }).disposed(by: self.disposeBag)
      
      self.viewModel?.artistName.subscribe(onNext: { [weak self] in
        self?.artistName.stringValue = $0 ?? ""
      }).disposed(by: self.disposeBag)
      
      self.viewModel?.albumImage.subscribe(onNext: { [weak self] in
        self?.coverImage.kf.setImage(with: $0)
      }).disposed(by: self.disposeBag)
      
      self.viewModel?.isPlaying.subscribe(onNext: { [weak self] in
        if $0 {
          self?.musicName.textColor = .violet
          self?.albumName.textColor = .violet
          self?.artistName.textColor = .violet
          self?.shadowView.isHidden = false
        } else {
          self?.musicName.textColor = .lightGray
          self?.albumName.textColor = .lightGray
          self?.artistName.textColor = .lightGray
          self?.shadowView.isHidden = true
        }
      }).disposed(by: self.disposeBag)
      
      self.viewModel?.isChecked.subscribe(onNext: { [weak self] in
        if $0 {
          self?.selectedButton.image = self?.selectedButton.image?.tint(color: .violet)
        } else {
          self?.selectedButton.image = self?.selectedButton.image?.tint(color: .lightGray)
        }
      }).disposed(by: self.disposeBag)
    }
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.setupConstraint()
    self.identifier = NSUserInterfaceItemIdentifier(rawValue: "PlayListCellView")
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
  }
  
  private func setupConstraint() {
    let stackView = NSStackView()
    self.addSubview(shadowView)
    self.addSubview(stackView)
    self.addSubview(coverImage)
    self.addSubview(selectedButton)
    
    coverImage.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(32)
      make.top.equalToSuperview().offset(8)
      make.bottom.equalToSuperview().offset(-8)
      make.width.equalTo(coverImage.snp.height).multipliedBy(1)
    }
    
    stackView.orientation = .horizontal
    stackView.distribution = .fillEqually
    stackView.addArrangedSubview(musicName)
    stackView.addArrangedSubview(artistName)
    stackView.snp.makeConstraints { (make) in
      make.top.bottom.equalToSuperview()
      make.trailing.equalToSuperview().offset(-8)
      make.leading.equalTo(coverImage.snp.trailing).offset(8)
    }
    
    shadowView.snp.makeConstraints { (make) in
      make.top.equalTo(coverImage).offset(-2)
      make.bottom.equalTo(coverImage).offset(2)
      make.leading.equalTo(coverImage).offset(-12)
      make.trailing.equalTo(selectedButton).offset(4)
    }
    
    selectedButton.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(coverImage)
      make.width.equalTo(selectedButton.snp.height).multipliedBy(1).priority(.required)
      make.trailing.equalToSuperview().offset(-8)
    }
  }
  
  @objc private func stateChange(sender: NSButton) {
    if let viewModel = self.viewModel {
      viewModel.isChecked.onNext(!(try! viewModel.isChecked.value()))
    }
  }
}
