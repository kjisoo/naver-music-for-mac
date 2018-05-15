//
//  PlayListViewController.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class PlayListViewController: NSViewController {
  override var nibName: NSNib.Name? {
    return NSNib.Name("PlayListViewController")
  }
}

extension PlayListViewController: NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    return 0
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let view: TOPTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PlayListCellView"), owner: self) as! TOPTableCellView
    return view
  }
}

extension PlayListViewController: NSTableViewDelegate {
  
}
