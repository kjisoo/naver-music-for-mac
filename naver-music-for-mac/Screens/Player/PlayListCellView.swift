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

//class PlayListCellView: NSTableCellView {
//  // MARK: IBOutlets
//  @IBOutlet weak var name: NSTextField!
//  @IBOutlet weak var checkButton: NSButton!
//  
//  // MARK: Variables
//  private var disposeBag = DisposeBag()
//  public var viewModel: PlayListCellViewModel? {
//    didSet {
//      self.disposeBag = DisposeBag()
////      self.updateCheckBox()
//
//      self.viewModel?.name.subscribe(onNext: { [weak self] in
//        self?.name.stringValue = $0
//      }).disposed(by: self.disposeBag)
//      
//      self.viewModel?.isPlaying.subscribe(onNext: { [weak self] in
//        self?.name.textColor = $0 ? NSColor.green : NSColor.black
//      }).disposed(by: self.disposeBag)
//      
////      self.viewModel?.propertyChanged.subscribe(onNext: { [weak self] _ in
////        self?.updateCheckBox()
////      }).disposed(by: self.disposeBag)
////
////      self.checkButton.rx.controlProperty(getter: { (button) -> Void in
////        self.viewModel?.checked(checked: button.state == .on)
////      }, setter: {_,_ in }).subscribe().disposed(by: self.disposeBag)
//    }
//  }
////
////  private func updateCheckBox() {
////    if self.viewModel?.isChecked == true {
////      self.checkButton.state = .on
////    } else {
////      self.checkButton.state = .off
////    }
////  }
//}

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
    textField.font = .systemFont(ofSize: 12, weight: .semibold)
    textField.textColor = .lightGray
    return textField
  }()
  private var albumName: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.font = .systemFont(ofSize: 12, weight: .semibold)
    textField.textColor = .lightGray
    return textField
  }()
  private var artistName: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.font = .systemFont(ofSize: 12, weight: .semibold)
    textField.textColor = .lightGray
    return textField
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
          self?.musicName.textColor = .systemGray
          self?.albumName.textColor = .systemGray
          self?.artistName.textColor = .systemGray
        } else {
          self?.musicName.textColor = .lightGray
          self?.albumName.textColor = .lightGray
          self?.artistName.textColor = .lightGray
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
    print(dirtyRect.width)
  }
  
  private func setupConstraint() {
    let stackView = NSStackView()
    self.addSubview(stackView)
    self.addSubview(coverImage)
    
    coverImage.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(32)
      make.top.equalToSuperview().offset(4)
      make.bottom.equalToSuperview().offset(-4)
      make.width.equalTo(coverImage.snp.height).multipliedBy(1)
    }
    
    stackView.orientation = .horizontal
    stackView.distribution = .fillEqually
    stackView.addArrangedSubview(musicName)
    stackView.addArrangedSubview(artistName)
    stackView.snp.makeConstraints { (make) in
      make.top.bottom.trailing.equalToSuperview()
      make.leading.equalTo(coverImage.snp.trailing).offset(8)
    }
  }
}
