//
//  PlayerService.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 13..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import WebKit
import RealmSwift
import RxRealm
import RxSwift

class PlayerService: NSObject {
  private static let instance = PlayerService()
  private let playList: Playlist = Playlist.get(type: .my)
  private let disposeBag = DisposeBag()
  private var currentIndex = -1
  public let playedMusic = PublishSubject<(index: Int, music: Music)>()
  public let webPlayer: WebView = {
    return WebView()
  }()

  private override init() {
    super.init()
    setupWebPlayer()
    bindingPlayList()
  }
  
  public static func shared() -> PlayerService {
    return self.instance
  }
  
  private func setupWebPlayer() {
    self.webPlayer.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1"
    self.webPlayer.mainFrame.load(URLRequest(url: URL(string: "http://m.music.naver.com/search/search.nhn")!))
    self.webPlayer.uiDelegate = self
    self.webPlayer.frameLoadDelegate = self
  }
  
  private func bindingPlayList() {
    Observable.changeset(from: playList.musics).subscribe(onNext: { [weak self] (_, changeset) in
      if let changeset = changeset,
        changeset.deleted.contains(self?.currentIndex ?? -1) {
        self?.stop()
      }
    }).disposed(by: self.disposeBag)
  }
  
  public func resume() {
    if let currentTime = Int(self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.currentTime()")),
      currentTime > 0 {
        self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.resume();")
    } else {
      self.next()
    }
  }
  
  public func pause() {
    self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.pause();")
  }
  
  public func next() {
    guard self.playList.musics.count > 0 else {
      return
    }
    if currentIndex + 1 < self.playList.musics.count {
      self.play(index: currentIndex + 1)
    } else {
      self.play(index: 0)
    }
  }
  
  public func prev() {
    guard self.playList.musics.count > 0 else {
      return
    }
    if 0 < currentIndex - 1 {
      self.play(index: currentIndex - 1)
    } else {
      self.play(index: self.playList.musics.count - 1)
    }
  }
  
  public func stop() {
    self.currentIndex = -1;
    self.pause()
  }
  
  public func play(index: Int) {
    self.currentIndex = index
    let music = self.playList.musics[index]
    self.playedMusic.onNext((index: index, music: music))
    play(id: music.id)
  }
  
  private func play(id: String) {
    self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.play(" + id + ");")
  }
}

extension PlayerService: WebUIDelegate {
  public func webView(_ sender: WebView!, runJavaScriptAlertPanelWithMessage message: String!, initiatedBy frame: WebFrame!) {
    if message == "ENDED" {
      self.next()
    }
  }
}

extension PlayerService: WebFrameLoadDelegate {
  func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
    sender.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.options.callbacks.ended = function() { fEndedDrawUI(); MobilePlayerManager._bIsPlaying = false; alert('ENDED'); };")
  }
}
