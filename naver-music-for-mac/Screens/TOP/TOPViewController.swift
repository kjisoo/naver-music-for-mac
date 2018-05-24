//
//  TOPViewController.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 12..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import Moya

class TOPViewController: BaseViewController {
  // MARK: Variables
  private var cellViewModels: [MusicCellViewModel] = []
  private let viewModel = TOPViewModel(musicBrowser: MusicBrowser(provider: MoyaProvider<NaverPage>()), playListRepository: Repository<Playlist>())

  // MARK: UI Variables
  private let titleLabel: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.font = .systemFont(ofSize: 21, weight: .bold)
    textField.textColor = .darkGray
    textField.stringValue = "TOP100"
    return textField
  }()
  
  private let totalButton: NSButton = {
    let button = NSButton(title: "종합", target: nil, action: nil)
    button.isBordered = false
    return button
  }()
  
  private let domesticButton: NSButton = {
    let button = NSButton(title: "국내", target: nil, action: nil)
    button.isBordered = false
    return button
  }()
  
  private let overseaButton: NSButton = {
    let button = NSButton(title: "해외", target: nil, action: nil)
    button.isBordered = false
    return button
  }()
  
  private lazy var tableView: NSTableView = {
    let tableView = NSTableView()
    tableView.headerView = nil
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 100
    tableView.addTableColumn(NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "MusicColumn")))
    return tableView
  }()
  
  
  override func setupConstraint() {
    self.view.addSubview(self.titleLabel)
    self.view.addSubview(self.totalButton)
    self.view.addSubview(self.domesticButton)
    self.view.addSubview(self.overseaButton)
    let scrollView = NSScrollView()
    let clipView = NSClipView()
    scrollView.contentView = clipView
    clipView.documentView = self.tableView
    self.view.addSubview(scrollView)
    
    titleLabel.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(32)
      make.top.equalToSuperview().offset(32)
    }
    
    overseaButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(self.titleLabel)
      make.trailing.equalToSuperview().offset(-32)
    }
    
    domesticButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(self.overseaButton)
      make.trailing.equalTo(self.overseaButton.snp.leading).offset(-16)
    }
    
    totalButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(self.overseaButton)
      make.trailing.equalTo(self.domesticButton.snp.leading).offset(-16)
    }
    
    scrollView.snp.makeConstraints { (make) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
      make.bottom.leading.trailing.equalToSuperview()
    }
  }
  
  override func bindWithViewModel() {
    self.viewModel.musicDatasource.asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (viewModels) in
      self?.cellViewModels = viewModels
      self?.tableView.reloadData()
      self?.tableView.scrollRowToVisible(0)
    }).disposed(by: self.disposeBag)
    
    Observable<Int>.merge(
      Observable.just(0),
      self.totalButton.rx.controlEvent.map { 0 },
      self.domesticButton.rx.controlEvent.map { 1 },
      self.overseaButton.rx.controlEvent.map { 2 }
      ).subscribe(onNext: { [weak self] in
        if let `self` = self {
          self.selectedType(index: $0, buttons: [self.totalButton, self.domesticButton, self.overseaButton])
        }
      }).disposed(by: self.disposeBag)
  }
  
  private func selectedType(index: Int, buttons: [NSButton]) {
    buttons.forEach { button in
      button.attributedTitle = NSAttributedString(string: button.title,
                                                  attributes: [.foregroundColor: NSColor.lightGray,
                                                               .font: NSFont.systemFont(ofSize: 16, weight: .semibold)])
    }
    buttons[index].attributedTitle = NSAttributedString(string: buttons[index].title,
                                                        attributes: [.foregroundColor: NSColor.darkGray,
                                                                     .font: NSFont.systemFont(ofSize: 16, weight: .semibold)])
    self.viewModel.topType.onNext([TOPType.total, TOPType.domestic, TOPType.oversea][index])
  }
}

extension TOPViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.cellViewModels.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MusicCellView"), owner: self) as? MusicCellView ?? MusicCellView()
    cell.viewModel = self.cellViewModels[row]
    cell.rank.stringValue = "\(row+1)"
    return cell
  }
}

extension TOPViewController: NSTableViewDelegate {
  func tableViewSelectionDidChange(_ notification: Notification) {
  }
}
