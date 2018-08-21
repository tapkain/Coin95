//
//  RealmStorage.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmStorage: Storage {
  var realm: Realm
  
  init(configuration: StorageConfiguration = .basic(url: nil)) throws {
    var rmConfig = Realm.Configuration()
    rmConfig.readOnly = true
    
    switch configuration {
    case .basic:
      rmConfig = Realm.Configuration.defaultConfiguration
      if let url = configuration.associated {
        rmConfig.fileURL = NSURL(string: url) as URL?
      }
      
    case .inMemory:
      rmConfig = Realm.Configuration()
      if let identifier = configuration.associated {
        rmConfig.inMemoryIdentifier = identifier
      } else {
        throw AppModels.AppError.inMemoryIdentifierMissing
      }
    }
    
    try realm = Realm(configuration: rmConfig)
  }
}



extension RealmStorage {
  
  func create<T: PersistentObject>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws {
    try realm.write {
      let newObject = realm.create(model as! Object.Type, value: [], update: false) as! T
      completion(newObject)
    }
  }
  
  func save(object: PersistentObject) throws {
    try realm.write {
      realm.add(object as! Object)
    }
  }
  
  func update(block: @escaping () -> Void) throws {
    try realm.write {
      block()
    }
  }
}



extension RealmStorage {
  
  func delete(object: PersistentObject) throws {
    try realm.write {
      realm.delete(object as! Object)
    }
  }
  
  func deleteAll<T : PersistentObject>(_ model: T.Type) throws {
    try realm.write {
      let objects = realm.objects(model as! Object.Type)
      
      for object in objects {
        realm.delete(object)
      }
    }
  }
  
  func reset() throws {
    try realm.write {
      realm.deleteAll()
    }
  }
}


extension RealmStorage {
  
  func fetch<T: PersistentObject>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil, completion: ((FetchResult) -> ())) {
    var objects = realm.objects(model as! Object.Type)
    
    if let predicate = predicate {
      objects = objects.filter(predicate)
    }
    
    if let sorted = sorted {
      objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
    }
    
    completion(objects)
  }
}
