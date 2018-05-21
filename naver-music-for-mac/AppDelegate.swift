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
  var window: WindowController?
  let container: Swinject.Container = {
    let container = Swinject.Container()
    container.register(MoyaProvider<NaverPage>.self) { _ in MoyaProvider<NaverPage>() }
    container.register(TOPParser.self) { _ in TOPParser() }
    container.register(MusicBrowser.self) { r in
      return MusicBrowser(provider: r.resolve(MoyaProvider<NaverPage>.self)!,
                          parser: r.resolve(TOPParser.self)!)
    }
    container.register(WindowController.self) { r in
      let windowController = WindowController()
      return windowController
    }
    container.register(PlayListViewModel.self) { r in
      return PlayListViewModel()
    }
    container.register(PlayListViewController.self) { r in
      let playListViewController = PlayListViewController()
      playListViewController.viewModel = r.resolve(PlayListViewModel.self)
      return playListViewController
    }
    return container
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    Container.container = container
    self.window = container.resolve(WindowController.self)
    window?.showWindow(nil)
  }

}

