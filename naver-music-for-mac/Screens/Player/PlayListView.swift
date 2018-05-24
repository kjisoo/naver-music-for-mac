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
  
  public var actionButtnWrapper: NSView = {
    let view = NSView()
    view.isHidden = true
    return view
  }()
  
  public var cancleButton: NSButton = {
    let button = NSButton()
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    button.attributedTitle = NSAttributedString(string: "취소",
                                                attributes: [ .foregroundColor: NSColor.darkGray,
                                                              .font: NSFont.systemFont(ofSize: 18, weight: .semibold),
                                                              .paragraphStyle: paragraph])
    button.isBordered = false
    button.wantsLayer = true
    button.layer?.cornerRadius = 12
    button.layer?.backgroundColor = NSColor.white.cgColor
    button.action = Selector(("cancleWithSender:"))
    
    button.shadow = NSShadow()
    button.layer?.shadowRadius = 8
    button.layer?.shadowOpacity = 0.5
    button.layer?.masksToBounds = false
    button.layer?.shadowColor = NSColor.black.cgColor
    return button
  }()
  public var deleteButton: NSButton = {
    let button = NSButton()
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    button.attributedTitle = NSAttributedString(string: "삭제",
                                                attributes: [ .foregroundColor: NSColor.red,
                                                              .font: NSFont.systemFont(ofSize: 18, weight: .semibold),
                                                              .paragraphStyle: paragraph])
    button.isBordered = false
    button.wantsLayer = true
    button.layer?.cornerRadius = 12
    button.layer?.backgroundColor = NSColor.white.cgColor
    button.action = Selector(("deleteWithSender:"))
    
    button.shadow = NSShadow()
    button.layer?.shadowRadius = 8
    button.layer?.shadowOpacity = 0.5
    button.layer?.masksToBounds = false
    button.layer?.shadowColor = NSColor.black.cgColor
    return button
  }()
  public var selectAllButton: NSButton = {
    let button = NSButton()
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    button.attributedTitle = NSAttributedString(string: "전체선택",
                                                attributes: [ .foregroundColor: NSColor.darkGray,
                                                              .font: NSFont.systemFont(ofSize: 18, weight: .semibold),
                                                              .paragraphStyle: paragraph])
    button.isBordered = false
    button.wantsLayer = true
    button.layer?.cornerRadius = 12
    button.layer?.backgroundColor = NSColor.white.cgColor
    button.action = Selector(("selectAllWithSender:"))
    
    button.shadow = NSShadow()
    button.layer?.shadowRadius = 8
    button.layer?.shadowOpacity = 0.5
    button.layer?.masksToBounds = false
    button.layer?.shadowColor = NSColor.black.cgColor
    return button
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
    
    let stackView = NSStackView()
    stackView.addArrangedSubview(self.cancleButton)
    stackView.addArrangedSubview(self.deleteButton)
    stackView.addArrangedSubview(self.selectAllButton)
    stackView.spacing = 60
    self.actionButtnWrapper.addSubview(stackView)
    self.addSubview(self.actionButtnWrapper)
    
    scrollView.snp.makeConstraints { (make) in
      make.top.bottom.leading.trailing.equalToSuperview()
    }
    
    self.actionButtnWrapper.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview().offset(-20)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(100)
    }
    
    stackView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
    
    self.cancleButton.snp.makeConstraints { (make) in
      make.width.equalTo(100)
      make.height.equalTo(40)
    }
    
    self.deleteButton.snp.makeConstraints { (make) in
      make.width.height.equalTo(self.cancleButton)
    }
    
    self.selectAllButton.snp.makeConstraints { (make) in
      make.width.height.equalTo(self.cancleButton)
    }
  }
  
  public func isHiddenButtons(isHidden: Bool) {
    self.actionButtnWrapper.isHidden = isHidden
  }
}
