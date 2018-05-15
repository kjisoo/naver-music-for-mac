//
//  TOPViewController.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 12..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift
import Moya

class TOPViewController: NSViewController {
  // MARK: Variables
  private var cellViewModels: [TOPCellViewModel] = []
  private let viewModel = TOPViewModel(musicBrowser: MusicBrowser(provider: MoyaProvider<NaverPage>()))
  private let disposeBag = DisposeBag()

  // MARK: Outlets
  @IBOutlet weak var tableView: NSTableView!
  
  override var nibName: NSNib.Name? {
    return NSNib.Name("TOPViewController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.binding()
  }
  
  func binding() {
    self.viewModel.musicDatasource.subscribe(onNext: { [weak self] (viewModels) in
      self?.cellViewModels = viewModels
      self?.tableView.reloadData()
    }).disposed(by: self.disposeBag)
  }
}

extension TOPViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return self.cellViewModels.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let view: TOPTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TOPTableCellView"), owner: self) as! TOPTableCellView
    view.viewModel = self.cellViewModels[row]
    return view;
  }
}

extension TOPViewController: NSTableViewDelegate {
}
