//
//  BaseViewController.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 22..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift

class BaseViewController: NSViewController {
  let disposeBag = DisposeBag()
  
  override func loadView() {
    self.view = NSView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupConstraint()
    self.bindWithViewModel()
  }
  
  func setupConstraint() {}
  
  func bindWithViewModel() {}
}
