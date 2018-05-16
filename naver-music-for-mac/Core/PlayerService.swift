//
//  PlayerService.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 13..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import WebKit

protocol PlayerServiceType {
  var playList: Playlist { get }
  func resume()
  func pause()
  func next()
  func prev()
  func play(index: Int)
}

class PlayerService: NSObject {
  let webPlayer: WebView = {
    return WebView()
  }()
  
  override init() {
    super.init()
    setupWebPlayer()
  }
  
  private func setupWebPlayer() {
    self.webPlayer.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1"
    self.webPlayer.mainFrame.load(URLRequest(url: URL(string: "http://m.music.naver.com")!))
    self.webPlayer.uiDelegate = self
    self.webPlayer.frameLoadDelegate = self
  }
}

extension PlayerService: WebUIDelegate {
  
}

extension PlayerService: WebFrameLoadDelegate {
  
}
