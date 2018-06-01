//
//  ControlViewController.swift
//  naver-music-for-mac
//
//  Created by KimJiSoo on 2018. 6. 1..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift

class ControlViewController: NSViewController {
  // MARK: IBOutlet
  @IBOutlet weak var coverImageView: NSImageView!
  @IBOutlet weak var musicName: NSTextField!
  @IBOutlet weak var artistName: NSTextField!
  @IBOutlet weak var shuffleButton: NSButton!
  @IBOutlet weak var playButton: NSButton!
  @IBOutlet weak var volumeSlider: NSSlider!
  
  
  // MARK: Variables
  private let disposeBag = DisposeBag()
  var viewModel: ControlViewModel? = ControlViewModel(playlist: Playlist.getMyPlayList())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.bgColor = NSColor(red: 39/255.0, green: 39/255.0, blue: 39/255.0, alpha: 1)
    self.bindWithViewModel()
  }
  
  private func bindWithViewModel() {
    viewModel?.musicName.subscribe(onNext: { [weak self] in
      self?.musicName.stringValue = $0 ?? ""
    }).disposed(by: self.disposeBag)
    
    viewModel?.artistName.subscribe(onNext: { [weak self] in
      self?.artistName.stringValue = $0 ?? ""
    }).disposed(by: self.disposeBag)
    
    viewModel?.coverImageURLString.subscribe(onNext: { [weak self] in
      self?.coverImageView.kf.setImage(with: $0)
    }).disposed(by: self.disposeBag)
    
    viewModel?.isShuffled.subscribe(onNext: { [weak self] in
      self?.shuffleButton.isSelected = $0
    }).disposed(by: self.disposeBag)
    
    viewModel?.volume.subscribe(onNext: { [weak self] in
      self?.volumeSlider.integerValue = $0
    }).disposed(by: self.disposeBag)
    
    viewModel?.isPaused.subscribe(onNext: { [weak self] in
      self?.playButton.isSelected = !$0
    }).disposed(by: self.disposeBag)
  }
  
  @IBAction func action(sender: NSControl) {
    guard let id = sender.identifier?.rawValue else {
      return
    }
    switch id {
    case "prev":
      self.viewModel?.prev()
    case "next":
      self.viewModel?.next()
    case "play":
      self.viewModel?.play()
    case "volumeBar":
      self.viewModel?.change(volume: sender.integerValue)
    case "shuffle":
      self.viewModel?.toggleShuffle()
    default:
      print(id)
    }
    
  }
}
