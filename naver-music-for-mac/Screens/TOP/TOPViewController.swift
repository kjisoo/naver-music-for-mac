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
  private let viewModel = TOPViewModel(musicBrowser: MusicBrowser(provider: MoyaProvider<NaverPage>()))

  // MARK: UI Variables
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
    tableView.intercellSpacing = NSSize(width: 0, height: 1)
    tableView.addTableColumn(NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "MusicColumn")))
    return tableView
  }()
  
  private let buttonGroupView = ButtonGroupView(buttonTitles: [("취소", NSColor.darkGray),
                                                               ("플레이리스트에 추가", NSColor.darkGray),
                                                               ("전체선택", NSColor.darkGray)])
  
  
  override func setupConstraint() {
    super.setupConstraint()
    self.title = "TOP100"
    self.view.addSubview(self.totalButton)
    self.view.addSubview(self.domesticButton)
    self.view.addSubview(self.overseaButton)
    let scrollView = NSScrollView()
    let clipView = NSClipView()
    scrollView.contentView = clipView
    clipView.documentView = self.tableView
    self.view.addSubview(scrollView)
    self.view.addSubview(self.buttonGroupView)
    
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
    
    buttonGroupView.snp.makeConstraints { (make) in
      make.centerX.equalTo(scrollView)
      make.width.equalTo(400)
      make.height.equalTo(70)
      make.bottom.equalTo(scrollView).offset(-50)
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
    
    self.viewModel.isExistingSelectedCell.subscribe(onNext: { [weak self] in
      self?.buttonGroupView.isHidden = !$0
    }).disposed(by: self.disposeBag)
    
    self.buttonGroupView.selectedButtonIndex.subscribe(onNext: { [weak self] in
      [self?.viewModel.deselectAll, self?.viewModel.addSelectedMusicToPlaylist, self?.viewModel.selectAll][$0]?()
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
  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    if let isChecked = try? self.cellViewModels[row].isChecked.value() {
      self.cellViewModels[row].isChecked.onNext(!isChecked)
    }
    return false
  }
}
