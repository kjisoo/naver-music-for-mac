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
  private let disposeBag = DisposeBag()
  private let webPlayer = WebView()
  private let playList: Playlist = Playlist.getMyPlayList()
  private let isPaused = BehaviorSubject<Bool>(value: true)
  private let playingMusicState = BehaviorSubject<MusicState?>(value: nil)
  
  private override init() {
    super.init()
    setupWebPlayer()
    bindingPlayList()
  }
  
  private func addWebPlayerToWindow() {
    if self.webPlayer.superview == nil {
      // injection before object is loaded
      self.webPlayer.stringByEvaluatingJavaScript(from: """
MobilePlayerManager._endedUIDelegate = function() {
    if((new Error().stack).toString().includes("ended@")) {
        alert('ENDED');
    }
    fEndedDrawUI();
    MobilePlayerManager._bIsPlaying = false;
};
"""
      )
      NSApp.mainWindow?.contentView?.addSubview(self.webPlayer)
      // injection after object is loaded
      self.webPlayer.stringByEvaluatingJavaScript(from: """
setTimeout(function() {
    MobilePlayerManager._playerCore.playerCoreSwitcher.playerCore.audiopMseHlsCore.audiopMediaElement.mediaElement.volume = \(self.playList.volume);
    MobilePlayerManager._playerCore.playerCoreSwitcher.playerCore.audiopMseHlsCore.audiopConfigStorage.syncVolume(\(self.playList.volume));
    MobilePlayerManager._playerCore.playerCoreSwitcher.audiopMusicWebPlayerCore.audiopMusicAPIFetch._fetchPlay = function(t, e, n, r, i) {
        var o = 'AAC_320_ENC';
        this._fetchAPI(this.options.musicAPIStPlay.replace('{play.trackId}', t).replace('{play.serviceType}', e).replace('{deviceId}', n).replace('{mediaSourceType}', o), function(t) {
            var i = t.moduleInfo,
                o = t.clientUI,
                u = i.trackPlayUrl,
                a = {
                    serviceType: e,
                    trackId: i.trackId,
                    totalTime: i.playTime,
                    token: i.logToken,
                    info: i.logInfo,
                    deviceId: n
                },
                c = {
                    trackId: i.trackId,
                    playTime: i.playTime && i.playTime > 0 ? i.playTime / 1e3 : 0,
                    oriPlayTime: i.oriPlayTime && i.oriPlayTime > 0 ? i.oriPlayTime / 1e3 : 0
                },
                s = {
                    deviceId: n
                },
                f = {
                    playTime: i.playTime && i.playTime > 0 ? i.playTime / 1e3 : 0,
                    oriPlayTime: i.oriPlayTime && i.oriPlayTime > 0 ? i.oriPlayTime / 1e3 : 0
                };
            r(u, f, c, s, a, {
                clientUI: o
            })
        }, i)
    };
}, 2000);
"""
      )
    }
  }
  
  public static func configure() {
    print(self.instance)
  }
  
  private func setupWebPlayer() {
    self.webPlayer.customUserAgent = "Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Mobile Safari/537.36"
    self.webPlayer.mainFrame.load(URLRequest(url: URL(string: "http://m.music.naver.com/search/search.nhn")!))
    self.webPlayer.uiDelegate = self
    self.webPlayer.frameLoadDelegate = self
  }
  
  private func bindingPlayList() {
    Observable.changeset(from: playList.musicStates).subscribe(onNext: { [weak self] (a, changeset) in
      if let _ = changeset, self?.playList.playingMusicState() == nil {
        self?.pause()
      }
      self?.playingMusicState.onNext(self?.playList.playingMusicState())
    }).disposed(by: self.disposeBag)
    
    Observable.from(object: self.playList).subscribe(onNext: { [weak self] in
      self?.isPaused.onNext($0.isPaused)
      self?.volume(volume: $0.volume)
    }).disposed(by: self.disposeBag)

    self.isPaused.distinctUntilChanged().subscribe(onNext: { [weak self] (isPaused) in
      if isPaused {
        self?.pause()
      } else {
        self?.resume()
      }
    }).disposed(by: self.disposeBag)
    
    self.playingMusicState.do(onNext: { [weak self] in
      if $0 == nil {
        self?.pause()
      }
    }).distinctUntilChanged { $0?.id == $1?.id }
      .subscribe(onNext: { [weak self] in
        if let state = $0 {
          self?.play(musicID: state.music.id)
        }
      }).disposed(by: self.disposeBag)
  }
  
  private func resume() {
    if let currentPlayingState = self.playList.playingMusicState() {
      if let currentTime = Double(self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.currentTime()")),
        currentTime > 0 {
        self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.resume();")
      } else {
        self.play(musicID: currentPlayingState.music.id)
      }
    } else {
      self.playList.next()
    }
  }
  
  private func pause() {
    self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.pause();")
  }
  
  private func play(musicID id: String) {
    self.addWebPlayerToWindow()
    self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.play(" + id + ");")
  }
  
  private func volume(volume: Double) {
    self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.playerCoreSwitcher.playerCore.audiopMseHlsCore.audiopMediaElement.mediaElement.volume = \(volume);")
    self.webPlayer.stringByEvaluatingJavaScript(from: "MobilePlayerManager._playerCore.playerCoreSwitcher.playerCore.audiopMseHlsCore.audiopConfigStorage.syncVolume(\(volume));")
  }
}

extension PlayerService: WebUIDelegate {
  public func webView(_ sender: WebView!, runJavaScriptAlertPanelWithMessage message: String!, initiatedBy frame: WebFrame!) {
    if message == "ENDED" {
      self.playList.next()
    }
  }
}

extension PlayerService: WebFrameLoadDelegate {
  func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
  }
}
