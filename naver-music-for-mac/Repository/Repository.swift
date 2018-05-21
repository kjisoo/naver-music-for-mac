//
//  Repository.swift
//  naver-music-for-mac
//
//  Created by kjisoo on 2018. 5. 21..
//  Copyright © 2018년 Kimjisoo. All rights reserved.
//

import Foundation
import RealmSwift

class Repository<T: Object> {
  var realm: Realm {
    return try! Realm()
  }
  
  public static func factory() -> Repository<T> {
    return Repository<T>()
  }
  
  public func getAll() -> [T] {
    return realm.objects(T.self).toArray()
  }
  public func get(identifier: String) -> T? {
    return realm.object(ofType: T.self, forPrimaryKey: identifier)
  }
  
  public func getOrCreate(identifier: String) -> T {
    if let object = self.get(identifier: identifier) {
      return object
    } else {
      var object: T!
      try! self.realm.write {
        object = self.realm.create(T.self, value: [T.primaryKey()!: identifier], update: false)
      }
      return object
    }
  }
  
  public func update(object: T, value: [String: Any]) {
    let pk = T.primaryKey()!
    var valueDict = [pk: object[pk]]
    valueDict.merge(value) { (current, _) in current }
    try? self.realm.write {
      self.realm.create(T.self, value: valueDict, update: true)
    }
  }
}
