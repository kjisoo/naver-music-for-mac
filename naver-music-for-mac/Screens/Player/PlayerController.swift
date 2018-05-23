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
  private let playListView = PlayListView()
  private let coverView = CoverView()
  
  
  // MARK: Variables
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
    
    coverView.snp.makeConstraints { (make) in
      make.top.trailing.bottom.equalToSuperview()
      make.width.equalTo(300)
    }
    
    playListView.snp.makeConstraints { (make) in
      make.top.leading.bottom.equalToSuperview()
      make.trailing.equalTo(coverView.snp.leading)
      make.width.width.greaterThanOrEqualTo(300)
    }
  }

  override func bindWithViewModel() {
    
  }
}
