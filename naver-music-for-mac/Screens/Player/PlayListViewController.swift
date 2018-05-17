//
//  PlayListViewController.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift
import Moya

class PlayListViewController: NSViewController {
  // MARK: Variables
  private var cellViewModels: [PlayListCellViewModel] = []
  private let disposeBag = DisposeBag()
  public var viewModel: PlayListViewModel!
  override var nibName: NSNib.Name? {
    return NSNib.Name("PlayListViewController")
  }
  
  
  // MARK: Outlets
  @IBOutlet weak var tableView: NSTableView!
  
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.playListViewModels.subscribe(onNext: { [weak self] in
      self?.cellViewModels = $0
      self?.tableView.reloadData()
    }).disposed(by: self.disposeBag)
  }
  
  
  // MARK: IBActions
  @IBAction func delete(sender: NSButton) {
    self.viewModel.deleteSelectedList()
  }
  
  @IBAction func selectAll(sender: NSButton) {
    if case NSControl.StateValue.on = sender.state {
      self.viewModel.selectAll()
    } else if case NSControl.StateValue.off = sender.state {
      self.viewModel.deselectAll()
    }
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
  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    self.viewModel.play(index: row)
    return false
  }
}
