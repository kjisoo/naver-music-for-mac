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
  private var realm: Realm {
    return try! Realm()
  }
  
  public func getAll() -> [T] {
    return realm.objects(T.self).toArray()
  }
  public func get(identifier: String) -> T? {
    return realm.object(ofType: T.self, forPrimaryKey: identifier)
  }
  
  public func create(object: T) {
    if let pk = T.primaryKey(),
      let oldObject = self.get(identifier: pk) {
      for attribute in object.attributeKeys {
        if object[attribute] == nil {
          object[attribute] = oldObject[attribute]
        }
      }
    }
    try? realm.write {
      realm.add(object)
    }
  }
}
