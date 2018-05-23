//
//  PlayerController.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import SnapKit

class PlayerController: BaseViewController {
  // MARK: UI Variables
  private lazy var playListView: PlayListView = {
    let playListView = PlayListView()
    playListView.tableView.delegate = self
    playListView.tableView.dataSource = self
    return playListView
  }()
  private let playlistLabel: NSTextField = {
    let textField = NSTextField()
    textField.isEditable = false
    textField.isBordered = false
    textField.font = .systemFont(ofSize: 18, weight: .bold)
    textField.textColor = .darkGray
    textField.stringValue = "Playlist"
    return textField
  }()
  private let coverView = CoverView()
  
  
  // MARK: Variables
  private var cellViewModels: [PlayListCellViewModel] = []
  private let viewModel: PlayListViewModel
  
  
  // MARK: Life cycle
  init(viewModel: PlayListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: setup
  override func setupConstraint() {
    super.setupConstraint()
    self.view.addSubview(playListView)
    self.view.addSubview(coverView)
    self.view.addSubview(playlistLabel)
    coverView.snp.makeConstraints { (make) in
      make.top.trailing.bottom.equalToSuperview()
      make.width.equalTo(300)
    }
    
    playlistLabel.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(32)
      make.top.equalToSuperview().offset(32)
    }
    
    playListView.snp.makeConstraints { (make) in
      make.top.equalTo(playlistLabel.snp.bottom).offset(16)
      make.leading.bottom.equalToSuperview()
      make.trailing.equalTo(coverView.snp.leading)
    }
  }

  override func bindWithViewModel() {
    self.viewModel.playListCellViewModels.subscribe(onNext: { [weak self] in
      self?.cellViewModels = $0
      self?.playListView.tableView.reloadData()
    }).disposed(by: self.disposeBag)
  }
}

extension PlayerController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return cellViewModels.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let a = PlayListCellView()
    a.viewModel = self.cellViewModels[row]
    return a
  }
}

extension PlayerController: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    self.viewModel.play(index: row)
    return false
  }
}
