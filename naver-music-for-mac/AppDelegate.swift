//
//  AppDelegate.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 7..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import Swinject
import RealmSwift
import Moya

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  let window = WindowController()
  let container: Swinject.Container = {
    let container = Swinject.Container()
    container.register(Realm.self) { _ in try! Realm() }
    container.register(MoyaProvider<NaverPage>.self) { _ in MoyaProvider<NaverPage>() }
    container.register(TOPParser.self) { _ in TOPParser() }
    return container
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    Container.container = container
    window.showWindow(nil)
  }

}

