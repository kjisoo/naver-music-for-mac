//
//  AppDelegate.swift
//  naver-music-for-mac
//
//  Created by A on 2018. 5. 7..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Cocoa
import RealmSwift
import Fabric
import Crashlytics
import MediaKeyTap

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  var window: WindowController?
  
  // MediaKeyTap
  var mediaKeyTab: MediaKeyTap?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    Realm.Configuration.defaultConfiguration =  Realm.Configuration(schemaVersion: 7,
                                                                    migrationBlock: { (migration, oldSchemaVersion) in
    })
    UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions": true])
    Fabric.with([Crashlytics.self, Answers.self])
    self.window = WindowController()
    window?.showWindow(nil)
    
    // MediaKeyTap
    self.mediaKeyTab = MediaKeyTap(delegate: self)
    self.mediaKeyTab?.start()
    
  }

}

extension AppDelegate: MediaKeyTapDelegate {
  func handle(mediaKey: MediaKey, event: KeyEvent) {
    
    switch mediaKey {
    case .playPause:
      let playlist = Playlist.getMyPlayList()
      playlist.setIsPaused(isPaused: !playlist.isPaused)
      break
      
    case .rewind:
      Playlist.getMyPlayList().prev()
      break
      
    case .fastForward:
      Playlist.getMyPlayList().next()
      break
      
    default:
      break
    }
  }
}

