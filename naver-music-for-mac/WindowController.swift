//
//  WindowController.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import Moya
import RxSwift

class WindowController: NSWindowController {
  override var windowNibName: NSNib.Name? {
    return NSNib.Name("WindowController")
  }
  
  let statusBarItems: [NSStatusItem] = {
    let nextItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let playItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let prevItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    nextItem.action = #selector(WindowController.next(sender:))
    nextItem.image = NSImage(named: NSImage.Name("next"))
    
    playItem.action = #selector(WindowController.palyOrPause(sender:))
    playItem.image = NSImage(named: NSImage.Name("play"))
    
    prevItem.action = #selector(WindowController.prev(sender:))
    prevItem.image = NSImage(named: NSImage.Name("prev"))
    return [nextItem, playItem, prevItem]
  }()
  
  // MARK: Variables
  private let musicBrowser = MusicBrowser(provider: MoyaProvider<NaverPage>())
  private let selectedIndex = BehaviorSubject<Int>(value: 1)
  private let sideMenuViewModel = SideMenuViewModel()
  private lazy var sideMenuViewController: SideMenuViewController = {
    return SideMenuViewController(viewModel: self.sideMenuViewModel)
  }()
  lazy var contentTabViewController: NSTabViewController = {
    let tabViewController = NSTabViewController()
    tabViewController.tabStyle = .unspecified
    tabViewController.view.translatesAutoresizingMaskIntoConstraints = true
    tabViewController.addTabViewItem(NSTabViewItem(viewController: PlayerController(viewModel: PlayListViewModel())))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: TOPViewController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: MusicListViewController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: SettingViewController()))
    tabViewController.addTabViewItem(NSTabViewItem(viewController: SignViewController()))
    return tabViewController
  }()
  
  // MARK: Life cycle
  override func windowDidLoad() {
    super.windowDidLoad()
    self.window?.titleVisibility = .hidden
    self.window?.backgroundColor = .white
    self.window?.titlebarAppearsTransparent = true
    self.window?.isMovableByWindowBackground = true
    self.window?.isOpaque = false
    self.setupSplitView()
    self.setupPlayer()
    self.setupAuthorizedState()
    self.setupMenuList()
  }
  
  // MARK: Private Methods
  private func setupSplitView() {
    guard let window = self.window else {
      return
    }
    let splitViewController = SplitViewController()
    
    let sideMenuSplitViewItem = NSSplitViewItem(contentListWithViewController: self.sideMenuViewController)
    sideMenuSplitViewItem.minimumThickness = 200
    sideMenuSplitViewItem.maximumThickness = 200
    splitViewController.addSplitViewItem(sideMenuSplitViewItem)
    
    let contentSplitViewItem = NSSplitViewItem(viewController: contentTabViewController)
    contentSplitViewItem.minimumThickness = 400
    splitViewController.addSplitViewItem(contentSplitViewItem)

    let frameSize = window.contentRect(forFrameRect: window.frame).size
    splitViewController.view.setFrameSize(frameSize)
    window.contentViewController = splitViewController
  }
  
  private func setupPlayer() {
    _ = PlayerService.shared().isPaused
      .map { $0 ? NSImage(named: NSImage.Name("play")) : NSImage(named: NSImage.Name("pause")) }
      .subscribe(onNext: { self.statusBarItems[1].image = $0 })
  }

  private func setupAuthorizedState() {
    _ = AuthService.shared().changedAuthorizedState.subscribe(onNext: {
      if $0 {
        self.selectedIndex.onNext(1)
        self.changePage(url: "player")
      }
    })
  }
  
  private func setupMenuList() {
    _ = Observable.combineLatest(self.selectedIndex.distinctUntilChanged(),
                                 AuthService.shared().changedAuthorizedState,
                                 AuthService.shared().changedAuthorizedState.flatMapLatest { return $0 ? self.musicBrowser.fetchMyList().asObservable() : Observable<[MusicList]>.just([]) })
      .map({ (selectedIndex, isAuthorized, playlists) -> [MenuItem] in
        var menuList: [MenuItem] = [
          MenuItem(name: "MENU", iconNmae: nil, isSelected: selectedIndex == 0, command: nil),
          MenuItem(name: "Player", iconNmae: "play", isSelected: selectedIndex == 1, command: {
            self.selectedIndex.onNext(1)
            self.changePage(url: "player")
          }),
          MenuItem(name: "TOP100", iconNmae: "play", isSelected: selectedIndex == 2, command: {
            self.selectedIndex.onNext(2)
            self.changePage(url: "top100")
          }),
          MenuItem(name: "Setting", iconNmae: "play", isSelected: selectedIndex == 3, command: {
            self.selectedIndex.onNext(3)
            self.changePage(url: "setting")
          }),
          ]

        if isAuthorized {
          menuList.append(MenuItem(name: "Signout", iconNmae: "play", isSelected: selectedIndex == 4, command: {
            self.selectedIndex.onNext(4)
            self.changePage(url: "signout")
          }))
        } else {
          menuList.append(MenuItem(name: "Signin", iconNmae: "play", isSelected: selectedIndex == 4, command: {
            self.selectedIndex.onNext(4)
            self.changePage(url: "signin")
          }))
        }
        menuList.append(MenuItem(name: "", iconNmae: nil, isSelected: selectedIndex == 5, command: nil))
        if playlists.count > 0 {
          menuList.append(MenuItem(name: "PLAYLISTS", iconNmae: nil, isSelected: selectedIndex == 6, command: nil))
          for (index, playlist) in playlists.enumerated() {
            menuList.append(MenuItem(name: playlist.name, iconNmae: "play", isSelected: selectedIndex == 7+index, command: {
              self.selectedIndex.onNext(7+index)
              self.changePage(url: "playlist/\(playlist.id)")
            }))
          }
        }
        return menuList
      })
      .subscribe(onNext: {
        self.sideMenuViewModel.replace(menuItems: $0)
      })
  }
  
  private func changePage(url: String) {
    let tokens = url.lowercased().split(separator: "/")
    let page = tokens.first ?? ""
    let selectedType = ["player": PlayerController.self,
                        "top100": TOPViewController.self,
                        "setting": SettingViewController.self,
                        "signin": SignViewController.self,
                        "signout": SignViewController.self,
                        "playlist": PlayListViewController.self][page, default: nil]
    if let index = self.contentTabViewController.childViewControllers.enumerated().first(where: { type(of: $0.element.self) == selectedType })?.offset {
      self.contentTabViewController.selectedTabViewItemIndex = index
    }
    if page == "signout" {
      AuthService.shared().signout()
    } else if page == "playlist", let id = tokens.last {
      
    }
  }
  
  // MARK: IBActions
  @IBAction func prev(sender: NSButton) {
    PlayerService.shared().prev()
  }
  
  @IBAction func next(sender: NSButton) {
    PlayerService.shared().next()
  }
  
  @IBAction func palyOrPause(sender: NSButton) {
    PlayerService.shared().togglePlay()
  }
}


extension WindowController: NSWindowDelegate {
  func windowShouldClose(_ sender: NSWindow) -> Bool {
    NSApp.hide(nil)
    return false
  }
}

