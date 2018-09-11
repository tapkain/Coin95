//
//  Storage.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift

class WriteTransaction {
  let realm: Realm
  
  init(realm: Realm) {
    self.realm = realm
  }
  
  func add<T: Object>(_ objects: [T], update: Bool = false) throws {
    realm.add(objects, update: update)
  }
  
  func add<T: Object>(_ object: T, update: Bool = false) throws {
    try add([object], update: update)
  }
  
  @discardableResult
  func create<T: Object>(primaryKey: Any) -> T {
    return realm.create(T.self, value: [T.primaryKey()!: primaryKey], update: true)
  }
}

protocol Storage where Self: Object {
  static func write(_ block: (WriteTransaction) throws -> Void) throws
}

extension Storage {
  static func write(_ block: (WriteTransaction) throws -> Void) throws {
    let realm = try Realm()
    let transaction = WriteTransaction(realm: realm)
    
    try realm.write {
      try block(transaction)
    }
  }
}
