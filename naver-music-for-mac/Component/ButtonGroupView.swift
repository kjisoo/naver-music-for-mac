//
//  ButtonGroupView.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 25..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import SnapKit
import RxSwift
import RxCocoa

class ButtonGroupView: NSVisualEffectView {
  public let selectedButtonIndex = PublishSubject<Int>()
  private let disposeBag = DisposeBag()
  
  init(buttonTitles: [(String, NSColor)]) {
    super.init(frame: NSRect.zero)
    self.setupConstraint(buttonTitles: buttonTitles)
  }
  
  required init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraint(buttonTitles: [(String, NSColor)]) {
    self.wantsLayer = true
    self.layer?.cornerRadius = 16
    self.material = .mediumLight
    self.blendingMode = .withinWindow

    let stackView = NSStackView()
    stackView.distribution = .fillEqually
    self.addSubview(stackView)
    
    stackView.snp.makeConstraints { (make) in
      make.top.bottom.leading.trailing.equalToSuperview()
    }
    
    for (index, value) in buttonTitles.enumerated() {
      let button = NSButton()
      let paragraph = NSMutableParagraphStyle()
      paragraph.alignment = .center
      button.attributedTitle = NSAttributedString(string: value.0,
                                                  attributes: [ .foregroundColor: value.1,
                                                                .font: NSFont.systemFont(ofSize: 18, weight: .semibold),
                                                                .paragraphStyle: paragraph])
      button.isBordered = false
      button.rx.controlEvent.map({index}).bind(to: self.selectedButtonIndex).disposed(by: self.disposeBag)
      stackView.addArrangedSubview(button)
      button.snp.makeConstraints({ (make) in
        make.top.bottom.equalToSuperview()
      })
    }
  }
}
