//
//  MusicCoverViewController.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa

class MusicCoverViewController: NSViewController {
  @IBOutlet weak var coverImage: NSImageView!
  
  override var nibName: NSNib.Name? {
    return NSNib.Name("MusicCoverViewController")
  }
}
