//
//  SettingViewController.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 18..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class SettingViewController: BaseViewController {
  init() {
    super.init(nibName: nil, bundle: nil)
    self.title = "Setting"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
