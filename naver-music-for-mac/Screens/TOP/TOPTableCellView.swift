//
//  TOPTableCellView.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 12..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class TOPTableCellView: NSTableCellView {
  @IBOutlet weak var coverImageView: NSImageView!
  @IBOutlet weak var rank: NSTextField!
  @IBOutlet weak var name: NSTextField!
  @IBOutlet weak var albumName: NSTextField!
  @IBOutlet weak var optionButton: NSButton!
}
