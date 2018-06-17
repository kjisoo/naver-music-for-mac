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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  var window: WindowController?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    Realm.Configuration.defaultConfiguration =  Realm.Configuration(schemaVersion: 7,
                                                                    migrationBlock: { (migration, oldSchemaVersion) in
    })
    UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions": true])
    Fabric.with([Crashlytics.self, Answers.self])
    self.window = WindowController()
    window?.showWindow(nil)
    
    // MediaKey
    MediaKeyService.shared.start()
    
  }

}


