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

class TOPViewController: NSViewController {
  // MARK: Variables
  private var cellViewModels: [TOPCellViewModel] = []
  private let viewModel = TOPViewModel(musicBrowser: MusicBrowser(provider: MoyaProvider<NaverPage>()))
  private let disposeBag = DisposeBag()

  // MARK: Outlets
  @IBOutlet weak var tableView: NSTableView!
  @IBOutlet weak var topTypeSegmentedControl: NSSegmentedControl!
  @IBOutlet weak var addingViewHeightConstraint: NSLayoutConstraint!
  
  override var nibName: NSNib.Name? {
    return NSNib.Name("TOPViewController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.binding()
    self.view.wantsLayer = true
    self.view.layer?.backgroundColor = NSColor.white.cgColor
  }
  
  private func binding() {
    self.viewModel.musicDatasource.subscribe(onNext: { [weak self] (viewModels) in
      self?.cellViewModels = viewModels
      self?.tableView.reloadData()
    }).disposed(by: self.disposeBag)
    
    self.topTypeSegmentedControl.rx.controlProperty(getter: { $0.selectedSegment }, setter: { _,_ in  })
      .map { (index) -> TOPType in
        if index == 0 {
          return TOPType.total
        } else if index == 1 {
          return TOPType.domestic
        } else if index == 2 {
          return TOPType.oversea
        } else {
          return TOPType.total
        }
      }
      .subscribe(onNext: { [weak self] type in
        self?.viewModel.topType.onNext(type)
      })
      .disposed(by: self.disposeBag)
  }
  
  private func hiddenAddingList(hidden: Bool) {
    if hidden {
      self.addingViewHeightConstraint.constant = 0
    } else {
      self.addingViewHeightConstraint.constant = 100
    }
  }
  
  @IBAction func addingList(sender: NSButton) {
    self.viewModel.addMusicToList(indexs: Array(self.tableView.selectedRowIndexes))
    self.tableView.deselectAll(nil)
  }
  
  @IBAction func selectAllMusic(sender: NSButton) {
    self.tableView.selectAll(nil)
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
  func tableViewSelectionDidChange(_ notification: Notification) {
    self.hiddenAddingList(hidden: self.tableView.selectedRowIndexes.count == 0)
  }
}
