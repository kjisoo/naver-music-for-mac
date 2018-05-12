//
//  TOPViewController.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 12..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class TOPViewController: NSViewController {
  @IBOutlet weak var tableView: NSTableView!
  override var nibName: NSNib.Name? {
    return NSNib.Name("TOPViewController")
  }
}

extension TOPViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return 30
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let result: TOPTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TOPTableCellView"), owner: self) as! TOPTableCellView
    return result;
  }
}

extension TOPViewController: NSTableViewDelegate {
}
