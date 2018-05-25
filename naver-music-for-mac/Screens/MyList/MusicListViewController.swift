//
//  MusicListViewController.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 21..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class MusicListViewController: BaseViewController {
  private var cellViewModels: [MusicCellViewModel] = []
  private let viewModel: MusicListViewModel
  
  private lazy var tableView: NSTableView = {
    let tableView = NSTableView()
    tableView.headerView = nil
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 100
    tableView.intercellSpacing = NSSize.zero
    tableView.addTableColumn(NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "MusicColumn")))
    return tableView
  }()
  
  init(viewModel: MusicListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupConstraint() {
    super.setupConstraint()
    let scrollView = NSScrollView()
    let clipView = NSClipView()
    scrollView.contentView = clipView
    clipView.documentView = self.tableView
    self.view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { (make) in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
      make.bottom.leading.trailing.equalToSuperview()
    }
  }
  
  override func bindWithViewModel() {
    self.viewModel.title.subscribe(onNext: { [weak self] in
      self?.title = $0
    }).disposed(by: self.disposeBag)
    
    self.viewModel.musicDatasource.asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (viewModels) in
      self?.cellViewModels = viewModels
      self?.tableView.reloadData()
      self?.tableView.scrollRowToVisible(0)
    }).disposed(by: self.disposeBag)
  }
}

extension MusicListViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.cellViewModels.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "MusicCellView"), owner: self) as? MusicCellView ?? MusicCellView()
    cell.viewModel = self.cellViewModels[row]
    return cell
  }
}

extension MusicListViewController: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    if let isChecked = try? self.cellViewModels[row].isChecked.value() {
      self.cellViewModels[row].isChecked.onNext(!isChecked)
    }
    return false
  }
}
