//
//  AppError.swift
//  Coin95
//
//  Created by Yevhen Velizhenkov on 8/12/18.
//  Copyright © 2018 Yevhen Velizhenkov. All rights reserved.
//

import Foundation

enum AppModels {
  enum AppError: Error, CustomStringConvertible {
    case noInternetConnection
    case noData
    case badData
    case requestError
    case inMemoryIdentifierMissing
    
    var description: String {
      switch self {
      case .noInternetConnection:
        return "No Internet Connection."
        
      case .noData:
        return "No data provided."
        
      case .badData:
        return "Data is broken, parsing error."
        
      case .requestError:
        return "Bad request."
        
      default:
        return "Unknown error"
      }
    }
  }
}
