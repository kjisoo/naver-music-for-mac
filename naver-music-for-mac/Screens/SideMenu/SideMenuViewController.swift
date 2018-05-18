//
//  SideMenuViewController.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift

class SideMenuViewController: NSViewController {
  @IBOutlet weak var signButton: NSButton!
  
  public var viewModel: SideMenuViewModel? = SideMenuViewModel()
  private let disposeBag = DisposeBag()
  private var menuList: [String] = []
  
  override var nibName: NSNib.Name? {
    return NSNib.Name("SideMenuViewController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel?.menuList.subscribe(onNext: {[weak self] in self?.menuList = $0 }).disposed(by: self.disposeBag)
    viewModel?.signState.map { $0 ? "Signout" : "Signin" }.subscribe(onNext: { [weak self] in
      self?.signButton.stringValue = $0
    }).disposed(by: self.disposeBag)
  }
}

extension SideMenuViewController: NSTableViewDataSource {
  public func numberOfRows(in tableView: NSTableView) -> Int {
    return self.menuList.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let view: NSTextField = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MenuTableViewCell"), owner: self) as! NSTextField
    view.stringValue = menuList[row]
    return view
  }
}

extension SideMenuViewController: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    NSApp.sendAction(Selector(("selectedWithIndex:")), to: nil, from: row)
    return false
  }
}
