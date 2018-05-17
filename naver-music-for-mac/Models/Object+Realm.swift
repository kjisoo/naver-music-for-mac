//
//  Object+Realm.swift
//  naver-music-for-mac
//
//  Created by sonny on 2018. 5. 17..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
  var realm: Realm {
    return Container.container.resolve(Realm.self)!
  }
  
  static var realm: Realm {
    return Container.container.resolve(Realm.self)!
  }
}
