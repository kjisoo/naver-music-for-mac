//
//  PlayListView.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 23..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class PlayListView: NSView {
  public lazy var tableView: NSTableView = {
    let tableView = NSTableView()
    tableView.addTableColumn(NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "MenuName")))
    tableView.backgroundColor = .clear
    tableView.rowHeight = 44
    tableView.focusRingType = .none
    tableView.selectionHighlightStyle = .none
    tableView.headerView = nil
    return tableView
  }()
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    self.setupConstraint()
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupConstraint() {
    let scrollView = NSScrollView()
    let clipView = NSClipView()
    scrollView.contentView = clipView
    clipView.documentView = self.tableView
    self.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { (make) in
      make.top.bottom.leading.trailing.equalToSuperview()
    }
  }
}
