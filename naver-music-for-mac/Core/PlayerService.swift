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
  public let webPlayer: WebView = {
    return WebView()
  }()
  
  private var playList: Playlist! {
    didSet {
      Observable.from(object: playList).subscribe(onNext: { [weak self] _ in
        print(1)
        }, onError: nil, onCompleted: nil, onDisposed: {
          print("dispose")
      })
    }
  }
  
  public var realm: Realm? {
    didSet {
      if let realm = self.realm {
        self.playList = realm.object(ofType: Playlist.self, forPrimaryKey: "MY")
      }
    }
  }
  

  private override init() {
    super.init()
    setupWebPlayer()
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
    if let index = self.playList.musics.enumerated().first(where: {$1.isPlaying}).map({$0.offset}),
      index+1 < self.playList.musics.count {
      self.play(id: self.playList.musics[index+1].id)
    } else if self.playList.musics.count > 0 {
      self.play(id: self.playList.musics[0].id)
    }
  }
  
  public func prev() {
    if let index = self.playList.musics.enumerated().first(where: {$1.isPlaying}).map({$0.offset}),
      0 < index-1 && index-1 < self.playList.musics.count {
      self.play(id: self.playList.musics[index-1].id)
    } else if self.playList.musics.count > 0,
      let lastID = self.playList.musics.last?.id {
      self.play(id: lastID)
    }
  }
  
  private func play(id: String) {
    self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.play(" + id + ");")
    self.changeStateToPlay(id: id)
  }
  
  private func changeStateToPlay(id: String) {
    self.realm?.beginWrite()
    for music in self.realm!.objects(Music.self).filter("isPlaying = true") {
      music.isPlaying = false
    }
    self.realm?.object(ofType: Music.self, forPrimaryKey: id)?.isPlaying = true
    try? self.realm?.commitWrite()
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
