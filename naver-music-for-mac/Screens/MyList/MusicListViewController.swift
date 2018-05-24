//
//  MusicListViewController.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 21..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class MusicListViewController: BaseViewController {
  private let viewModel: MusicListViewModel
  
  init(viewModel: MusicListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func bindWithViewModel() {
    self.viewModel.title.subscribe(onNext: { [weak self] in
      self?.title = $0
    }).disposed(by: self.disposeBag)
  }
}
