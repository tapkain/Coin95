//
//  StorageConfiguration.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/21/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

public enum StorageConfiguration {
  case basic(url: String?)
  case inMemory(identifier: String?)
  
  var associated: String? {
    get {
      switch self {
      case .basic(let url): return url
      case .inMemory(let identifier): return identifier
      }
    }
  }
}
