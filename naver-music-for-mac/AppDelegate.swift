//
//  AppDelegate.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 7..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RealmSwift
import Moya

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  var window: WindowController?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.window = WindowController()
    window?.showWindow(nil)
  }

}

