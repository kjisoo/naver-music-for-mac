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
  private let coverView = CoverView()
  private let buttonGroupView = ButtonGroupView(buttonTitles: [("취소", NSColor.darkGray),
                                                               ("삭제", NSColor.red),
                                                               ("전체선택", NSColor.darkGray)])
  
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
    self.title = "Playlist"
    self.view.addSubview(playListView)
    self.view.addSubview(coverView)
    self.view.addSubview(buttonGroupView)
    
    coverView.snp.makeConstraints { (make) in
      make.top.trailing.bottom.equalToSuperview()
      make.width.equalTo(300)
    }
    
    playListView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.leading.bottom.equalToSuperview()
      make.trailing.equalTo(coverView.snp.leading)
    }
    
    buttonGroupView.snp.makeConstraints { (make) in
      make.centerX.equalTo(playListView)
      make.width.equalTo(300)
      make.height.equalTo(70)
      make.bottom.equalTo(playListView).offset(-50)
    }
  }

  override func bindWithViewModel() {
    self.viewModel.playListCellViewModels.subscribe(onNext: { [weak self] in
      self?.cellViewModels = $0
      self?.playListView.tableView.reloadData()
    }).disposed(by: self.disposeBag)

    self.viewModel.isExistingSelectedCell.subscribe(onNext: { [weak self] in
      self?.buttonGroupView.isHidden = !$0
    }).disposed(by: self.disposeBag)

    self.viewModel.coverImageURLString.subscribe(onNext: { [weak self] in
      self?.coverView.coverImageView.kf.setImage(with: $0)
    }).disposed(by: self.disposeBag)

    self.viewModel.musicName.subscribe(onNext: { [weak self] in
      self?.coverView.musicNameField.stringValue = $0 ?? ""
    }).disposed(by: self.disposeBag)

    self.viewModel.lyrics.subscribe(onNext: { [weak self] in
      self?.coverView.lyricsView.string = $0 ?? "등록된 가사가 없습니다."
    }).disposed(by: self.disposeBag)

    self.viewModel.artistName.subscribe(onNext: { [weak self] in
      self?.coverView.artistNameField.stringValue = $0 ?? ""
    }).disposed(by: self.disposeBag)
    
    self.viewModel.volume.subscribe(onNext: { [weak self] in
      self?.coverView.volumeSlider.intValue = Int32($0)
    }).disposed(by: self.disposeBag)

    self.coverView.prevButton.rx.controlEvent.subscribe(onNext: { [weak self] (_) in
      self?.viewModel.prev()
    }).disposed(by: self.disposeBag)
    
    self.coverView.nextButton.rx.controlEvent.subscribe(onNext: { [weak self] (_) in
      self?.viewModel.next()
    }).disposed(by: self.disposeBag)
    
    self.coverView.playButton.rx.controlEvent.subscribe(onNext: { [weak self] (_) in
      self?.viewModel.play()
    }).disposed(by: self.disposeBag)

    self.coverView.volumeSlider.rx.value.distinctUntilChanged().subscribe(onNext: { [weak self] in
      if let `self` = self {
        self.viewModel.change(volume: Int($0))
      }
    }).disposed(by: self.disposeBag)
    
    self.viewModel.isPaused.subscribe(onNext: { [weak self] in
      self?.coverView.setPaused(isPuased: $0)
    }).disposed(by: self.disposeBag)
    
    self.viewModel.isShuffled.subscribe(onNext: { [weak self] in
      let image = self?.coverView.shuffleButton.image
      self?.coverView.shuffleButton.image = $0 ? image?.tint(color: .violet) : image?.tint(color: .lightGray)
      self?.coverView.shuffleButton.state = $0 ? .on : .off
    }).disposed(by: self.disposeBag)
    
    self.coverView.shuffleButton.rx.controlEvent.subscribe(onNext: { [weak self] in
      self?.viewModel.change(isShuffled: self!.coverView.shuffleButton.state == .on)
    }).disposed(by: self.disposeBag)
    
    self.buttonGroupView.selectedButtonIndex.subscribe(onNext: { [weak self] in
      [self?.viewModel.deselectAll, self?.viewModel.deleteSelectedList, self?.viewModel.selectAll][$0]?()
    }).disposed(by: self.disposeBag)
  }
}

extension PlayerController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return cellViewModels.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PlayListCellView"), owner: self) as? PlayListCellView ?? PlayListCellView()
    cell.viewModel = self.cellViewModels[row]
    return cell
  }
}

extension PlayerController: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    self.viewModel.play(index: row)
    return false
  }
}
