//
//  MusicCell.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 25..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift

class MusicCellView: NSView {
  public var rank: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.backgroundColor = .clear
    textField.font = .systemFont(ofSize: 24, weight: .semibold)
    textField.textColor = .white
    return textField
  }()
  private var coverImage: NSImageView = {
    let imageView = NSImageView()
    imageView.imageScaling = .scaleProportionallyUpOrDown
    imageView.wantsLayer = true
    imageView.layer?.masksToBounds = true
    imageView.layer?.cornerRadius = 8
    return imageView
  }()
  private var musicName: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.backgroundColor = .clear
    textField.font = .systemFont(ofSize: 18, weight: .bold)
    textField.textColor = .darkGray
    return textField
  }()
  private var informationField: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.backgroundColor = .clear
    textField.font = .systemFont(ofSize: 12, weight: .semibold)
    textField.textColor = .lightGray
    return textField
  }()
  private var selectedDimView: NSView = {
    let view = NSView()
    view.wantsLayer = true
    view.layer?.backgroundColor = NSColor.darkGray.cgColor
    view.alphaValue = 0.3
    return view
  }()
 
  private var disposeBag = DisposeBag()
  public var viewModel: MusicCellViewModel? {
    didSet {
      self.disposeBag = DisposeBag()
      
      guard let viewModel = self.viewModel else {
        return
      }
      self.musicName.stringValue = viewModel.name ?? ""
      self.informationField.stringValue = "\(viewModel.artistName ?? "") - \(viewModel.albumName ?? "")"
      self.coverImage.kf.setImage(with: viewModel.albumImage)
      
      viewModel.isChecked.subscribe(onNext: { [weak self] in
        self?.selectedDimView.isHidden = !$0
      }).disposed(by: self.disposeBag)
    }
  }
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.setupConstraint()
    self.identifier = NSUserInterfaceItemIdentifier(rawValue: "MusicCellView")
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
  }
  
  private func setupConstraint() {
    let textStackView = NSStackView()
    self.addSubview(coverImage)
    self.addSubview(textStackView)
    self.addSubview(rank)
    self.addSubview(selectedDimView)
    textStackView.addArrangedSubview(musicName)
    textStackView.addArrangedSubview(informationField)
    
    rank.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(34)
      make.top.equalToSuperview().offset(8)
      make.bottom.equalToSuperview().offset(-8)
    }
    
    coverImage.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(32)
      make.top.equalToSuperview().offset(8)
      make.bottom.equalToSuperview().offset(-8)
      make.width.equalTo(coverImage.snp.height).multipliedBy(1)
    }
    
    textStackView.orientation = .vertical
    textStackView.distribution = .fillEqually
    textStackView.alignment = .leading
    textStackView.addArrangedSubview(musicName)
    textStackView.addArrangedSubview(informationField)
    textStackView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-8)
      make.leading.equalTo(coverImage.snp.trailing).offset(8)
    }
    selectedDimView.snp.makeConstraints { (make) in
      make.top.bottom.leading.trailing.equalToSuperview()
    }
  }
}
