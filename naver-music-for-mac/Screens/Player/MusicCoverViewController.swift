//
//  MusicCoverViewController.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 5. 11..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift

class MusicCoverViewController: NSViewController {
  @IBOutlet weak var coverImage: NSImageView!
  
  private let disposeBag = DisposeBag()
  public var viewModel: MusicCoverViewModel = MusicCoverViewModel()
  
  override var nibName: NSNib.Name? {
    return NSNib.Name("MusicCoverViewController")
  }
  
  override func viewDidLoad() {
    self.viewModel.coverImageURLString.subscribe(onNext: { [weak self] in
      self?.coverImage.kf.setImage(with: $0)
    }).disposed(by: self.disposeBag)
  }
  
  // MARK: IBActions
  @IBAction func prev(sender: NSButton) {
    self.viewModel.prev()
  }
  
  @IBAction func next(sender: NSButton) {
    self.viewModel.next()
  }
  
  @IBAction func palyOrPause(sender: NSButton) {
  }
}
