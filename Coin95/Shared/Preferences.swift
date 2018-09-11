//
//  Preferences.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/11/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

extension UserDefaults {
  enum Keys {
    case lastSync(timestamp: Int)
  }
  
  enum KeyCodes: String {
    case lastSync
    
    init(key: Keys) {
      switch key {
      case .lastSync(_):
        self = .lastSync
      }
    }
  }
  
  func set(_ key: Keys) {
    switch key {
    case .lastSync(let timestamp):
      set(timestamp, forKey: KeyCodes(key: key).rawValue)
    }
  }
  
  func get<T>(_ key: KeyCodes) -> T {
    guard let result = object(forKey: key.rawValue) as? T else {
      fatalError("Cannot obtain or cast property \(key.rawValue)")
    }
    
    return result
  }
}
