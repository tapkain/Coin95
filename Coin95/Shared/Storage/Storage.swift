//
//  Storage.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

protocol Storage {
  
  init(configuration: StorageConfiguration) throws
  
  func create<T: PersistentObject>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws
  func save(object: PersistentObject) throws
  func update(block: @escaping () -> ()) throws
  func delete(object: PersistentObject) throws
  func deleteAll<T: PersistentObject>(_ model: T.Type) throws
  func reset() throws
  func fetch<T: PersistentObject>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: ((FetchResult) -> ()))
}
