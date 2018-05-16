//
//  PlayListCellView.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 15..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RxSwift

class PlayListCellView: NSTableCellView {
  // MARK: IBOutlets
  @IBOutlet weak var name: NSTextField!
  @IBOutlet weak var checkButton: NSButton!
  
  // MARK: Variables
  private var disposeBag = DisposeBag()
  public var viewModel: PlayListCellViewModel? {
    didSet {
      self.disposeBag = DisposeBag()
      
      self.viewModel?.name.subscribe(onNext: { [weak self] in
        self?.name.stringValue = $0
      }).disposed(by: self.disposeBag)
      
      self.viewModel?.isPlaying.subscribe(onNext: { [weak self] in
        self?.name.textColor = $0 ? NSColor.green : NSColor.black
      }).disposed(by: self.disposeBag)
      
      self.viewModel?.propertyChanged.subscribe(onNext: { [weak self] _ in
        if self?.viewModel?.isChecked == true {
          self?.checkButton.state = .on
        } else {
          self?.checkButton.state = .off
        }
      }).disposed(by: self.disposeBag)
      
      self.checkButton.rx.controlProperty(getter: { (button) -> Void in
        self.viewModel?.checked(checked: button.state == .on)
      }, setter: {_,_ in }).subscribe().disposed(by: self.disposeBag)
    }
  }
}
