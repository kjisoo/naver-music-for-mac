//
//  BaseViewController.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 22..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift
import SnapKit

class BaseViewController: NSViewController {
  // MARK: Variables
  let disposeBag = DisposeBag()
  override var title: String? {
    didSet {
      self.titleLabel.stringValue = self.title ?? ""
    }
  }
  
  // MARK: UI Variables
  let titleLabel: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.font = .systemFont(ofSize: 21, weight: .bold)
    textField.textColor = .darkGray
    textField.stringValue = ""
    return textField
  }()
  
  override func loadView() {
    self.view = NSView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConstraint()
    self.bindWithViewModel()
  }
  
  func setupConstraint() {
    self.view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(32)
      make.top.equalToSuperview().offset(32)
    }
  }
  
  func bindWithViewModel() {}
}
