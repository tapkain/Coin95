//
//  AppModels.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 9/8/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

enum AppModels {
  enum AppError: Error, CustomStringConvertible {
    case inMemoryIdentifierMissing
    
    var description: String {
      return ""
    }
  }
}
