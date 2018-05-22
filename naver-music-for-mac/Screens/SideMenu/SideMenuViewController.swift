//
//  SideMenuViewController.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift
import SnapKit

class SideMenuViewController: BaseViewController {
  private let viewModel: SideMenuViewModel
  private var menuList: [String] = []
  
  private lazy var menuListView: NSTableView = {
    let tableView = NSTableView()
    tableView.addTableColumn(NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "MenuName")))
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .clear
    tableView.rowHeight = 40
    tableView.focusRingType = .none
    tableView.selectionHighlightStyle = .none
    return tableView
  }()
  
  init(viewModel: SideMenuViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    let view = NSVisualEffectView()
    view.material = .mediumLight
    view.blendingMode = .behindWindow
    self.view = view
  }

  override func setupConstraint() {
    self.view.addSubview(self.menuListView)
    self.menuListView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(70)
      make.leading.trailing.equalToSuperview()
    }
  }
  
  override func bindWithViewModel() {
    viewModel.menuList.subscribe(onNext: {[weak self] in
      self?.menuList = $0
      self?.menuListView.reloadData() }).disposed(by: self.disposeBag)
  }
}

extension SideMenuViewController: NSTableViewDataSource {
  
  func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
    return tableView.rowHeight
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.menuList.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MenuCellView"), owner: self) as? MenuCellView ?? MenuCellView()
    view.menuNameField.stringValue = menuList[row]
    return view
  }
}

extension SideMenuViewController: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
//    NSApp.sendAction(Selector(("selectedWithIndex:")), to: nil, from: row)
    print(row)
    return true
  }
  
}

class MenuCellView: NSView {
  public let iconImageView = NSImageView()
  public let menuNameField: NSTextField = {
    let textField = NSTextField()
    textField.isBordered = false
    textField.isEditable = false
    textField.backgroundColor = .clear
    textField.textColor = .darkGray
    textField.font = NSFont.systemFont(ofSize: 12, weight: .semibold)
    return textField
  }()
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.setupConstraint()
    self.identifier = NSUserInterfaceItemIdentifier(rawValue: "MenuCellView")
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraint() {
    let stackView = NSStackView()
    self.addSubview(stackView)

    stackView.orientation = .horizontal
    stackView.addArrangedSubview(iconImageView)
    stackView.addArrangedSubview(menuNameField)
    stackView.snp.makeConstraints { (make) in
      make.bottom.trailing.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
    }
  }
}
