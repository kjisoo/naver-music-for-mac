//
//  PlayListViewController.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift

class PlayListViewController: NSViewController {
  // MARK: Variables
  private var cellViewModels: [PlayListCellViewModel] = []
  private let viewModel = PlayListViewModel()
  private let disposeBag = DisposeBag()
  
  // MARK: Outlets
  @IBOutlet weak var tableView: NSTableView!
  
  override var nibName: NSNib.Name? {
    return NSNib.Name("PlayListViewController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.playListViewModels.subscribe(onNext: { [weak self] in
      self?.cellViewModels = $0
      self?.tableView.reloadData()
    }).disposed(by: self.disposeBag)
  }
}

extension PlayListViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return cellViewModels.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let view: PlayListCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PlayListCellView"), owner: self) as! PlayListCellView
    view.viewModel = self.cellViewModels[row]
    return view
  }
}

extension PlayListViewController: NSTableViewDelegate {
  
}
